# View the view info table

This is a convenience function that reads from the view
"views.logger_info". Note that there also exists a table
"loggers.logger_info" with more limited information. \#'

## Usage

``` r
getLoggerInfo(
  species = NULL,
  colony = NULL,
  session = NULL,
  individ_id = NULL,
  project = "SEATRACK",
  asTibble = TRUE
)
```

## Arguments

- species:

  Optional vector of character strings of species to limit the selection
  to.

- colony:

  Optional vector of character strings of colonies limit the selection
  to.

- session:

  Optional vector of character strings of session_id to limit the
  selection to.

- individ_id:

  Optional vector of character strings of individ_id to limit the
  selection to.

- project:

  subset data for a character vector of project names. Default is
  "SEATRACK", which means that by default only data from the SEATRACK
  project are included. Set to NULL to include all projects.

- asTibble:

  Boolean. Return result as Tibble instead of Lazy query? Tibble is
  slower, but also here forces the timezone to "UTC".

## Value

Lazy query or optionally a Tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
loggerInfo <- getLoggerInfo()
} # }
```
