#' View the logger info table
#'
#' This is a convenience function that reads from the table "loggers.logger_info"
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' loggerInfo <- getLoggerInfo()
#' }

getLoggerInfo <- function(){
  seatrackR:::checkCon()

  DBI::dbGetQuery(con, "SELECT * FROM loggers.logger_info")
}




