process bam_filt_to_fastq {
    echo true
    label 'bam_filt_to_fastq'
    tag 'bam_filt_to_fastq'
    container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf(".fastq") > 0) 	"picard/$filename"
	     else if (filename.indexOf(".txt") > 0) 	"stats/$filename"
	     else if (filename.indexOf(".bam") > 0) 	"bam/$filename"
	else null
    }

    input:
    tuple val(idSample), path(bam_file)

    output:
    tuple val(idSample), path("*.fastq"), emit: fastqs 
    path("*txt")

    script:
    """
    ln -s ${bam_file} ${idSample}.bam

    java -jar /picard.jar FilterSamReads I=${idSample}.bam O=${idSample}_filtered.bam TAG=GE TAG_VALUE=ENSG00000073282 FILTER=includeTagValues
    
    rm ${bam_file}

    samtools view ${idSample}_filtered.bam | cut -f1,17 | sed 's/BC:Z://g' > association_read_bc.txt 

    java -jar /picard.jar SamToFastq I=${idSample}_filtered.bam F=${idSample}_r1.fastq F2=${idSample}_r2.fastq
    
    """
}

