#' View the logger info table
#'
#' This is a convenience function that reads from the table "loggers.logger_info"
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' loggerInfo <- getLoggerInfo()
#' }

getLoggerInfo <- function(){
  if(!exists("con")) stop("No active connection, run seatrackConnect()")

  DBI::dbGetQuery(con, "SELECT * FROM loggers.logger_info")
}


