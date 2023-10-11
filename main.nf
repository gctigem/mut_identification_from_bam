nextflow.enable.dsl=2

//modules
include { deduplication } from './modules/deduplication'
include { bam_subset } from './modules/bam_subset'
include { gatk_dict } from './modules/gatk_dict'
include { gatk_count } from './modules/gatk_count'


// def variables

if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }

/*
 * Create a channel for input bam files and annotation
 */

bc = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:'\t' )
                            .map( { row -> [idSample = row[0]] } )
bam = Channel.fromPath(params.bam)
fasta = Channel.fromPath(params.fasta)

/*
 * Create a workflow
 */

workflow {
    bam_subset(bc, bam)
    deduplication(bam_subset.out.sub_bam)
    gatk_dict(fasta)
    gatk_count(deduplication.out.dedup_bam,gatk_dict.out.dict,fasta)
}
