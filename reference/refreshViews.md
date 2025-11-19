# Manually update the the materialized views in the database

Update all or optionally single materialized views in the database.
Typically done after data imports.

## Usage

``` r
refreshViews(
  all = TRUE,
  onlySummaryTables = FALSE,
  onlyGLS = FALSE,
  onlyGPS = FALSE,
  onlyIrma = FALSE
)
```

## Arguments

- all:

  Update all materialized views?

- onlySummaryTables:

  only refresh (smaller) summary tables. Useful if you have already
  refreshed the position data at import.

- onlyGLS:

  Only update positions.postable?

- onlyGPS:

  Only update positions.gps?

- onlyIrma:

  Only update positions.irma?

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
refreshViews()
} # }
```
