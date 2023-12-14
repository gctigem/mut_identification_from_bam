/*
 * #### ALIGNMENT #### Align reads to TP63 reference
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
    path(fasta_index)
    tuple val(idSample), file(sub_fastq)

    
    output:
    tuple val(idSample), path("*.bam"), emit: bam

    script:
    """
    ln -s -f ${sub_fastq[0]} ${idSample}_1.fastq.gz
    ln -s -f ${sub_fastq[1]} ${idSample}_2.fastq.gz

   bwa mem -M $params.outdir/ref/genome.fa ${sub_fastq} | samtools view -bS - > ${idSample}_out.bam

    """
}
