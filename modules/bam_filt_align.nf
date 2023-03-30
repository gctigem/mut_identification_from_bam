process bam_filt_align {
    echo true
    label 'bam_filt_align'
    tag 'bam_filt_align'
    container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("filtered.bam") > 0) 	"picard/$filename"
	     else if (filename.indexOf("out.bam") > 0) 	"bwa/$filename"
	else null
    }

    input:
    tuple val(idSample), path(bam_file)
    path(fasta_index)

    output:
    path("*filtered.bam")
    path("*out.bam")

    script:
    """
    ln -s ${bam_file} ${idSample}.bam

    java -jar /picard.jar FilterSamReads I=${idSample}.bam O=${idSample}_filtered.bam TAG=GE TAG_VALUE=ENSG00000073282 FILTER=includeTagValues
    
    bwa mem -n 0 $params.outdir/index/genome.fa ${idSample}_filtered.bam > ${idSample}_out.sam

    samtools view ${idSample}_out.sam > ${idSample}_out.bam
    
    """
}

