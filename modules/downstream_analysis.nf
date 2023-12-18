process downstream_analysis {
     echo true
     label 'downstream_analysis'
     tag 'downstream_analysis'
     container 'docker://rosadesa/rbase:4.2'

        
 input:
 path(mutagenesis)

 script:
 
"""
[ ! -d $params.outdir/downstream ] && mkdir $params.outdir/downstream
cd $params.outdir/downstream

Rscript  $baseDir/bin/downstream_mite.R -design $params.design -orf $params.orf -codon $params.codon_usage
"""
 
}

//Rscript  $baseDir/bin/downstream_mite.R -design $params.design -orf $params.orf -codon $params.codon_usage -del $params.deletions