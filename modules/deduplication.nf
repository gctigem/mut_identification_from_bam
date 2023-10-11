process deduplication {
    echo true
    label 'deduplication'
    tag 'deduplication'
    container 'docker://quay.io/biocontainers/umi_tools'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("*bam") > 0) 	"dedup/$filename"
	else null
    }

    input:
    tuple val(idSample), path(sub_bam)

    output:
    path("*.bam"), emit: dedup_bam

    script:
    """
     umi_tools dedup -I ${sub_bam} -S ${idSample}_deduplicated.bam    
    """
}