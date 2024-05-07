#' pruneRecordings Prune activity, light and temperature recording data that
#'
#' Delete activity, light and temperature recording data that is lacking an existing session_id in the loggers.logger_session table. #'
#' @param pruneLight Prune light table (slow). Boolean
#' @param pruneActivity Prune activity table (slow). Boolean
#' @param pruneTemperature Prune temperature table. Boolean
#' @param force
#'
#' @return Status message
#' @export
#'
#' @examples
#' dontrun{
#' pruneRecords()
#'
#' }
#'
pruneRecordings <- function(
    pruneLight = TRUE,
    pruneActivity = TRUE,
    pruneTemperature = TRUE,
    force = FALSE
    ){


  seatrackR:::checkCon()


  pruneLightQ <- "
  DELETE FROM recordings.light t
  USING (
  SELECT distinct session_id
  FROM recordings.light
  WHERE NOT session_id IN (
  SELECT distinct session_id FROM
  loggers.logging_session)
  ) foo
  WHERE t.session_id = foo.session_id
  "

  pruneActivityQ <- "
  DELETE FROM recordings.activity t
  USING (
  SELECT distinct session_id
  FROM recordings.activity
  WHERE NOT session_id IN (
  SELECT distinct session_id FROM
  loggers.logging_session)
  ) foo
  WHERE t.session_id = foo.session_id
  "

  pruneTemperatureQ <- "
  DELETE FROM recordings.temperature t
  USING (
  SELECT distinct session_id
  FROM recordings.temperature
  WHERE NOT session_id IN (
  SELECT distinct session_id FROM
  loggers.logging_session)
  ) foo
  WHERE t.session_id = foo.session_id
  "


  if(isTRUE(force)){

    message("This might take a while.")

    if(isTRUE(pruneLight)){
      message("Deleting orphaned rows in light table.")

      dbSendStatement(con,
                      pruneLightQ)
    }

    if(isTrue(pruneActivity)){
      message("Deleting orphaned rows in activity table.")

      dbSendStatement(con,
                      pruneActivityQ)
    }

    if(isTrue(pruneTemperature)){
      message("Deleting orphaned rows in temperature table.")

      dbSendStatement(con,
                      temperatureQ)
    }

  } else {

  if(any(pruneLight, pruneActivity)){
    answer <- menu(c("Yes (1)", "No (2)"),
                   title = paste0("Pruning light AND/OR activity will take several minutes, proceed?"))

    if(answer == 1){

      if(isTRUE(pruneLight)){
        message("Deleting orphaned rows in light table.")

        dbSendStatement(con,
                        pruneLightQ)
      }

      if(isTrue(pruneActivity)){
        message("Deleting orphaned rows in activity table.")

        dbSendStatement(con,
                        pruneActivityQ)
      }

      if(isTrue(pruneTemperature)){
        message("Deleting orphaned rows in temperature table.")

        dbSendStatement(con,
                        temperatureQ)
      }

    }

  }
  }


}
