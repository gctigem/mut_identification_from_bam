/*
 * ####  converts bam to fastq using samtools
 */

process converting {
    echo true
    label 'converting'
    tag 'converting'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"fastq/$filename"
	else null
    }

    input:
     path(bam)


    output:
    path("*.fastq.gz"), emit: fastq

    script:
    """
    samtools sort -n $bam -o sorted.bam 

    samtools fastq -@ 8 sorted.bam  -1 TP63endo_SAM_R1.fastq.gz -2 TP63endo_SAM_R2.fastq.gz -0 /dev/null -s /dev/null -n  -T BX
    
    """
}