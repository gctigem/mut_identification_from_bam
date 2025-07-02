nextflow.enable.dsl=2

//modules
include { converting } from './modules/converting'
include { fastq_subset } from './modules/fastq_subset'
include { index } from './modules/index'
include { gatk_dict } from './modules/gatk_dict'
include { gatk_count } from './modules/gatk_count'
include { alignment } from './modules/alignment'
include { downstream_analysis } from './modules/downstream_analysis'

log.info """
         SCRAM_seq Pipeline (version 1)
         ===================================
         Nextflow DSL2
         Authors: Rosa De Santis 
         """
         .stripIndent()

// def variables

if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }

/*
 * Create a channel for input bam files and annotation
 */

bc = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:'\n' )
                            .map( { row -> [idSample = row[0]] } )
                   


bam=Channel.from(params.bam)

//fastq_1 = Channel.from(params.fastq_1)
//fastq_2 = Channel.from(params.fastq_2)

fasta = Channel.from(params.fasta)



/*
 * Create a workflow
 */

workflow {
     converting(bam)
     //decompress_reads(converting.out.fastq)
     //fastq_subset(converting.out.fastq.collect())
     fastq_subset(bc,converting.out.fastq.collect())
     index(fasta)
     gatk_dict(index.out.fasta_index,fasta)
     alignment(index.out.fasta_index.collect(),fastq_subset.out.sub_fastq)
     gatk_count(alignment.out.bam)
     downstream_analysis(gatk_count.out.mutagenesis.collect())
     
}
