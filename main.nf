nextflow.enable.dsl=2

//modules
include { fastq_subset } from './modules/fastq_subset'
include { index } from './modules/index'
include { gatk_dict } from './modules/gatk_dict'
include { gatk_count } from './modules/gatk_count'
include { alignment } from './modules/alignment'


// def variables

if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }

/*
 * Create a channel for input bam files and annotation
 */

bc = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:'\t' )
                            .map( { row -> [idSample = row[0]] } )

fastq_1 = Channel.fromPath(params.fastq_1)
fastq_2 = Channel.fromPath(params.fastq_2)

//fasta = Channel.fromPath(params.fasta)


/*
 * Create a workflow
 */

workflow {
    fastq_subset(bc, fastq_1.collect(),fastq_2.collect())
    //index(fasta.collect())
    //gatk_dict(index.out.fasta_index,fasta)
    alignment(fastq_subset.out.sub_fastq)
    gatk_count(alignment.out.bam)
}
