# seatrackR

## seatrackR - R package for utilizing the seatrack database

Code to manage and interact with the seatrack database.

Main functionality:

- Connect to the database (seatrackConnect())
- Retrieve data (individ info, logger info, GLS-, IRMA-, GPS-positions,
  recordings, file archive list, active logging session list)
- Check the consistency of new data with current database, before
  inserts.
- Insert data into the database. (“metadata” fieldsheets, GLS-, IRMA-,
  and GPS-positions)
- Interact with the FTP file archive (list files, upload, download,
  delete)

Take a look at the Articles for a guide to what is available.

## Installation

Install the package by:

``` R
devtools::install_github("NINAnor/seatrackR")
```
