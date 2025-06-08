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
  path(reads)

  output:
  tuple val(idSample), path("${idSample}_filtered_*.fastq"), emit: reads_unz

  script:
  """
  zcat ${reads}[0] > ${idSample}_filtered_1.fastq
  zcat ${reads}[1] > ${idSample}_filtered_2.fastq
  """
}
