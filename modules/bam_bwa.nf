process bam_bwa {
    echo true
    label 'bam_bwa'
    tag 'bwa'
    container 'docker://rosadesa/ampliseq:0.3'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("filtered.bam") > 0) 	"picard/$filename"
	else null
    }

    input:
    tuple val(idSample), path(bam_file)
    
    output:
    path("*filtered.bam")

    script:
    """
    ln -s ${bam_file} ${idSample}.bam

    java -jar /picard.jar FilterSamReads I=${idSample}.bam O=${idSample}_filtered.bam TAG=GE TAG_VALUE=ENSG00000073282 FILTER=includeTagValues

    """
}

    //path(fasta_index)
    //bwa mem -n 0 $params.outdir/index/genome.fa ${idSample}.bam > ${idSample}_out.sam
