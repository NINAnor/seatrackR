# Import metadata

This is a convenience function that writes to the
"imports.metadata_import"

## Usage

``` r
writeMetadata(metadata)
```

## Arguments

- metadata:

  A named vector or data frame that fits the metadata_import table in
  schema imports

## Value

Data frame.

## Details

The import_metadata table is one of the two major ways of importing data
into the database. Together with the table logger_import, this table
handles all the routine information about loggers and the fieldwork.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
writeMetadata(sampleMetadata)
} # }
```
