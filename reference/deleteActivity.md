# Delete activity data from the database, based on subselection criteria

This is a convenience function that deletes records from the activity
tables (records.activity, records.light, records.temp)

## Usage

``` r
deleteActivity(
  sessionId = NULL,
  colony = NULL,
  species = NULL,
  limit_to_type = NULL,
  force = FALSE
)
```

## Arguments

- sessionId:

  Limit the data to what session(s). Character string.

- colony:

  Optional character string of colonies to subset the data.

- species:

  Optional character string to subset data to one or a set of species.
  Default is NULL, indicating all species.

- limit_to_type:

  Optional character string of what type of activity data to delete.
  c("light", "temperature", "activity", "acceleration")

- force:

  True, False (default = False). Skip confirmation check (for non
  interactive functionality)

## Value

Currently nothing.

## Examples

``` r
if (FALSE) { # \dontrun{
deleteActivity(
  sessionId = "T220_2015-04-27",
  species = "Glaucus gull",
  colony = "Anda",
  limit_to_type = c("temperature", "activity")
)
} # }
```
