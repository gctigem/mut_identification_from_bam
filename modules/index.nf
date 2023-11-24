process index {
    echo true
    label 'index'
    tag 'index'
    container 'docker://rosadesa/ampliseq:0.3'
    input:
    path(fasta)
    
    output:
    path("*.txt"), emit: fasta_index

    script:
    """
    bwa index ${fasta}
    [ ! -d $params.outdir/index ] && mkdir $params.outdir/index
    cp * $params.outdir/index/

    samtools faidx $params.outdir/index/${fasta}
    echo bwa_index > done.txt


    """
}