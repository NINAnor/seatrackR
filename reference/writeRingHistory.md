# Update the ring history table

This is a convenience function that writes to the
"individuals.ring_history".

## Usage

``` r
writeRingHistory(historyData, append = TRUE, overwrite = FALSE)
```

## Arguments

- historyData:

  A named vector or data frame that fits the ring history table in
  schema individuals

- append:

  Logical, default True. If True, the line(s) is appended to the end of
  the table.

- overwrite:

  Logical, default False. WARNING!! If True, the function overwrites the
  current content of the logger_info table.

## Value

Data frame.

## Details

It is very important to store backups of this table outside the
database! This is the memory of the history of the ring numbers and
might need to be reimported if the database has been scratched!

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
writeRingHistory(sampleRingHistory)
} # }
```
