# Package index

## Positions

Functions for reading and writing positional data to the database.

- [`deletePositions()`](https://ninanor.github.io/seatrackR/reference/deletePositions.md)
  : deletePositions
- [`getPositions()`](https://ninanor.github.io/seatrackR/reference/getPositions.md)
  : Get position data from the database. Either "GLS" data (default),
  "IRMA" data, or "GPS" data.
- [`getYears()`](https://ninanor.github.io/seatrackR/reference/getYears.md)
  : Retrieve info on the years where we have position data
- [`loadPosdata()`](https://ninanor.github.io/seatrackR/reference/loadPosdata.md)
  : Load posdata files into R.
- [`writePositions()`](https://ninanor.github.io/seatrackR/reference/writePositions.md)
  : Update the positions.postable

## Metadata

- [`checkMetadata()`](https://ninanor.github.io/seatrackR/reference/checkMetadata.md)
  [`checkRetrievedMatchDeployed()`](https://ninanor.github.io/seatrackR/reference/checkMetadata.md)
  [`checkOpenSession()`](https://ninanor.github.io/seatrackR/reference/checkMetadata.md)
  [`checkLoggers()`](https://ninanor.github.io/seatrackR/reference/checkMetadata.md)
  [`checkNames()`](https://ninanor.github.io/seatrackR/reference/checkMetadata.md)
  : checkMetadata before import
- [`getColonies()`](https://ninanor.github.io/seatrackR/reference/getColonies.md)
  : Retrieve info on the registered colonies and locations within
  colonies in the database
- [`getIndividInfo()`](https://ninanor.github.io/seatrackR/reference/getIndividInfo.md)
  : Retrieve info on the individuals
- [`getLoggerModels()`](https://ninanor.github.io/seatrackR/reference/getLoggerModels.md)
  : Get logger models
- [`getNames()`](https://ninanor.github.io/seatrackR/reference/getNames.md)
  : Retrieve info on the registered names (people) in the database
- [`getRingHistory()`](https://ninanor.github.io/seatrackR/reference/getRingHistory.md)
  : Retrieve info on the ring history table
- [`getSpecies()`](https://ninanor.github.io/seatrackR/reference/getSpecies.md)
  : Retrieve info on the registered species in the database
- [`get_responsible()`](https://ninanor.github.io/seatrackR/reference/get_responsible.md)
  : Get responsible species and colony
- [`writeIndividInfo()`](https://ninanor.github.io/seatrackR/reference/writeIndividInfo.md)
  : Update the individ_info table
- [`writeMetadata()`](https://ninanor.github.io/seatrackR/reference/writeMetadata.md)
  : Import metadata
- [`writeRingHistory()`](https://ninanor.github.io/seatrackR/reference/writeRingHistory.md)
  : Update the ring history table

## Database Connections

Functions for connecting to and disconnecting from the Seatrack
database.

- [`connectSeatrack()`](https://ninanor.github.io/seatrackR/reference/connectSeatrack.md)
  [`disconnectSeatrack()`](https://ninanor.github.io/seatrackR/reference/connectSeatrack.md)
  : Connect to seatrack database

## activity

Functions for reading and writing activity data to the database.

- [`deleteActivity()`](https://ninanor.github.io/seatrackR/reference/deleteActivity.md)
  : Delete activity data from the database, based on subselection
  criteria
- [`getRecordings()`](https://ninanor.github.io/seatrackR/reference/getRecordings.md)
  : Read logger recordings data
- [`pruneRecordings()`](https://ninanor.github.io/seatrackR/reference/pruneRecordings.md)
  : pruneRecordings Prune activity, light and temperature recording data
  that
- [`writeRecordings()`](https://ninanor.github.io/seatrackR/reference/writeRecordings.md)
  : Update light, temperature or activity data

## logger_info

Functions for reading and writing logger information to the database.

- [`getActiveSessions()`](https://ninanor.github.io/seatrackR/reference/getActiveSessions.md)
  : View the active logger sessions
- [`getLoggerInfo()`](https://ninanor.github.io/seatrackR/reference/getLoggerInfo.md)
  : View the view info table
- [`getSessionInfo()`](https://ninanor.github.io/seatrackR/reference/getSessionInfo.md)
  : Retrieve logger session information
- [`writeLoggerImport()`](https://ninanor.github.io/seatrackR/reference/writeLoggerImport.md)
  : Update the logger info table

## Data request handling

Functions for managing data requests in the database.

- [`create_readme()`](https://ninanor.github.io/seatrackR/reference/create_readme.md)
  : Create SEATRACK documentation README
- [`data_request()`](https://ninanor.github.io/seatrackR/reference/data_request.md)
  : Get SEATRACK data request
- [`export_data_package()`](https://ninanor.github.io/seatrackR/reference/export_data_package.md)
  : Export a data request package

## Files

Functions for reading and writing file information to the database and
FTP server.

- [`deleteFiles()`](https://ninanor.github.io/seatrackR/reference/deleteFiles.md)
  : deleteFiles
- [`downloadFiles()`](https://ninanor.github.io/seatrackR/reference/downloadFiles.md)
  : Download files from the file archive
- [`getFileArchiveSummary()`](https://ninanor.github.io/seatrackR/reference/getFileArchiveSummary.md)
  : Retrieve summary info on the registered raw-files
- [`listFileArchive()`](https://ninanor.github.io/seatrackR/reference/listFileArchive.md)
  : Retrieve info on the status of files in the file archive
- [`loadFile()`](https://ninanor.github.io/seatrackR/reference/loadFile.md)
  : Load a single file from the file archive into R
- [`uploadFiles()`](https://ninanor.github.io/seatrackR/reference/uploadFiles.md)
  : Write files to the file archive

## Utility functions

Various utility functions included in the package.

### General Database Functions

General functions related to the SEATRACK database.

- [`changeSeatrackPassword()`](https://ninanor.github.io/seatrackR/reference/changeSeatrackPassword.md)
  : changeSeatrackPassword
- [`checkSeatrackRVersion()`](https://ninanor.github.io/seatrackR/reference/checkSeatrackRVersion.md)
  : checkSeatrackRVersion
- [`deleteRecords()`](https://ninanor.github.io/seatrackR/reference/deleteRecords.md)
  : Delete records from the database, based on subselection criteria
- [`refreshViews()`](https://ninanor.github.io/seatrackR/reference/refreshViews.md)
  : Manually update the the materialized views in the database
- [`viewDatabaseModel()`](https://ninanor.github.io/seatrackR/reference/viewDatabaseModel.md)
  : View the database structure in a browser

### Data

Example datasets included in the package.

- [`sampleLoggerImport`](https://ninanor.github.io/seatrackR/reference/sampleLoggerImport.md)
  : sampleLoggerImport
- [`sampleLoggerModels`](https://ninanor.github.io/seatrackR/reference/sampleLoggerModels.md)
  : sampleLoggerModels
- [`sampleLoggerShutdown`](https://ninanor.github.io/seatrackR/reference/sampleLoggerShutdown.md)
  : sampleLoggerShutdown
- [`sampleMetadata`](https://ninanor.github.io/seatrackR/reference/sampleMetadata.md)
  : sampleMetadata
- [`samplePosdata`](https://ninanor.github.io/seatrackR/reference/samplePosdata.md)
  : samplePosdata
- [`sampleRingHistory`](https://ninanor.github.io/seatrackR/reference/sampleRingHistory.md)
  : sampleRingHistory

### Plotting functions

Shortcuts for plotting SEATRACK data.

- [`sfGmapPlot()`](https://ninanor.github.io/seatrackR/reference/sfGmapPlot.md)
  : sfGmapPlot

### Database conversion functions

Functions to prepare R data for queries

- [`R_df_to_db_values()`](https://ninanor.github.io/seatrackR/reference/R_df_to_db_values.md)
  : Convert a dataframe of R values to a string of database values for
  SQL insertion
- [`R_value_to_db_value()`](https://ninanor.github.io/seatrackR/reference/R_value_to_db_value.md)
  : Convert an R value to its corresponding database representation
- [`R_vector_to_db_values()`](https://ninanor.github.io/seatrackR/reference/R_vector_to_db_values.md)
  : Convert an R vector to a string of database values
