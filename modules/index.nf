process index {
    echo true
    label 'index'
    tag 'index'
    //container 'docker://rosadesa/ampliseq:0.3'
   
    input:
    path(fasta)
    
    output:
    path("*.txt"), emit: fasta_index

    script:
    """
    mv $fasta genome.fa
    bwa index genome.fa

     mkdir -p $params.outdir/ref
     cp genome.* $params.outdir/ref

    samtools faidx $params.outdir/ref/genome.fa
    echo bwa_index > done.txt
 
    """
}


    /* [ ! -d $params.outdir/index ] && mkdir $params.outdir/index
    cp * $params.outdir/index/

    samtools faidx $params.outdir/index/${fasta}
    echo bwa_index > done.txt*/