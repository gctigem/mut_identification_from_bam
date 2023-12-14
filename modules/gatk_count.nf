//Find variants wiht Analyze saturation mutagenesis
process gatk_count {
    echo true
    label 'gatk_count'
    tag 'gatk_count'
    container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
  
    
    input:
    path(fasta_index)
    tuple val(idSample), path(bam)
    
    //output:
    // tuple val(idSample),path("*.{variantCounts,Counts,Fractions,Coverage}"), emit: mutagenesis
    
    script:
    """
    if [[ ! -d $params.outdir/gatk ]]; then
        mkdir $params.outdir/gatk
    fi
    gatk AnalyzeSaturationMutagenesis -I $params.outdir/bwa/${idSample}_out.bam -R $params.outdir/ref/genome.fa --orf $params.orf -O $params.outdir/gatk/${idSample}
    find $params.outdir/gatk -name '*.variantCounts' -empty -delete 
    """
}

