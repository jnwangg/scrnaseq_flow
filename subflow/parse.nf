workflow PARSE {
    take:
    samplesheet

    // Samplesheet: sample, read_1, read_2, whitelist
    main:
    samplesheet
        .splitCsv( header:true )
        .map { parseRow( it ) }
        .map { metaInfo, reads -> [ metaInfo, reads ] }
        .set { reads }

    emit:
    sample
}

def parseRow (LinkedHashMap row) {
    // Store sample metadata: id, whitelist, single/paired end.
    def metaInfo = [:]

    metaInfo.id = row.sample

    // If a whitelist exists, include it.
    if (file(row.whitelist).exists()) {
        metaInfo.whitelist = file(row.whitelist)
    }

    // Store sample metadata and reads.
    def metaReads = []

    // If a second read exists, include both and update single_end.
    if (file(row.read_2).exists()) {
        metaInfo.single_end = false
        metaReads = [metaInfo, [file(row.read_1), file(row.read_2)]]
    }
    // Else include the first read only and update single_end.
    else {
        metaInfo.single_end = true
        metaReads = [metaInfo, [file(row.read_1)]]
    }

    return metaReads
}