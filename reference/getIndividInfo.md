# Retrieve info on the individuals

This is a convenience function that pulls together various info on the
files in the individuals.individ_info and individuals.individ_status
table and other tables

## Usage

``` r
getIndividInfo(colony = NULL, year = NULL)
```

## Arguments

- colony:

  Optional character string of colonies limit the selection to.
  Available choices are found in "colony_int_name", from getColonies()

- year:

  Optional character string of year_tracked to limit the selection to.
  This has the form "2020_21", see getYears for available choices.

## Value

Data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
seatrackConnect(Username = "testreader", Password = "testreader")
individInfo <- getInfividInfo()
} # }
```
