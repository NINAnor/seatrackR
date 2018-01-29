#' Update the logger models
#'
#' This is a convenience function that writes to the "metadata.logger_models"
#'
#' @param loggerData A named vector or data frame that fits the logger_model able in schema metadata.
#' @param append Logical, default True. If True, the line(s) is appended to the end of the table.
#' @param overwrite Logical, default False. WARNING!! If True, the function overwrites the current content of the logger_info table.
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' writeLoggerModels(sampleLoggerModels)
#' }


writeLoggerModels <- function(loggerModels, append = T, overwrite = FALSE){
  seatrackR:::checkCon()
  DBI::dbWithTransaction(
    con,
    {
      DBI::dbSendQuery(con, "SET search_path TO metadata, public")
      DBI::dbWriteTable(con, "logger_models", loggerModels, append = append, overwrite = overwrite)
    }
  )
}


