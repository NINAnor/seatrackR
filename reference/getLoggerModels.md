# Get logger models

This function retrieves logger model information from the
"metadata.logger_models" table. Optionally, it can filter the results
based on specified producers.

## Usage

``` r
getLoggerModels(producers = NULL)
```

## Arguments

- producers:

  Optional vector of character strings representing logger producers to
  filter the results by.

## Value

A tibble containing logger model information, optionally filtered by
producers.
