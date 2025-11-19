# pruneRecordings Prune activity, light and temperature recording data that

Delete activity, light and temperature recording data that is lacking an
existing session_id in the loggers.logger_session table. \#'

## Usage

``` r
pruneRecordings(
  pruneLight = TRUE,
  pruneActivity = TRUE,
  pruneTemperature = TRUE,
  force = FALSE
)
```

## Arguments

- pruneLight:

  Prune light table (slow). Boolean

- pruneActivity:

  Prune activity table (slow). Boolean

- pruneTemperature:

  Prune temperature table. Boolean

- force:

  Override the confirmation menu

## Value

Status message

## Examples

``` r
if (FALSE) { # \dontrun{
pruneRecords()
} # }
```
