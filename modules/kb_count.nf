process KB_COUNT {
    tag "${metaInfo.id}"

    conda "bioconda::kb-python=0.28.0"
    container "biocontainers/kb-python:0.28.0--pyhdfd78af_0"

    input:
    tuple val(metaInfo), path(reads)
    path index
    path t2g
    val tech

    output:
    tuple val(metaInfo), path("*.count"), emit: count
    path "*.count/*/*.mtx"              , emit: matrix

    script:
    def userArgs = task.ext.args ?: ''
    def sample   = "${metaInfo.id}"
    def barcodes = metaInfo.whitelist ? "-w ${metaInfo.whitelist}" : ''
    def memory   = task.memory.toGiga() - 1
    """
    kb count \\
        -i $index \\
        -g $t2g \\
        -x $tech \\
        -o "${sample}.count" \\
        $barcodes \\
        -t $task.cpus \\
        -m ${memory}G \\
        $userArgs \\
        ${reads.join( " " )}
    """
}