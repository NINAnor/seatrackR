# sfGmapPlot

Plotting function to overlay sf objects on a ggmap

## Usage

``` r
sfGmapPlot(
  sf,
  maptype = c("terrain", "terrain-background", "satellite", "roadmap", "hybrid", "toner",
    "watercolor", "terrain-labels", "terrain-lines", "toner-2010", "toner-2011",
    "toner-background", "toner-hybrid", "toner-labels", "toner-lines", "toner-lite"),
  color = "salmon",
  zoom = 4
)
```

## Arguments

- sf:

  a simple features object

- maptype:

  type of map for ggmap to fetch

- color:

  Plotting color of SF object

- zoom:

  The zoom level of the plot

## Examples

``` r
if (FALSE) { # \dontrun{

connectSeatrack("testreader", "testreader")
hornoya <- getPosdata(
  selectColony = "Hornøya",
  selectYear = "2015_16",
  loadGeometries = T
)

sub <- hornoya[1:500, ]

sfGmapPlot(sub,
  zoom = 3
)
} # }
```
