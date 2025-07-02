# mut_identification_from_bam
# SCRAM\_seq Pipeline

**Version**: 3.0
**Author**: Rosa De Santis
**Platform**: Nextflow DSL2

## Overview

mut_identification_from_bam is a Nextflow pipeline designed to perform saturation mutagenesis analysis on single cells using barcoded sequences. The pipeline supports various input formats and execution environments, and is optimized for both HPC (SLURM) and cloud-based (Google Cloud) infrastructure.

The workflow supports two main analysis strategies:

* **Pipeline starts with Genome-aligned BAM input** (main, virtual branches)
* **Pipeline starts with FASTQ extracted from BAM** (beta, virtual2 branches)

## Key Features

* Modular design using DSL2
* Supports BAM or FASTQ inputs
* Per-barcode FASTQ generation and alignment on a mutagenized gene
* GATK AnalyzeSaturationMutagenesis for genotyping
* Compatible with Docker and Singularity
* Executable on SLURM clusters and Google Cloud (Life Sciences or Batch)

## Workflow Steps

1. **`converting`**: Convert BAM input file into two fastq files
2. **`fastq_subset`**: Extracts barcode-specific FASTQs
3. **`index`**: Indexes reference FASTA
4. **`gatk_dict`**: Creates sequence dictionary for GATK
5. **`alignment`**: Aligns per-barcode FASTQ files to the target gene
6. **`gatk_count`**: Runs GATK AnalyzeSaturationMutagenesis per barcode
7. **`downstream_analysis`**: Generates output summaries and reports

## Input

The pipeline accepts input via a YAML file (`params.yml`) containing:

```yaml
input: /path/to/barcodes.txt 
fasta: /path/to/reference.fa
codon_usage: /path/to/codon_usage.txt
design: /path/to/design.txt
orf: 1-960
outdir: /desired/output/path
(Specify the following path only if the pipeline starts with fastq files, branches: beta, virtual2)
fastq_1: /path/to/sample_R1.fastq.gz
fastq_2: /path/to/sample_R2.fastq.gz
(Specify the following path only if the pipeline starts with a BAM file, branches: main, virtual)
bam: /path/to/out.bam
```
<li>input: This is the path to the .txt file containing the list of barcodes analyzed </li>
<li>fasta: This is the path to the directory containing the reference of the mutagenized gene in fasta format.</li>
<li>codon_usage: This is the path to the .txt file containing information about the codon usage and the codon used to perform the mutagenesis. </li>
<li>design: This is the path to the .txt file containing information about the positions of the library used to mutagenize the WT sequence of interest. </li>
<li>orf: This is the nucleotide range (within the fasta used as input) where the protein starts. Usually, since the input fasta is the entire mutagenized sequence, it goes from 1 to the end of the sequence. This features ensures that the mutagenized codons will get the correct position within the gene.</li>
<li>outdir: This is the path to the directory where the results have to be stored.</li>
<li>fastq_1 fastq_2: This is the path to the directory where the fastq files have to be stored.</li>
<li>bam: This is the path to the directory where the bam files have to be stored.</li>


## Output

The output directory (`--outdir`) contains:
* `converted/`: Two fastq files converted from the starting bam (only for branches: main, virtual)
* `subsetted/`: Barcode-specific FASTQ files
* `bwa/`: Alignment files (e.g., BAMs)
* `gatk/`: Variant counts from GATK
* `ref/`: Reference genome files
* `execution/`: Logs, reports, trace, and timeline

## Execution Examples

### Run on SLURM cluster with Singularity:

```bash
nextflow run gctigem/mut_identification_from_bam -r main (or beta) -params-file params.yml
```

### Run on Google Cloud with Docker:

```bash
nextflow run gctigem/mut_identification_from_bam -r virtual (or virtual2) -params-file params.yml -profile docker,workbench -w /path/to/workdir/work --outdir /path/to/outdir/results_scram_04/ 
```

## Requirements

* Nextflow >= 23.10.0
* GATK >= 4.3.0.0
* Docker or Singularity
* Indexed reference genome (FASTA, .fai, .dict)

## Output Reports


## Citation

If you use this pipeline, please cite:

> De Santis, R. "mut_identification_from_bam"
---

Feel free to open issues or pull requests to contribute!
