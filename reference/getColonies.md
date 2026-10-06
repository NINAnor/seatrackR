# Retrieve info on the registered colonies and locations within colonies in the database

This function either reads from the metadata.colony or the
metadata.location table, depending on the parameter allLocations. If
loadGeometries is set to TRUE, the function will return an sf object
with the geometries of the colonies or locations.

## Usage

``` r
getColonies(allLocations = FALSE, loadGeometries = FALSE)
```

## Arguments

- allLocations:

  Boolean. Should all locations within colonies be loaded. Default =
  FALSE

- loadGeometries:

  Boolean. Should the geometries be loaded as an sf object. Default =
  FALSE

## Value

A tibble of the metadata.colony or metadata.location table with or
without sf geometry.

## Examples

``` r
if (FALSE) { # \dontrun{
colony <- getColonies(loadGeometries = T)
plot(colony["colony_int_name"],
  pch = 16
)
} # }
```
