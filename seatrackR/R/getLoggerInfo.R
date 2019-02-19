#' View the view info table
#'
#' This is a convenience function that reads from the view "views.logger_info". Note that there also exists a table "loggers.logger_info" with more limited information.
#' #'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' loggerInfo <- getLoggerInfo()
#' }

getLoggerInfo <- function(){
  checkCon()

  DBI::dbReadTable(con, Id(schema = "views", table = "logger_info")) %>% as_tibble()
}




