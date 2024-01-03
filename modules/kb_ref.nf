process KB_REF {
    // Associate each execution with basename of supplied fasta.
    tag "${fasta}"

    // Process dependencies when using conda or container profiles.
    conda "bioconda::kb-python=0.28.0"
    container "biocontainers/kb-python:0.28.0--pyhdfd78af_0"

    input:
    path fasta
    path gtf

    output:
    path "${fasta.getBaseName()}.idx", emit: index
    path "t2g.txt"                   , emit: t2g
    path "cdna.fa"                   , emit: cdna

    script:
    // Define user arguments and basename of supplied fasta.
    def userArgs = task.ext.args ?: ''
    def baseName = fasta.getBaseName()
    """
    kb ref \\
        -i ${baseName}.idx \\
        -g t2g.txt \\
        -f1 cdna.fa \\
        $userArgs \\
        $fasta \\
        $gtf
    """
}