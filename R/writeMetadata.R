#' Import metadata
#'
#' This is a convenience function that writes to the "imports.metadata_import"
#'
#' The import_metadata table is one of the two major ways of importing data into the database.
#' Together with the table logger_import, this table handles all the routine information about loggers
#' and the fieldwork.
#'
#' @param metadata A named vector or data frame that fits the metadata_import table in schema imports
#'
#' @return Data frame.
#' @export
#' @examples
#' \dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' writeMetadata(sampleMetadata)
#' }
#' @concept metadata
writeMetadata <- function(metadata) {
  checkCon()

  DBI::dbExecute(con, "SET search_path TO imports, public")

  DBI::dbWithTransaction(
    con,
    {
      DBI::dbWriteTable(
        con,
        "metadata_import",
        metadata,
        append = TRUE,
        overwrite = FALSE
      )
    }
  )
}


