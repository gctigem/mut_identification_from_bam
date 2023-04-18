nextflow.enable.dsl=2

//modules
include { index } from './modules/index'
include { bam_filt_to_fastq } from './modules/bam_filt_to_fastq'
include { align_and_filt } from './modules/align_and_filt'


// def variables

if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }

/*
 * Create a channel for input bam files and annotation
 */

bam = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:'\t' )
                            .map( { row -> [idSample = row[0], bam_file = row[1]] } )
fasta = Channel.fromPath(params.fasta)

/*
 * Create a workflow
 */

workflow {
    //bwa
    index(fasta)
    bam_filt_to_fastq(bam,index.out.fasta_index.collect())
    align_and_filt(bam_filt_to_fastq.out.fastqs)
}
