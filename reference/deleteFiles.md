# deleteFiles

Delete files on the FTP-server.

## Usage

``` r
deleteFiles(files = NULL, force = FALSE, ...)
```

## Arguments

- files:

  Character list of filenames to delete.

- force:

  Optionally override confirmation

- ...:

  Optional additional parameters passed to the httr configuration.

## Value

Status messages on the actions taken for each file.

## Examples

``` r
if (FALSE) { # \dontrun{

deleteFiles(files = c("test.txt", "test_file2.txt"), originFolder = "temp")
} # }
```
