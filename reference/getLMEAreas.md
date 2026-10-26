# Get LME areas

This function retrieves the LME areas from the database. Optionally, it
can load geometries for the LME areas.

## Usage

``` r
getLMEAreas(loadGeometries = FALSE)
```

## Arguments

- loadGeometries:

  Boolean. Should the geometries be loaded as an sf object. Default =
  FALSE

## Value

A tibble of the LME areas with or without sf geometry.
