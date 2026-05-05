# Retrieve info on the individuals

This is a convenience function that pulls together various info on the
files in the individuals.individ_info and individuals.individ_status
table and other tables

## Usage

``` r
getIndividInfo(
  colony = NULL,
  year_tracked = NULL,
  deployment_year = NULL,
  retrieval_year = NULL,
  species = NULL,
  age = NULL,
  age_at_deployment = "A",
  sex = NULL,
  event_type = NULL,
  last_only = FALSE,
  session_id = NULL
)
```

## Arguments

- colony:

  Optional vector of character string of colonies limit the selection
  to. Available choices are found in "colony_int_name", from
  getColonies()

- year_tracked:

  Optional vector of character strings of year_tracked to limit the
  selection to. This has the form "2020_21", see getYears for available
  choices.

- deployment_year:

  Optional integer of years, to limit the selection to the year a logger
  was deployed.

- retrieval_year:

  Optional integer of years, to limit the selection to the year a logger
  was retrieved.

- species:

  Optional vector of character strings of species to limit the selection
  to. Available choices are found in "species", from getSpecies()

- age:

  Optional vector of character strings of age to limit the selection to.

- age_at_deployment:

  Optional vector of character strings of age at deployment to limit the
  selection to. Available choices are "A" for adult and "C" for chick.
  Default is "A", meaning that by default only individuals that were
  adults at the time of deployment are included.

- sex:

  Optional vector of character strings of sex to limit the selection to.

- event_type:

  Optional vector of character strings of event types to limit the
  selection to. Available choices are "Deployment" and "Retrieval".

- last_only:

  Logical. If TRUE, only the most recent status info per individual is
  returned. Default is FALSE.

- session_id:

  Optional vector of character strings of session_id to limit the
  selection to.

## Value

Data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
seatrackConnect(Username = "testreader", Password = "testreader")
individInfo <- getInfividInfo()
} # }
```
