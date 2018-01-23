#' Import metadata
#'
#' This is a convenience function that writes to the "imports.metadata_import"
#'
#' The import_metadata table is one of the two major ways of importing data into the database.
#' Together with the table logger_import, this table handles all the routine information about loggers
#' and the fieldwork.
#'
#' @param metadaata A named vector or data frame that fits the metadata_import table in schema imports
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' writeMetadata(sampleMetadata)
#' }


writeMetadata <- function(metadata){
  seatrackR:::checkCon()

  DBI::dbSendQuery(con, "SET search_path TO imports, public")
  DBI::dbWithTransaction(
    con,
    {
      DBI::dbWriteTable(con, "metadata_import", metadata, append = T, overwrite = F)
    }
  )
}




