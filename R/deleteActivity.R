#' Delete activity data from the database, based on subselection criteria
#'
#' This is a convenience function that deletes records from the activity tables (records.activity, records.light, records.temp)
#' @param sessionId Limit the data to what session(s). Character string.
#' @param species Optional character string to subset data to one or a set of species. Default is NULL, indicating all species.
#' @param colony Optional character string of colonies to subset the data.
#' @param limit_to_type Optional character string of what type of activity data to delete. c("light", "temperature", "activity", "acceleration")
#' @param force True, False (default = False). Skip confirmation check (for non interactive functionality)
#'
#' @return Currently nothing.
#' @import dplyr
#' @export
#' @examples
#' \dontrun{
#' deleteActivity(
#'   sessionId = "T220_2015-04-27",
#'   species = "Glaucus gull",
#'   colony = "Anda",
#'   limit_to_type = c("temperature", "activity")
#' )
#' }
#' @concept activity
deleteActivity <- function(sessionId = NULL,
                           colony = NULL,
                           species = NULL,
                           limit_to_type = NULL,
                           force = FALSE) {
  checkCon()


  if (!is.null(limit_to_type)) {
    limit_to_type <- match.arg(limit_to_type,
      choices = c(
        "light",
        "temperature",
        "activity",
        "acceleration"
      ),
      several.ok = TRUE
    )
  }


  # This whole pasting code is ugly. Could probably condense with a rewrite.
  # append dummy condition to ease later conditions
  deleteTemp <- "DELETE FROM recordings.temperature_raw
              USING recordings.temperature_raw as t
              LEFT OUTER JOIN loggers.logging_session as ls ON
              t.session_id = ls.session_id
              LEFT OUTER JOIN loggers.allocation a ON
              t.session_id = a.session_id
              WHERE temperature_raw.id = t.id"

  deleteAct <- "DELETE FROM recordings.activity_raw
              USING recordings.activity_raw as act
              LEFT OUTER JOIN loggers.logging_session as ls ON
              act.session_id = ls.session_id
              LEFT OUTER JOIN loggers.allocation a ON
              act.session_id = a.session_id
              WHERE activity_raw.id = act.id"

  deleteLight <- "DELETE FROM recordings.light_raw
                USING recordings.light_raw as lig
                LEFT OUTER JOIN loggers.logging_session as ls ON
                lig.session_id = ls.session_id
                LEFT OUTER JOIN loggers.allocation a ON
                lig.session_id = a.session_id
                WHERE light_raw.id = lig.id"

  deleteAccelerometer <- "DELETE FROM recordings.accelerometer_raw
                        USING recordings.accelerometer_raw as acc
                        LEFT OUTER JOIN loggers.logging_session as ls ON
                        acc.session_id = ls.session_id
                        LEFT OUTER JOIN loggers.allocation a ON
                        acc.session_id = a.session_id
                        WHERE accelerometer_raw.id = acc.id"

  selectQueryTemp <- "SELECT count(distinct(t.session_id)) FROM recordings.temperature_raw as t
                    LEFT OUTER JOIN loggers.logging_session as ls ON
                    t.session_id = ls.session_id
                    LEFT OUTER JOIN loggers.allocation a ON
                    t.session_id = a.session_id
                    WHERE 1=1"

  selectQueryAct <- "SELECT count(distinct(act.session_id)) FROM recordings.activity_raw as act
                   LEFT OUTER JOIN loggers.logging_session as ls ON
                   act.session_id = ls.session_id
                   LEFT OUTER JOIN loggers.allocation a ON
                   act.session_id = a.session_id
                   WHERE 1=1"

  selectQueryLight <- "SELECT count(distinct(lig.session_id)) FROM recordings.light_raw as lig
                     LEFT OUTER JOIN loggers.logging_session as ls ON
                     lig.session_id = ls.session_id
                     LEFT OUTER JOIN loggers.allocation a ON
                     lig.session_id = a.session_id
                     WHERE 1=1"

  selectQueryAccelerometer <- "SELECT count(distinct(acc.session_id)) FROM recordings.accelerometer_raw as acc
                             LEFT OUTER JOIN loggers.logging_session as ls ON
                             acc.session_id = ls.session_id
                             LEFT OUTER JOIN loggers.allocation a ON
                             acc.session_id = a.session_id
                             WHERE 1=1"


  if (!is.null(colony)) {
    deleteTemp <- paste0(deleteTemp, "\nAND ls.colony = '", colony, "'")
    deleteAct <- paste0(deleteAct, "\nAND ls.colony = '", colony, "'")
    deleteLight <- paste0(deleteLight, "\nAND ls.colony = '", colony, "'")
    deleteAccelerometer <- paste0(deleteAccelerometer, "\nAND ls.colony = '", colony, "'")
    selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.colony = '", colony, "'")
    selectQueryAct <- paste0(selectQueryAct, "\nAND ls.colony = '", colony, "'")
    selectQueryLight <- paste0(selectQueryLight, "\nAND ls.colony = '", colony, "'")
    selectQueryAccelerometer <- paste0(selectQueryAccelerometer, "\nAND ls.colony = '", colony, "'")
  }


  if (!is.null(species)) {
    deleteTemp <- paste0(deleteTemp, "\nAND ls.species = '", species, "'")
    deleteAct <- paste0(deleteAct, "\nAND ls.species = '", species, "'")
    deleteLight <- paste0(deleteLight, "\nAND ls.species = '", species, "'")
    deleteAccelerometer <- paste0(deleteAccelerometer, "\nAND ls.species = '", species, "'")
    selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.species = '", species, "'")
    selectQueryAct <- paste0(selectQueryAct, "\nAND ls.species = '", species, "'")
    selectQueryLight <- paste0(selectQueryLight, "\nAND ls.species = '", species, "'")
    selectQueryAccelerometer <- paste0(selectQueryAccelerometer, "\nAND ls.species = '", species, "'")
  }


  if (!is.null(sessionId)) {
    deleteTemp <- paste0(deleteTemp, "\nAND t.session_id = '", sessionId, "'")
    deleteAct <- paste0(deleteAct, "\nAND act.session_id = '", sessionId, "'")
    deleteLight <- paste0(deleteLight, "\nAND lig.session_id = '", sessionId, "'")
    deleteAccelerometer <- paste0(deleteAccelerometer, "\nAND acc.session_id = '", sessionId, "'")
    selectQueryTemp <- paste0(selectQueryTemp, "\nAND t.session_id = '", sessionId, "'")
    selectQueryAct <- paste0(selectQueryAct, "\nAND act.session_id = '", sessionId, "'")
    selectQueryLight <- paste0(selectQueryLight, "\nAND lig.session_id = '", sessionId, "'")
    selectQueryAccelerometer <- paste0(selectQueryAccelerometer, "\nAND acc.session_id = '", sessionId, "'")
  }

  noAffectedRowsTemp <- DBI::dbGetQuery(con, selectQueryTemp)
  noAffectedRowsAct <- DBI::dbGetQuery(con, selectQueryAct)
  noAffectedRowsLight <- DBI::dbGetQuery(con, selectQueryLight)
  noAffectedRowsAccelerometer <- DBI::dbGetQuery(con, selectQueryAccelerometer)

  if (force) {
    if (is.null(limit_to_type)) {
      DBI::dbExecute(con, deleteLight)
      DBI::dbExecute(con, deleteTemp)
      DBI::dbExecute(con, deleteAct)
      DBI::dbExecute(con, deleteAccelerometer)
    } else {
      if ("light" %in% limit_to_type) {
        DBI::dbExecute(con, deleteLight)
      }
      if ("temperature" %in% limit_to_type) {
        DBI::dbExecute(con, deleteTemp)
      }
      if ("activity" %in% limit_to_type) {
        DBI::dbExecute(con, deleteAct)
      }
      if ("acceleration" %in% limit_to_type) {
        DBI::dbExecute(con, deleteAccelerometer)
      }
    }
  } else {
    if (!is.null(limit_to_type)) {
      choice_message <- paste0(
        "Your selection corresponds to  \n",
        noAffectedRowsTemp[1, 1], " sessions of temperature, \n",
        noAffectedRowsAct[1, 1], " sessions of activity, \n",
        noAffectedRowsLight[1, 1], " sessions of light, \n",
        noAffectedRowsAccelerometer[1, 1], " sessions of accelerometer, \n",
        "But you will limit the delete to ",
        paste0(limit_to_type, collapse = " ,"),
        ".\nAre you sure?"
      )
    } else {
      choice_message <- paste0(
        "Your selection corresponds to  \n",
        noAffectedRowsTemp[1, 1], " sessions of temperature, \n",
        noAffectedRowsAct[1, 1], " sessions of activity, \n",
        noAffectedRowsLight[1, 1], " sessions of light, \n",
        noAffectedRowsAccelerometer[1, 1], " sessions of accelerometer, \n",
        "Are you sure?"
      )
    }

    answer <- menu(
      c(
        "Yes (1)",
        "No (2)"
      ),
      title = choice_message
    )

    if (answer == 1) {
      if (is.null(limit_to_type)) {
        DBI::dbExecute(con, deleteLight)
        DBI::dbExecute(con, deleteTemp)
        DBI::dbExecute(con, deleteAct)
        DBI::dbExecute(con, deleteAccelerometer)
      } else {
        if ("light" %in% limit_to_type) {
          DBI::dbExecute(con, deleteLight)
        }
        if ("temperature" %in% limit_to_type) {
          DBI::dbExecute(con, deleteTemp)
        }
        if ("activity" %in% limit_to_type) {
          DBI::dbExecute(con, deleteAct)
        }
        if ("acceleration" %in% limit_to_type) {
          DBI::dbExecute(con, deleteAccelerometer)
        }
      }
    }
  }
}
