process bam_subset {
    echo true
    label 'bam_subset'
    tag 'bam_subset'
    container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf(".bam") > 0) 	"bam/$filename"
	else null
    }

    input:
    tuple val(idSample)
    path(bam)


    output:
    tuple val(idSample), path("*.bam"), emit: sub_bam 

    script:
    """
    java -jar /picard.jar FilterSamReads I=${bam} O=${idSample}_filtered.bam TAG=BX TAG_VALUE=${idSample} FILTER=includeTagValues
        
    """
}

