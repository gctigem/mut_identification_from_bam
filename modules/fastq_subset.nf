
/*
 * ####  extract read for each barcode
 */

process fastq_subset {
    echo true
    label 'fastq_subset'
    tag 'fastq_subset'
     errorStrategy 'ignore'
    //container 'docker://staphb/seqkit:2.7.0'
    publishDir "$params.outdir", mode: 'copy',
    saveAs: {filename ->
	     if (filename.indexOf("fastq") > 0) 	"subsetted/$filename"
	else null
    }

    input:
     tuple val(idSample)
     path(reads)
  

    output:
    tuple val(idSample), path("${idSample}_filtered_*.fastq.gz"), emit: sub_fastq

    script:
    """
       echo "Processing sample: ${idSample}"
    
    # SOLUZIONE SEMPLICE: Prima decomprimiamo, poi usiamo seqkit, poi ricomprimiamo
    
    # Decomprimi i file
    echo "Decompressing input files..."
    gunzip -c ${reads[0]} > read1.fastq
    gunzip -c ${reads[1]} > read2.fastq
    
    # Verifica che i file siano stati decompressi
    echo "Input file sizes:"
    ls -lh read1.fastq read2.fastq
    
    # Usa seqkit sui file decompressi con sintassi semplice
    echo "Searching for pattern BX:Z:${idSample}..."
    
    # Prova prima con -s (sequence) flag
    seqkit grep -s -p "BX:Z:${idSample}" read1.fastq > ${idSample}_filtered_1.fastq
    seqkit grep -s -p "BX:Z:${idSample}" read2.fastq > ${idSample}_filtered_2.fastq
    
    # Verifica se i file sono vuoti
    size1=\$(wc -l < ${idSample}_filtered_1.fastq)
    size2=\$(wc -l < ${idSample}_filtered_2.fastq)
    
    echo "First attempt results:"
    echo "  Read 1: \$size1 lines"
    echo "  Read 2: \$size2 lines"
    
    """
}



/* zcat ${reads}[0] | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_1.fastq
        gzip ${idSample}_filtered_1.fastq

        zcat ${reads}[1] | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_2.fastq
        gzip ${idSample}_filtered_2.fastq*/