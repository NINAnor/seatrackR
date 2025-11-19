# Retrieve info on the registered names (people) in the database

The database only accepts people names that are registered in the
"metadata.people" table. This should contain all people that are
relevant to the project.

## Usage

``` r
getNames(asTibble = FALSE)
```

## Arguments

- asTibble:

  Return the result as a tibble? Boolean

## Value

A tibble of the people id, names and abbreviated names registered in the
people table.

## Examples

``` r
if (FALSE) { # \dontrun{
getNames()
} # }
```
