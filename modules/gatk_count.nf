process gatk_count {
    echo true
    label 'gatk_count'
    tag 'gatk_count'
    container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    //errorStrategy 'ignore'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf(".variantCounts") > 0) 	"gatk/counts/$filename"
    else if (filename.indexOf("Counts") > 0) 	"gatk/stats/$filename"
    else if (filename.indexOf("Fractions") > 0) 	"gatk/stats/$filename"
    else if (filename.indexOf("Coverage") > 0) 	"gatk/stats/$filename"
	else null
    }
    
    input:
    path(fasta_index)
    tuple val(idSample), path(bam)
    
    output:
    tuple val(idSample),path("${idSample}.aaCounts"), emit: mutagenesis

    //tuple val(idSample),path("*.{variantCounts,Counts,Fractions,Coverage}"), emit: mutagenesis
    
    script:
    """
    gatk AnalyzeSaturationMutagenesis -I $params.outdir/bwa/${idSample}_out.bam -R $params.outdir/ref/genome.fa --orf $params.orf 
    
    """
}
//-O ./${idSample}