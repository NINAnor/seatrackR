# Retrieve info on the registered colonies and locations within colonies in the database

This function either reads from the metadata.colony or the
metadata.location table, depending on the parameter allLocations. If

## Usage

``` r
getColonies(allLocations = F, loadGeometries = F)
```

## Arguments

- allLocations:

  True, False. Should all locations within colonies be loaded. Default =
  False.

- loadGeometries:

  True, False. Should the geometries be loaded as an sf object. Default
  = False.

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
