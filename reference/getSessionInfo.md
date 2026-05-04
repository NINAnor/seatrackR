# Retrieve logger session information

This function retrieves information about logger sessions from the
database, allowing for various filters to narrow down the results.

## Usage

``` r
getSessionInfo(
  logger_ids = NULL,
  individ_ids = NULL,
  logger_deployment_year = NULL,
  logger_retrieval_year = NULL,
  colony_names = NULL,
  species_names = NULL,
  logger_year_tracked = NULL,
  logger_active = NULL,
  logger_deployed = NULL,
  logger_retrieved = NULL,
  has_pos_data = NULL,
  logger_download_type = NULL,
  posdata_filename = NULL,
  session_id = NULL
)
```

## Arguments

- logger_ids:

  Optional vector of character strings representing logger serial
  numbers to filter the sessions.

- individ_ids:

  Optional vector of character strings representing individual IDs to
  filter the sessions.

- logger_deployment_year:

  Optional vector of integers representing the years of logger
  deployment to filter the sessions.

- logger_retrieval_year:

  Optional vector of integers representing the years of logger retrieval
  to filter the sessions.

- colony_names:

  Optional vector of character strings representing colony names to
  filter the sessions.

- species_names:

  Optional vector of character strings representing species names to
  filter the sessions.

- logger_year_tracked:

  Optional vector of character strings representing the years tracked by
  the logger to filter the sessions.

- logger_active:

  Optional boolean to filter sessions based on whether the logger is
  currently active.

- logger_deployed:

  Optional boolean to filter sessions based on whether the logger has
  been deployed.

- logger_retrieved:

  Optional boolean to filter sessions based on whether the logger has
  been retrieved.

- has_pos_data:

  Optional boolean to filter sessions based on whether they have
  associated position data.

- logger_download_type:

  Optional vector of character strings representing the download types
  of the loggers to filter the sessions.

- posdata_filename:

  Optional vector of character strings representing position data
  filenames to filter the sessions (without extension).

- session_id:

  Optional vector of character strings representing session IDs to
  filter the sessions.

## Value

A tibble containing the filtered logger session information.
