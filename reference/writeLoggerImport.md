# Update the logger info table

This is a convenience function that writes to the "loggers.logger_info"

## Usage

``` r
writeLoggerImport(loggerImport, append = T, overwrite = FALSE)
```

## Arguments

- loggerImport:

  A named vector or data frame that fits the logger_info table in schema
  loggers

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
writeLoggerImport(sampleLoggerImport)
} # }
```
