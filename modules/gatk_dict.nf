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
    [ ! -f $params.outdir/genome.dict ] && gatk CreateSequenceDictionary -R ${fasta}
    echo gatk_dict > done.txt

    """
}