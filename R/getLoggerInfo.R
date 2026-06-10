#' View the view info table
#'
#' This is a convenience function that reads from the view "views.logger_info". Note that there also exists a table "loggers.logger_info" with more limited information.
#' #'
#' @param species Optional vector of character strings of species to limit the selection to.
#' @param colony Optional vector of character strings of colonies limit the selection to.
#' @param session Optional vector of character strings of session_id to limit the selection to.
#' @param individ_id Optional vector of character strings of individ_id to limit the selection to.
#' @param project subset data for a character vector of project names. Default is "SEATRACK", which means that by default only data from the SEATRACK project are included. Set to NULL to include all projects.
#' @param asTibble Boolean. Return result as Tibble instead of Lazy query? Tibble is slower, but also here forces the timezone to "UTC".
#' @return Lazy query or optionally a Tibble.
#' @export
#' @examples
#' \dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' loggerInfo <- getLoggerInfo()
#' }
#' @concept logger_info
getLoggerInfo <- function(species = NULL, colony = NULL, session = NULL, individ_id = NULL, project = "SEATRACK", asTibble = TRUE) {
  checkCon()

  res <- dplyr::tbl(con, dbplyr::in_schema("views", "logger_info"))
  arg_list <- list(species = species, colony = colony, session_id = session, individ_id = individ_id, project = project)
  for (i in seq_along(arg_list)) {
    val_name <- names(arg_list)[i]
    value <- arg_list[[i]]
    if (!is.null(value)) {
      res <- dplyr::filter(res, !!rlang::sym(val_name) %in% value)
    }
  }


  if (asTibble) {
    res <- res %>% dplyr::collect()

    # Forze timezone to be UTC
    res <- res %>%
      mutate(
        starttime_gmt = lubridate::force_tz(starttime_gmt,
          tzone = "UTC"
        ),
        programmed_gmt_time = lubridate::force_tz(programmed_gmt_time,
          tzone = "UTC"
        ),
      )
  }



  return(res)
}
