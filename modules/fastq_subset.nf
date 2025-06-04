
/*
 * ####  extract read for each barcode
 */

process fastq_subset {
    echo true
    label 'fastq_subset'
    tag 'fastq_subset'
     errorStrategy 'ignore'
    //container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"subsetted/$filename"
	else null
    }

    input:
     tuple val(idSample),path(fastq_1),path(fastq_2)


    output:
    tuple val(idSample), path("${idSample}_filtered_*.fastq.gz"), emit: sub_fastq

    script:
    """
        zcat ${fastq_1} | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_1.fastq
        gzip ${idSample}_filtered_1.fastq

        zcat ${fastq_2} | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_2.fastq
        gzip ${idSample}_filtered_2.fastq
    
    """
}



