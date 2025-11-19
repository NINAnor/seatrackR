# Download files from the file archive

Download files from the file archive

## Usage

``` r
downloadFiles(files = NULL, destFolder = NULL, overwrite = F)
```

## Arguments

- files:

  Character vector of files to download.

- destFolder:

  Character of the folder to put files in. Relative paths work (at least
  on linux).

- overwrite:

  Overwrite existing files on disk? Boolean.

## Value

Status messages on the actions taken for each file.

## Examples

``` r
if (FALSE) { # \dontrun{
## To download all files in the file archive.
myFiles <- listFileArchive()$filesInArchive
downloadFiles(files = myFiles, destFolder = "temp")
} # }
```
