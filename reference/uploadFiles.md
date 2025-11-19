# Write files to the file archive

Write files to the file archive

## Usage

``` r
uploadFiles(files = NULL, originFolder = NULL, overwrite = FALSE, ...)
```

## Arguments

- files:

  Character vector of files to write to file archive.

- originFolder:

  Character vector of folder to find files in.

- overwrite:

  Overwrite existing data? Booldean.

- ...:

  optional additional parameters passed on to RCurl::ftpUpload.

## Value

Status messages on the actions taken for each file.

## Examples

``` r
if (FALSE) { # \dontrun{

uploadFiles(files = c("test_file.txt", "test_file2.txt"), originFolder = "temp")
} # }
```
