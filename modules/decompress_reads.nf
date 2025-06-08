process decompress_reads {
  label "decompress_reads"
  tag "decompress_reads"
  publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"decompressed/$filename"
	else null
    }

  input:
  path(gz_reads)

  output:
  path("reads_filtered_*.fastq"), emit: reads

  script:
  """
  zcat "$gz_reads[0]" > reads_filtered_1.fastq
  zcat "$gz_reads[1]" > reads_filtered_2.fastq
  """
}
