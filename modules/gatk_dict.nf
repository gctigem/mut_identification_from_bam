process gatk_dict {
    echo true
    label 'gatk_dict'
    tag 'gatk_dict'
    container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    input:
    path(fasta)
    path(fasta_index)


    script:
    """
    [ ! -f $params.outdir/index/genome.dict ] && gatk CreateSequenceDictionary -R $params.outdir/index/genome.fa
    echo gatk_dict > done.txt

    """
}
