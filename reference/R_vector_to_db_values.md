# Convert an R vector to a string of database values

This function takes an R vector and converts each value to its
corresponding database representation.

## Usage

``` r
R_vector_to_db_values(vector, dbtype = "")
```

## Arguments

- vector:

  An R vector to be converted.

- dbtype:

  An optional string specifying the database type to force for NULL
  values.

## Value

A string representing the database values.
