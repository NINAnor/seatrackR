# Connect to seatrack database

This function establishes a connection to the Seatrack database. Note
that connections are only accepted from limited IP-adresses. Ideally,
credentials should first be set using
[`set_credentials_renviron()`](https://ninanor.github.io/seatrackR/reference/set_credentials_renviron.md).
This should only have to be done once per project. After this,
credentials will be loaded automatically.

## Usage

``` r
connectSeatrack(
  Username = NULL,
  Password = NULL,
  host = "seatrack.nina.no",
  dbname = "seatrack",
  bigint = "integer",
  save_credentials = TRUE,
  global = TRUE,
  ...
)

disconnectSeatrack()
```

## Arguments

- Username:

  Character. If not provided, first attempts to check environmental
  variables then calls set_credentials_renviron()

- Password:

  Character. If not provided, first attempts to check environmental
  variables then calls set_credentials_renviron()

- host:

  Character. The host of the database. For testing purposes. There
  should be no need for the user to change this.

- dbname:

  Character. Name of database, for testing purposes. Default is
  "seatrack" which is the production database.

- bigint:

  Character. How to handle big integers. Default is "integer". Other
  options are "numeric" and "character".

- save_credentials:

  Boolean. If TRUE, credentials will be saved to .Renviron for future
  use. Default is TRUE.

- global:

  Boolean. If TRUE, the connection object will be assigned to the global
  environment. If FALSE, the connection object will be returned. Default
  is TRUE.

- ...:

  Additional arguments passed to DBI::dbConnect()

## Value

Assigns a connection object to the global variable `con`.

## Details

The function opens a connection to the database, which other functions
in seatrackRdb will use.
