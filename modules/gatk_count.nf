process gatk_count {
    echo true
    label 'gatk_count'
    tag 'gatk_count'
    container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    errorStrategy 'ignore'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf(".variantCounts") > 0) 	"gatk/counts/$filename"
    else if (filename.indexOf("Counts") > 0) 	"gatk/stats/$filename"
    else if (filename.indexOf("Fractions") > 0) 	"gatk/stats/$filename"
    else if (filename.indexOf("Coverage") > 0) 	"gatk/stats/$filename"
	else null
    }
    
    input:
    tuple val(idSample), path(sub_bam)
    path(dict_index)
    
    output:
    path("*{Counts,Fractions,Coverage}")

    script:
    """
    gatk AnalyzeSaturationMutagenesis -I ${sub_bam} -R $params.outdir/index/genome.fa --orf $params.orf -O ./${idSample}
    
    """
}