nextflow.enable.dsl=2

//modules
include { converting } from './modules/converting'
include { decompress_reads } from './modules/decompress_reads'
include { fastq_subset } from './modules/fastq_subset'
include { index } from './modules/index'
include { gatk_dict } from './modules/gatk_dict'
include { gatk_count } from './modules/gatk_count'
include { alignment } from './modules/alignment'
include { downstream_analysis } from './modules/downstream_analysis'


// def variables

if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }

/*
 * Create a channel for input bam files and annotation
 */

bc = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:'\n' )
                            .map( { row -> [idSample = row[0]] } )
                   


//bam=Channel.from(params.bam)

fastq_1 = Channel.from(params.fastq_1)
fastq_2 = Channel.from(params.fastq_2)

//reads = fastq_1.combine(fastq_2)
//gz_reads = fastq_1.combine(fastq_2)
 //   .map { r1, r2 -> tuple(r1, r2) } 

   

//gz_reads.view()

fasta = Channel.from(params.fasta)



/*
 * Create a workflow
 */

workflow {
     //converting(bam)
     //fastq_subset(converting.out.fastq.collect())
     decompress_reads(fastq_1,fastq_2)
     fastq_subset(bc,decompress_reads.out.reads)
     //fastq_subset(bc,reads.collect())
     index(fasta)
     gatk_dict(index.out.fasta_index,fasta)
     alignment(index.out.fasta_index.collect(),fastq_subset.out.sub_fastq)
     gatk_count(alignment.out.bam)
     downstream_analysis(gatk_count.out.mutagenesis.collect())
     
}
