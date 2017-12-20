#' Update the logger info table
#'
#' This is a convenience function that writes to the "loggers.logger_info"
#'
#' @param loggerData A named vector or data frame that fits the logger_info table in schema loggers
#' @param append Logical, default True. If True, the line(s) is appended to the end of the table.
#' @param overwrite Logical, default False. WARNING!! If True, the function overwrites the current content of the logger_info table.
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' newLogger <- data.frame("logger_serial_no" = "test_9876", "producer" = "testproducer",
#' "production_year" = 2010, "logger_model" = "testmodel", "project" = "seatrack")
#' writeLoggerInfo(loggerData)
#' }


writeLoggerInfo <- function(loggerData, append = T, overwrite = FALSE){
  seatrackR:::checkCon()
  DBI::dbWithTransaction(
    con,
    {
      DBI::dbSendQuery(con, "SET search_path TO loggers, public")
      DBI::dbWriteTable(con, "logger_info", loggerData, append = append, overwrite = overwrite)
    }
  )
}


