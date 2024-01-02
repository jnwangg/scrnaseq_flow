process CUTADAPT {
    tag "${metaInfo.id}"

    conda "bioconda::cutadapt=4.6"
    container "biocontainers/cutadapt:4.6--py39hf95cd2a_1"

    input:
    tuple val(metaInfo), path(reads)

    output:
    tuple val(metaInfo), path("*.trimmed.fastq.gz"), emit: reads
    tuple val(metaInfo), path('*.log')             , emit: log

    script:
    def userArgs = task.ext.args ?: ''
    def sample   = "${metaInfo.id}"
    def trimmed  =  metaInfo.single_end ? "-o ${sample}.trimmed.fastq.gz" : "-o ${sample}_R1.trimmed.fastq.gz -p ${sample}_R2.trimmed.fastq.gz"
    """
    cutadapt \\
        --cores = $task.cpus \\
        $userArgs \\
        $trimmed \\
        $sample \\
        > ${prefix}.cutadapt.log
    """
}