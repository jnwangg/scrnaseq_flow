process KB_REF {
    tag "${fasta}"

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
    def genome = fasta.getBaseName()
    """
    kb ref \\
        -i ${genome}.idx \\
        -g t2g.txt \\
        -f1 cdna.fa \\
        $fasta \\
        $gtf
    """
}