/*
 * #### ALIGNMENT ####
 */

process alignment {
    echo true
    label 'alignment'
    tag 'bwa'
    //container 'docker://rosadesa/ampliseq:0.2'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf(".bam") > 0) 	"bwa/$filename"
	else null
    }

    input:
    tuple val(idSample), file(sub_fastq)
    //path(fasta_index)
    
    output:
    tuple val(idSample), path("*.bam"), emit: bam

    script:
    """
    ln -s -f ${sub_fastq[0]} ${idSample}_1.fastq.gz
    ln -s -f ${sub_fastq[1]} ${idSample}_2.fastq.gz

   bwa mem -M $params.outdir/index/TP63.fa ${sub_fastq} | samtools view -bS - > ${idSample}_out.bam

    """
}
/*  ln -s -f ${sub_fastq[0]} ${idSample}_1.fastq.gz
    ln -s -f ${sub_fastq[1]} ${idSample}_2.fastq.gz

    bwa mem -M $params.outdir/index/TP63.fa ${sub_fastq[0]} ${sub_fastq[1]} > ${idSample}_out.sam

        bwa mem $params.outdir/index/TP63.fa ${sub_fastq[0]} ${sub_fastq[1]} | samtools view -bS - > ${idSample}_out.bam

    */