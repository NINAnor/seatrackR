# Update light, temperature or activity data

This is a convenience function that writes to the light, temperature or
the activity table in schema Recordings

## Usage

``` r
writeRecordings(
  lightData = NULL,
  activityData = NULL,
  temperatureData = NULL,
  accelerationData = NULL,
  append = T,
  overwrite = FALSE
)
```

## Arguments

- lightData:

  A named vector or data frame that fits the light_raw table in schema
  recordings

- activityData:

  A named vector or data frame that fits the activity_raw table in
  schema recordings

- temperatureData:

  A named vector or data frame that fits the temperature_raw table in
  schema recordings

- accelerationData:

  A named vector or data frame that fits the acceleration_raw table in
  schema recordings

- append:

  Logical, default True. If True, the line(s) is appended to the end of
  the table.

- overwrite:

  Logical, default False. WARNING!! If True, the function overwrites the
  current content of the logger_info table.

## Value

Data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
writeRecordings(lightData = sampleLightData)
} # }
```
