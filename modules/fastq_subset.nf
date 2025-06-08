
/*
 * ####  extract read for each barcode
 */

process fastq_subset {
    echo true
    label 'fastq_subset'
    tag 'fastq_subset'
     errorStrategy 'ignore'
    container 'docker://staphb/seqkit:2.7.0'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"subsetted/$filename"
	else null
    }

    input:
     tuple val(idSample)
     path(reads)
  

    output:
    tuple val(idSample), path("${idSample}_filtered_*.fastq.gz"), emit: sub_fastq

    script:
    """
      seqkit grep -j ${task.cpus} -r "BX:Z:${idSample}" ${reads}[0] \
    | gzip ${idSample}_filtered_1.fastq

    seqkit grep -j ${task.cpus} -r "BX:Z:${idSample}" ${reads}[1] \
    |  gzip ${idSample}_filtered_2.fastq
    
    """
}



/* zcat ${reads}[0] | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_1.fastq
        gzip ${idSample}_filtered_1.fastq

        zcat ${reads}[1] | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_2.fastq
        gzip ${idSample}_filtered_2.fastq*/