process gatk_dict {
    echo true
    label 'gatk_dict'
    tag 'gatk_dict'
    container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("*dict") > 0) 	"$filename"
	else null
    }

    input:
    path(fasta)

    output:
    path("*.dict"), emit: dict

    script:
    """
    [ ! -f $params.outdir/genome.dict ] && gatk CreateSequenceDictionary -R ${fasta}

    """
}