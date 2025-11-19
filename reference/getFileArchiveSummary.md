# Retrieve summary info on the registered raw-files

This is a convenience function that pulls together various info on the
files in the loggers.file_archive table and other tables

## Usage

``` r
getFileArchiveSummary(colony = NULL, year = NULL)
```

## Arguments

- colony:

  Optional character string of colonies limit the selection to.

- year:

  Optional character string of years limit the selection to.

## Value

Data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
seatrackConnect(Username = "testreader", Password = "testreader")
fileArchive <- getFileArchive()
} # }
```
