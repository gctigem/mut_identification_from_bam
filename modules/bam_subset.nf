process bam_subset {
    echo true
    label 'bam_subset'
    tag 'bam_subset'
    container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("sorted.bam") > 0) 	"bam/$filename"
	else null
    }

    input:
    tuple val(idSample)
    path(bam)


    output:
    tuple val(idSample), path("*sorted.bam"), emit: sub_bam 

    script:
    """
    java -jar /picard.jar FilterSamReads I=${bam} O=${idSample}_filtered.bam TAG=BX TAG_VALUE=${idSample} FILTER=includeTagValues
    samtools sort -n ${idSample}_filtered.bam > ${idSample}_filtered_sorted.bam
        
    """
}

