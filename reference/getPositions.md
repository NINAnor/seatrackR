# Get position data from the database. Either "GLS" data (default), "IRMA" data, or "GPS" data.

This is a convenience function that reads position data from the
database. The default datatype is "GLS", which reads data from
"positions.postable", which is the primary table position table in the
DB. Optionally you can fetch "IRMA" data, which is IRMA processed
position data, or "GPS" data.

## Usage

``` r
getPositions(
  datatype = "GLS",
  species = NULL,
  colony = NULL,
  age_deployment_class = NULL,
  dataResponsible = NULL,
  ringnumber = NULL,
  year = NULL,
  sessionId = NULL,
  individId = NULL,
  loadGeometries = FALSE,
  asTibble = TRUE,
  limit = FALSE
)
```

## Arguments

- datatype:

  "GLS", "IRMA", or "GPS". Which type of position data to fetch. Default
  is "GLS".

- species:

  Character string. Option to limit selection to one or a set of
  species.Default is NULL, indicating all species. The available choices
  can be seen in the column `species_name_eng` in the result from the
  function
  [`getSpecies()`](https://ninanor.github.io/seatrackR/reference/getSpecies.md).

- colony:

  Character string. Option to limit selection to one or a set of
  colonies. Default is NULL. The available choices can be seen in the
  column `colony_int_name` in the result from the function
  [`getColonies()`](https://ninanor.github.io/seatrackR/reference/getColonies.md).

- age_deployment_class:

  Character string. Option to limit selection to one or a set of age
  classes. Default is NULL.

- dataResponsible:

  Character string. Option to limit selection to one or a set of names
  of data responsible persons. Note that this must conform to the name
  nomenclature used in the postable. Default is NULL. The available
  choices can be seen in the column `name` in the result from the
  function
  [`getNames()`](https://ninanor.github.io/seatrackR/reference/getNames.md).

- ringnumber:

  Character string. Option to limit selection to one or a set of ring
  numbers. Default is NULL.

- year:

  Character string. Option to limit selection to one or more years that
  the logging sessions span. The availablle choices can be found in the
  `year_tracked` column in the result form the `getYears` function.

- sessionId:

  Character string of session ids to limit the selection to.

- individId:

  Character string of individ ids to limit the selection to.

- loadGeometries:

  Boolean. If True, the returned object is a simple features object with
  only rows of eqfilter == TRUE. Default = False

- asTibble:

  Boolean. Should the result be given as a tibble instead of a lazy
  query? Tibble is a little bit slower, but also here forces the
  timezone to "UTC".

- limit:

  FALSE or Integer. Limit the number of rows returned to this number.
  Default = False.

## Value

A lazy query or optionally a tibble of postable records. In the case of
loadGeometries = T (default), also of class sf (simple feature) with
geometries based on lat lon.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")

positions <- getPositions(
  colony = "Kongsfjorden",
  dataResponsible = "Sebastien Descamps",
  species = "Little auk",
  limit = F,
  loadGeometries = F
)

positions

# get data with geometries (default)
positions2 <- getPositions(
  datatype = "GPS",
  limit = 500
)

positions2

# make a simple plot
plot(positions2["logger_model"], pch = 16)
} # }
```
