# View the view info table

This is a convenience function that reads from the view
"views.logger_info". Note that there also exists a table
"loggers.logger_info" with more limited information. \#'

## Usage

``` r
getLoggerInfo(asTibble = T)
```

## Arguments

- asTibble:

  Boolean. Return result as Tibble instead of Lazy query? Tibble is
  slower, but also here forces the timezone to "UTC".

## Value

Lazy query or optionally a Tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
loggerInfo <- getLoggerInfo()
} # }
```
