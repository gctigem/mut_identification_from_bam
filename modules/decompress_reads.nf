process decompress_reads {
  label "decompress_reads"
  tag "decompress_reads"
  publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"decompressed/$filename"
	else null
    }

  input:
  tuple val(idSample)
  path(reads1_gz), path(reads2_gz)

  output:
  tuple val(idSample), path("${idSample}_filtered_*.fastq"), emit: reads

  script:
  """
  zcat "$reads1_gz" > ${idSample}_filtered_1.fastq
  zcat "$reads2_gz" > ${idSample}_filtered_2.fastq
  """
}
