# Get responsible species and colony

Get responsible species and colony

## Usage

``` r
get_responsible(
  session = NULL,
  species = NULL,
  colony = NULL,
  return_string = TRUE
)
```

## Arguments

- session:

  Optional vector of session IDs to filter by.

- species:

  Optional vector of species names to filter by.

- colony:

  Optional vector of colony names to filter by.

- return_string:

  Logical indicating whether to return responsible as a formatted
  string. Default is TRUE.

## Value

A data frame with species, colony, and distinct responsible persons.
