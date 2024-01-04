/*
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  SUBFLOW: Parse Samplesheet
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Parses the user-supplied samplesheet, transforming each record into a
//  tuple of: 1) metadata [as a map] and 2) reads [as a list of paths].
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow PARSE {
    take:
    samplesheet

    main:
    Channel.fromPath(samplesheet)
        // Split the samplesheet into individual records.
        .splitCsv( header:true )
        // Parse each record.
        .map { parseRow( it ) }
        // Rename tuple elements with more descriptive identifiers.
        .map { metaInfo, reads -> [ metaInfo, reads ] }
        // Rename the entire tuple.
        .set { reads }

    emit:
    reads   // Each read is a tuple of: [ val( metaInfo ), [ reads ] ]
}

// Parse each row of the samplesheet.
def parseRow (LinkedHashMap row) {
    // Store sample metadata: id, whitelist, single/paired end.
    def metaInfo = [:]

    metaInfo.id = row.sample

    // If a whitelist exists, include it as metadata.
    if (row.whitelist) {
        metaInfo.whitelist = row.whitelist
    }

    // Store both metadata and reads.
    def metaReads = []

    // If a second read exists, include both and set single_end appropriately.
    if (file(row.read_2).exists()) {
        metaInfo.single_end = false
        metaReads = [metaInfo, [file(row.read_1), file(row.read_2)]]
    }
    // Else include the first read only and set single_end appropriately.
    else {
        metaInfo.single_end = true
        metaReads = [metaInfo, [file(row.read_1)]]
    }

    return metaReads
}