# Delete records from the database, based on subselection criteria

This is a convenience function that deletes records from the
logging_session table, which cascades to dependent tables (individ info
and status, deployment and retrieval info, startup and shutdown tables,
and file archive).

## Usage

``` r
deleteRecords(
  colony = NULL,
  intendedLocation = NULL,
  year = NULL,
  species = NULL,
  updatedAfter = NULL,
  updatedBefore = NULL,
  updatedBy = NULL,
  sessionId = NULL,
  force = FALSE
)
```

## Arguments

- colony:

  Character string. Option to limit selection to one or a set of
  colonies. Default is NULL.

- intendedLocation:

  Optional character string of intended locations (in allocation) to
  subset on.

- year:

  Optional character string of years (logging_session.year_tracked) to
  subset on.

- species:

  Character string. Option to limit selection to one or a set of
  species. Default is NULL.

- updatedAfter:

  Timestamp or character string that can be interpreted as a timestamp
  through as.POSIXct. Delete only records that where last updated after
  this timestamp

- updatedBefore:

  Timestamp or character string that can be interpreted as a timestamp
  through as.POSIXct. Delete only records that where last updated before
  this timestamp

- updatedBy:

  Optional character string. Limits selection to person that updated the
  data.

- sessionId:

  Optional character string of session ids to limit on.

- force:

  True, False (default = False). Skip confirmation check (for non
  interactive functionality)

## Value

Status message

## Examples

``` r
if (FALSE) { # \dontrun{
deleteRecords(selectUpdateTime = "2018-04-20")
} # }
```
