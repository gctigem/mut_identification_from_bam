process align_and_filt {
    echo true
    label 'align_and_filt'
    tag 'align_and_filt'
    container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("*sam") > 0) 	"bwa/$filename"
	     else if (filename.indexOf(".txt") > 0) 	"stats/$filename"
	else null
    }

    input:
    tuple val(idSample), path(fastqs)
    path(fasta_index)

    output:
    path("*.sam")
    path("*.txt")

    script:
    """
   
    bwa mem $params.outdir/index/genome.fa ${idSample}_r1.fastq ${idSample}_r2.fastq > ${idSample}_out.sam

    samtools view ${idSample}_out.sam | awk '\$2 == 16' | awk '\$12 == "NM:i:0"' | grep XA > ${idSample}_perf_align_reads.sam

    wc -l ${idSample}_perf_align_reads.sam > mut_stats.txt
    cut -f3 ${idSample}_perf_align_reads.sam | sort | uniq -c >> mut_stats.txt
    
    """
}

