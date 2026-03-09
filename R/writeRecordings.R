#' Update light, temperature or activity data
#'
#' This is a convenience function that writes to the light, temperature or the activity table in schema Recordings
#'
#' @param lightData A named vector or data frame that fits the light_raw table in schema recordings
#' @param activityData A named vector or data frame that fits the activity_raw table in schema recordings
#' @param temperatureData A named vector or data frame that fits the temperature_raw table in schema recordings
#' @param accelerationData A named vector or data frame that fits the acceleration_raw table in schema recordings

#' @export
#' @examples
#' \dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' writeRecordings(lightData = sampleLightData)
#' }
#' @concept activity
writeRecordings <- function(lightData = NULL,
                            activityData = NULL,
                            temperatureData = NULL,
                            accelerationData = NULL
                            ) {
  checkCon()
  # Hardcoding these, we don't want to accidentally overwrite data, and we want to make sure that we append to the tables instead of overwriting them
  append <- TRUE
  overwrite <- FALSE
  if (!is.null(lightData)) {
    DBI::dbWithTransaction(
      con,
      {
        DBI::dbWriteTable(con, Id(schema = "recordings", table = "light_raw"), lightData, append = append, overwrite = overwrite)
      }
    )
  }

  if (!is.null(activityData)) {
    DBI::dbWithTransaction(
      con,
      {
        DBI::dbWriteTable(con, Id(schema = "recordings", table = "activity_raw"), activityData, append = append, overwrite = overwrite)
      }
    )
  }

  if (!is.null(temperatureData)) {
    DBI::dbWithTransaction(
      con,
      {
        DBI::dbWriteTable(con, Id(schema = "recordings", table = "temperature_raw"), temperatureData, append = append, overwrite = overwrite)
      }
    )
  }


  if (!is.null(accelerationData)) {
    DBI::dbWithTransaction(
      con,
      {
        DBI::dbWriteTable(con, Id(schema = "recordings", table = "acceleration_raw"), accelerationData, append = append, overwrite = overwrite)
      }
    )
  }
}
