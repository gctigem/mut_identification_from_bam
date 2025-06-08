process decompress_reads {
  label "decompress_reads"
  tag "decompress_reads"
  publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"decompressed/$filename"
	else null
    }

  input:
  path(fastq_1)
  path(fastq_2)

  output:
  path("reads_filtered_*.fastq"), emit: reads

  script:
  """
  zcat "$fastq_1" > reads_filtered_1.fastq
  zcat "$fastq_2" > reads_filtered_2.fastq
  """
}
