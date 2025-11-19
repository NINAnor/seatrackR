# Load a single file from the file archive into R

We load the file using read_delim from the readr package, and parameters

## Usage

``` r
loadFile(filename = NULL, delim = ",", ...)
```

## Arguments

- filename:

  character, matching a filename in the archive

- delim:

  the character used for deliminating the columns, passed to
  readr::read_delim function

- ...:

  further parameters to readr::read_delim function

## Value

Status messages on the actions taken for each file.

## Examples

``` r
if (FALSE) { # \dontrun{
## To download all files in the file storage
myFiles <- listFileArchive()$filesInArchive
loadedFile <- loadFile(filename = myFiles[1, ])

# Some files starts funny, this might help:
loadedFile2 <- loadFile(
  filename = myFiles[1, ],
  skip = 1,
  col_names = F
)
} # }
```
