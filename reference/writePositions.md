# Update the positions.postable

This is a convenience function that writes to the
"positions.postable_raw/gps_raw/irma_raw" table, the main tables for the
position data. It then by default updates the views which links up this
data to the logger session data in the database.

## Usage

``` r
writePositions(datatype = "GLS", positionData, refreshView = TRUE)
```

## Arguments

- datatype:

  "GLS", "IRMA", or "GPS" data

- positionData:

  A list of position data to be read into the postable in the database.
  Usually created by `loadPosdata`.

- refreshView:

  Should the views be updated? Boolean. Note that this takes time, and
  only needs to be done after all changes have been made.

## Value

Message of affected rows

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")

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

writePositions(toImport)
} # }
```
