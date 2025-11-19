# Update the individ_info table

This is a convenience function that writes to the
"individuals.individ_info"

## Usage

``` r
writeIndividInfo(individData, append = T, overwrite = FALSE)
```

## Arguments

- individData:

  A named vector or data frame that fits the individ_info table in
  schema individuals

- append:

  Logical, default True. If True, the line(s) is appended to the end of
  the table.

- overwrite:

  Logical, default False. WARNING!! If True, the function overwrites the
  current content of the logger_info table.

## Value

Data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
writeIndividInfo(sampleIndividInfo)
} # }
```
