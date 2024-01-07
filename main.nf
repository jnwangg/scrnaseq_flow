#!/usr/bin/env nextflow

/*
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  IMPLICIT WORKFLOW: main.nf
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Initializes the pipeline by calling the main workflow. Prints a help
//  message if requested, and validates all parameters.
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

nextflow.enable.dsl = 2

// Import helper functions from nf-validation.
include { validateParameters; paramsHelp } from 'plugin/nf-validation'

// If requested, print help message.
if (params.help) {
    def String template = "nextflow run jnwangg/scrnaseq_flow --input /path/to/samplesheet.csv --outdir /path/to/output --genome genome.fasta --gtf genes.gtf"
    log.info paramsHelp(template)
    System.exit(0)
}

// Validate parameters.
if (params.validate_params) {
    validateParameters()
}

// Import main pipeline workflow.
include { SCRNASEQ } from './workflow/scrnaseq'

workflow {
    SCRNASEQ()
}