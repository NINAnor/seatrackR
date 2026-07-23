# Retrieve logger session information

This function retrieves information about logger sessions from the
database, allowing for various filters to narrow down the results.

## Usage

``` r
getSessionInfo(
  session_id = NULL,
  individ_id = NULL,
  project = NULL,
  logger_serial_no = NULL,
  logger_model = NULL,
  logger_producer = NULL,
  logger_type = NULL,
  logger_deployed = NULL,
  logger_retrieved = NULL,
  active = NULL,
  colony = NULL,
  species = NULL,
  deployment_age_class = NULL,
  sex = NULL,
  sexing_method = NULL,
  years_tracked = NULL,
  logger_start_time = NULL,
  logger_start_time_between = NULL,
  logging_mode = NULL,
  logger_deployment_year = NULL,
  logger_deployment_date_between = NULL,
  deployment_logger_status = NULL,
  logger_retrieval_year = NULL,
  logger_retrieval_date_between = NULL,
  retrieval_logger_status = NULL,
  logger_shutdown_date_between = NULL,
  download_type = NULL,
  has_positions = NULL,
  has_irma = NULL,
  embargoed = FALSE,
  as_tibble = TRUE
)
```

## Arguments

- session_id:

  Optional vector of session IDs to filter by.

- individ_id:

  Optional vector of individual IDs to filter by.

- project:

  Optional vector of project names to filter by.

- logger_serial_no:

  Optional vector of logger serial numbers to filter by.

- logger_model:

  Optional vector of logger models to filter by.

- logger_producer:

  Optional vector of logger producers to filter by.

- logger_type:

  Optional vector of logger types to filter by.

- logger_deployed:

  Optional logical indicating whether to filter by deployed loggers.

- logger_retrieved:

  Optional logical indicating whether to filter by retrieved loggers.

- active:

  Optional logical indicating whether to filter by active logger
  sessions.

- colony:

  Optional vector of colony names to filter by.

- species:

  Optional vector of species names to filter by.

- deployment_age_class:

  Optional vector of age deployment classes ("C" or "A") to filter by.

- sex:

  Optional vector of sexes to filter by.

- sexing_method:

  Optional vector of sexing methods to filter by.

- years_tracked:

  Optional vector of years tracked to filter by.

- logger_start_time:

  Optional vector of logger start times to filter by.

- logger_start_time_between:

  Optional vector of two dates to filter logger start times between.

- logging_mode:

  Optional vector of logging modes to filter by.

- logger_deployment_year:

  Optional vector of deployment years to filter by.

- logger_deployment_date_between:

  Optional vector of two dates to filter deployment dates between.

- deployment_logger_status:

  Optional vector of deployment logger statuses to filter by.

- logger_retrieval_year:

  Optional vector of retrieval years to filter by.

- logger_retrieval_date_between:

  Optional vector of two dates to filter retrieval dates between.

- retrieval_logger_status:

  Optional vector of retrieval logger statuses to filter by.

- logger_shutdown_date_between:

  Optional vector of two dates to filter shutdown dates between.

- download_type:

  Optional vector of download types to filter by.

- has_positions:

  Optional logical indicating whether to filter by sessions with
  position data.

- has_irma:

  Optional logical indicating whether to filter by sessions with IRMA
  data.

- embargoed:

  Optional logical indicating whether to include embargoed sessions.
  Default is FALSE.

- as_tibble:

  Logical indicating whether to return the result as a tibble.

## Value

Either a lazy db query or a tibble containing the filtered logger
session information.
