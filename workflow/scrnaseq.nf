/*
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  WORKFLOW: Single-cell RNA Sequencing
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Main pipeline workflow. Validates inputs and defines channels. Then,
//  calls modules for samplesheet parsing, trimming (with cutadapt), and
//  alignment + counting of reads (with kallisto-bustools).
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Check for valid file inputs.
def fileList = [
    params.input,
    params.genome,
    params.gtf
]
for (param in fileList) { if (param) { file( param, checkIfExists: true ) } }

// Import subworkflows.
include { PARSE } from '../subflow/parse'

// Import modules.
include { CUTADAPT } from '../modules/cutadapt'
include { KB_COUNT } from '../modules/kb_count'
include { KB_REF   } from '../modules/kb_ref'

// Define general channels.
ch_input  = file(params.input)
ch_genome = file(params.genome)
ch_gtf    = file(params.gtf)

workflow SCRNASEQ {
    // Parse input samplesheet.
    ch_reads = PARSE( ch_input ).reads

    // Build reference with kb ref.
    KB_REF (
        ch_genome,
        ch_gtf
    )
    ch_index = KB_REF.out.index
    ch_t2g   = KB_REF.out.t2g

    // Trim parsed reads with cutadapt.
    CUTADAPT ( ch_reads )
    ch_trimmed = CUTADAPT.out.reads

    // Align trimmed reads with kb count.
    KB_COUNT (
        ch_trimmed,
        ch_index,
        ch_t2g,
        params.protocol
    )
}