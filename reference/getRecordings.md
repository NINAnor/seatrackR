# Read logger recordings data

This is a convenience function that reads from the "activity" tables
temperature, activity, and light in the schema Recordings

## Usage

``` r
getRecordings(
  type = NULL,
  sessionId = NULL,
  individId = NULL,
  colony = NULL,
  species = NULL,
  yearTracked = NULL,
  project = "SEATRACK",
  asTibble = TRUE
)
```

## Arguments

- type:

  light, temperature, or activity as a character. Default = "light".

- sessionId:

  subset data for a character vector of session ids

- individId:

  subset data for a character vector of individual ids

- colony:

  subset data for a character vector of colony names (International
  names)

- species:

  subset data for a character vector of species

- yearTracked:

  subset data for a character vector of year_tracked (e.g. 2014_15)

- project:

  subset data for a character vector of project names. Default is
  "SEATRACK", which means that by default only data from the SEATRACK
  project are included. Set to NULL to include all projects.

- asTibble:

  Boolean. Return result as Tibble instead of lazy query? Tibble is
  slower, but also here forces the timezone to "UTC".

## Value

A Lazy query or optionally a Tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
getRecordings(
  type = "temperature",
  colony = "Sklinna"
)
} # }
```
