#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Imports pipeline workflow.
include { SCRNASEQ } from './workflow/scrnaseq'

// Implicit workflow for the pipeline.
workflow {
    SCRNASEQ()
}