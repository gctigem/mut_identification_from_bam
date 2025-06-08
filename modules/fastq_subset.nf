
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
     # VERSIONE ULTRA-OTTIMIZZATA: seqkit con elaborazione parallela
    # seqkit è molto più veloce di grep per operazioni su FASTQ
    
    echo "Processing sample: ${idSample} with seqkit"
    echo "Input files: ${reads[0]}, ${reads[1]}"
    
    # Elaborazione parallela con seqkit (molto più veloce)
    seqkit grep -r -p "BX:Z:${idSample}" ${reads[0]} | gzip > ${idSample}_filtered_1.fastq.gz &
    seqkit grep -r -p "BX:Z:${idSample}" ${reads[1]} | gzip > ${idSample}_filtered_2.fastq.gz &
    
    # Aspetta che entrambi i processi finiscano
    wait
    
    # Verifica che i file siano stati creati
    if [ ! -f "${idSample}_filtered_1.fastq.gz" ] || [ ! -f "${idSample}_filtered_2.fastq.gz" ]; then
        echo "ERROR: Failed to create filtered FASTQ files for sample ${idSample}"
        exit 1
    fi
    
    echo "Successfully filtered FASTQ files for sample: ${idSample}"
    echo "Output files: ${idSample}_filtered_1.fastq.gz, ${idSample}_filtered_2.fastq.gz"
    
    """
}



/* zcat ${reads}[0] | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_1.fastq
        gzip ${idSample}_filtered_1.fastq

        zcat ${reads}[1] | grep -A 3 BX:Z:${idSample} > ${idSample}_filtered_2.fastq
        gzip ${idSample}_filtered_2.fastq*/