# deletePositions

Delete position data from either positions.postable_raw,
positions.gps_raw, or positions.irma_raw, based on session_ids, and
optionally refresh views.

## Usage

``` r
deletePositions(
  datatype = "GLS",
  session_ids_to_delete,
  idempotent = TRUE,
  refreshView = TRUE
)
```

## Arguments

- datatype:

  "GLS", "IRMA", or "GPS".

- session_ids_to_delete:

  Character string (or vector of character trings), specifying which
  session_ids to remove data from.

- idempotent:

  Should it silently ignore sessions that are not present?

- refreshView:

  Should the materialized position views be refreshed after the
  deletion? Defaults to TRUE.

## Value

Message with affected rows

## Examples

``` r
if (FALSE) { # \dontrun{

deletePositions(
  datatype = "GLS",
  session_ids_to_delete = c("60171_2022-06-30", "63170_2022-06-30"),
  refreshView = TRUE
)
} # }
```
