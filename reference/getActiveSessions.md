# View the active logger sessions

This is a convenience function that reads from the view
"views.active_logging_sessions. It simply lists all logging sessions
marked "active = TRUE"

## Usage

``` r
getActiveSessions()
```

## Value

A tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
activeSessions <- getActiveSessions()
} # }
```
