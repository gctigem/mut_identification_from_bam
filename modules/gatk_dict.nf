process gatk_dict {
    echo true
    label 'gatk_dict'
    tag 'gatk_dict'
    container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    
    input:
    path(fasta)

    output:
    path("*.txt"), emit: dict

    script:
    """
    mv ${fasta} genome.fa
    [ ! -d $params.outdir/index ] && mkdir $params.outdir/index
    cp genome.fa $params.outdir/index/
    samtools faidx $params.outdir/index/genome.fa
    [ ! -f $params.outdir/genome.dict ] && gatk CreateSequenceDictionary -R genome.fa

    echo bwa_index > done.txt

    """
}