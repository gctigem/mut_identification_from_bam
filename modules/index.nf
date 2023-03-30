process index {
    echo true
    label 'index'
    tag 'bwa'
    container 'docker://rosadesa/ampliseq:0.3'
    input:
    path(fasta)
    
    output:
    path("*.txt"), emit: fasta_index

    script:
    """
    mv ${fasta} genome.fa
    bwa index genome.fa
    [ ! -d $params.outdir/index ] && mkdir $params.outdir/index
    cp genome.* $params.outdir/index/

    samtools faidx $params.outdir/index/genome.fa
    echo bwa_index > done.txt
    """
}
