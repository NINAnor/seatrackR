# Retrieve info on the status of files in the file archive

This function checks which files are stored in the file archive, which
files that are missing from the archive (listed in the database but not
present in the file archive), and which files are in the archive but not
listed in the database (should be zero).

## Usage

``` r
listFileArchive()
```

## Value

A list.

## Examples

``` r
if (FALSE) { # \dontrun{
listFileArchive()
} # }
#' @seealso \code{\link{getFileArchive}} for a function that summarizes info on the files that should be in the file archive (connected to loggers that have been shut down).
```
