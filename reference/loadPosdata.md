# Load posdata files into R.

This function loads posdata files from disk into R for further import to
database.

## Usage

``` r
loadPosdata(files, originFolder = "../Rawdata")
```

## Arguments

- files:

  A character vector of posdata files to import. Should not include file
  endings, i.e. should have a format like
  "posdata_FULGLA_eynhallow_2014"

- originFolder:

  Character vector of folder that holds the files to import. Defaults to
  "../Rawdata".

## Examples

``` r
if (FALSE) { # \dontrun{

files <- c(
  "posdata_FULGLA_eynhallow_2014",
  "posdata_FULGLA_eynhallow_2013",
  "posdata_FULGLA_eynhallow_2012",
  "posdata_FULGLA_eynhallow_2011",
  "posdata_FULGLA_eynhallow_2010",
  "posdata_FULGLA_eynhallow_2009",
  "posdata_FULGLA_eynhallow_2007"
)

toImport <- loadPosdata(files)

summary(toImport)
} # }
```
