/*
 * ####  create dictionary
 */

process gatk_dict {
    echo true
    label 'gatk_dict'
    tag 'gatk_dict'
    //container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    container 'quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    input:
    path(fasta)
    path(fasta_index)

    output:
    path 'genome.dict', emit: dict
    path 'done.txt'


    script:
    """
    gatk CreateSequenceDictionary -R /opt/ref/genome.fa
    echo gatk_dict > done.txt

    """
}


//    [ ! -f $params.outdir/ref/genome.dict ] && gatk CreateSequenceDictionary -R $params.outdir/ref/genome.fa
