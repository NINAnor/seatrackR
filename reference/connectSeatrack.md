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

- ...:

  Additional arguments passed to DBI::dbConnect()

## Value

Assigns a connection object to the global variable `con`.

## Details

The function opens a connection to the database, which other functions
in seatrackRdb will use.
