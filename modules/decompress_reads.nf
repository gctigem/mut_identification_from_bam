process decompress_reads {
  label "decompress_reads"
  tag "decompress_reads"
  publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"decompressed/$filename"
	else null
    }

  input:
  path(reads1_gz), path(reads2_gz)

  output:
  path("reads_filtered_*.fastq"), emit: reads

  script:
  """
  zcat "$reads1_gz" > reads_filtered_1.fastq
  zcat "$reads2_gz" > reads_filtered_2.fastq
  """
}
