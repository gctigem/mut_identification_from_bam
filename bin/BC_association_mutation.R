myarg <- commandArgs(TRUE)
myarg <- unlist(strsplit(myarg, " {1,}"))
myargv <- myarg[seq(2, length(myarg), by=2)]; names(myargv) <- gsub("-", "", myarg[seq(1, length(myarg), by=2)])

design=myargv["design"] #category of sample analyzed
orf=myargv["orf"] # orf used
orf=as.numeric(sapply(strsplit(orf,"-"), "[[", 2)) #take last nuc of the orf
orf=paste(paste0((orf-2):orf,":"),collapse="|")
codon=myargv["codon"]

##library uploading
suppressMessages(library(stringr))
suppressMessages(library(ggplot2))
suppressMessages(library(reshape2))
suppressMessages(library(scales))
suppressMessages(library(pheatmap))


# Codon usage df
codon_usage=read.table(codon, header=T)


# Function to read and modify the outputs from gatk
read.mutations=function(file_counts){
  counts=read.table(file_counts, sep="\t",fill = T,row.names = NULL,header=F)
  if(ncol(counts)==9){
  counts$D=str_count(counts[,8], "D:")
  counts$M=str_count(counts[,8], "M:")
  counts$I=str_count(counts[,8], "I:")
  counts$S=str_count(counts[,8], "S:")
  counts$FS=str_count(counts[,8], "FS")
  counts$N=str_count(counts[,8], "N:")
  
  red_counts=counts[(counts$M==1 & counts$D==0 & counts$FS==0 & counts$S==0 & counts$N==0 & counts$I==0) | (counts$M==0 & counts$D==0 & counts$FS==0 & counts$S==1 & counts$N==0 & counts$I==0),]
  red_counts$nuc_change=sapply(strsplit(red_counts[,7],">"), "[[",2)
  red_counts=red_counts[red_counts$nuc_change%in%codon_usage$most_common,]
  red_counts=red_counts[!grepl(orf, red_counts[,5]),] #remove mutations in the last stop codon
  
  final_out=data.frame(position=sapply(strsplit(red_counts[,7],":"),"[[",1),red_counts[,c(8,1,9)])
  return(final_out)
  }
}

files=list.files("../gatk",pattern="variantCounts",recursive = T)
files=paste0("../gatk/",files)

mut=list()
for(i in files){
  if(file.size(i)!=0){
    mut[[i]]=read.mutations(i)
  }
}

#Filter out no mut files
keep=sapply(mut, function(x) nrow(x)!=0)
mut=mut[keep]

names(mut)=sapply(strsplit(names(mut),"/"),"[[",2)
names(mut)=sapply(strsplit(names(mut), "[.]"),"[[",1)

design=read.table(design,sep="\t")
colnames(design)=c("lib","x","xend","sample")

mut_number=list()
for(i in 1:length(mut)){
  k=mut[[i]]
  seq=unique(k[,1])
  pos_mut=c()
  for(j in seq){
    tmp=k[k[,1]==j,3]
    pos_mut=rbind(pos_mut,c(j,sum(tmp)))
  }
  colnames(pos_mut)=c("Position","Mutation_num")
  pos_mut=as.data.frame(pos_mut)
  pos_mut$Mutation_num=as.numeric(pos_mut$Mutation_num)
  pos_mut$Position=as.numeric(pos_mut$Position)
  mut_number[[i]]=pos_mut
}
names(mut_number)=names(mut)

count_mut=list()

for(i in 1:length(mut)){
  sample=names(mut)[i]
  range=design[design$sample==analysis,c(2,3)]
  range_seq=unlist(lapply(1:nrow(range),function(x) seq(range[x,1],range[x,2],1)))
  
  count_mut[[i]]=mut[[i]][mut[[i]][,1]%in%range_seq,c(4,3)]
  if(nrow(count_mut[[i]]>0)){
  colnames(count_mut[[i]])=c("mut_name", "occurrence")
  count_mut[[i]]$occurrence=as.numeric(count_mut[[i]]$occurrence)
  count_mut[[i]]$BC=names(mut)[i]
  }
}

keep=sapply(count_mut, function(x) nrow(x)!=0)
count_mut=count_mut[keep]

sum(sapply(count_mut, nrow) > 1)

test=Reduce(rbind, count_mut[sapply(count_mut, nrow) == 1])
length(unique(test$mut_name))
mult=Reduce(rbind, count_mut[sapply(count_mut, nrow) > 1])

write.table(test,"BC_mut_association_single.txt",col.names = T, row.names = F, sep="\t", quote=F)
write.table(mult,"BC_mut_association_multi.txt",col.names = T, row.names = F, sep="\t", quote=F)
