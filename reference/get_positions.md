# Get position data from the database. Either "GLS" data (default), "IRMA" data, or "GPS" data.

This is a convenience function that reads position data from the
database. The default datatype is "GLS", which reads data from
"positions.postable", which is the primary table position table in the
DB. Optionally you can fetch "IRMA" data, which is IRMA processed
position data, or "GPS" data.

## Usage

``` r
get_positions(
  datatype = "GLS",
  species = NULL,
  colony = NULL,
  location = NULL,
  age_deployment_class = NULL,
  data_responsible = NULL,
  ring_number = NULL,
  year = NULL,
  session_id = NULL,
  individ_id = NULL,
  project = NULL,
  lme_area = NULL,
  polygons = NULL,
  exclude_embargoed = TRUE,
  loadGeometries = FALSE,
  asTibble = TRUE,
  limit = FALSE,
  ...
)

getPositions(
  datatype = "GLS",
  species = NULL,
  colony = NULL,
  location = NULL,
  age_deployment_class = NULL,
  data_responsible = NULL,
  ring_number = NULL,
  year = NULL,
  session_id = NULL,
  individ_id = NULL,
  project = NULL,
  lme_area = NULL,
  polygons = NULL,
  exclude_embargoed = TRUE,
  loadGeometries = FALSE,
  asTibble = TRUE,
  limit = FALSE,
  ...
)
```

## Arguments

- datatype:

  "GLS", "IRMA","GPS" or "GPS-GSM". Which type of position data to
  fetch. Default is "GLS".

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

- location:

  Character string. Option to limit selection to one or a set of
  colonies. Default is NULL. The available

- age_deployment_class:

  Character string. Option to limit selection to one or a set of age
  classes, "A" or "C". Default is NULL.

- ring_number:

  Character string. Option to limit selection to one or a set of ring
  numbers. Default is NULL.

- year:

  Character string. Option to limit selection to one or more years that
  the logging sessions span. The availablle choices can be found in the
  `year_tracked` column in the result form the `getYears` function.

- session_id:

  Character string. Option to limit selection to one or a set of session
  ids. Default is NULL.

- individ_id:

  Character string. Option to limit selection to one or a set of
  individual ids. Default is NULL.

- project:

  subset data for a character vector of project names. Default is NULL.

- lme_area:

  Character string. Option to limit selection to one or a set of LME
  areas. Default is NULL. The available choices can be seen in the
  column `name` in the result from the function
  [`getLMEAreas()`](https://ninanor.github.io/seatrackR/reference/getLMEAreas.md).

- polygons:

  An sf object with polygons. If provided, only positions within the
  polygons will be returned. Default is NULL.

- exclude_embargoed:

  Boolean. If TRUE, records from embargoed projects are not included.
  Default is TRUE.

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

- data_repsonsible:

  Character string. Option to limit selection to one or a set of names
  of data responsible persons. Note that this must conform to the name
  nomenclature used in the postable. Default is NULL. The available
  choices can be seen in the column `name` in the result from the
  function
  [`getNames()`](https://ninanor.github.io/seatrackR/reference/getNames.md).

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
