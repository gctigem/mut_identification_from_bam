/*
 * #### Create reference index
 */

process index {
    echo true
    label 'index'
    tag 'index'
    container 'staphb/bwa:0.7.17'
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


