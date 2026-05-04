#' Update the positions.postable
#'
#' This is a convenience function that writes to the "positions.postable_raw/gps_raw/irma_raw" table, the main tables for the position data. It then by default updates the views which links up this data to the logger session data in the database.
#'
#' @param datatype "GLS", "IRMA", or "GPS" data
#' @param positionData A list of position data to be read into the postable in the database. Usually created by `loadPosdata`.
#' @param refreshView Should the views be updated? Boolean. Note that this takes time, and only needs to be done after all changes have been made.
#' @return Message of affected rows
#' @export
#' @examples
#' \dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#'
#' files <- c(
#'   "posdata_FULGLA_eynhallow_2014",
#'   "posdata_FULGLA_eynhallow_2013",
#'   "posdata_FULGLA_eynhallow_2012",
#'   "posdata_FULGLA_eynhallow_2011",
#'   "posdata_FULGLA_eynhallow_2010",
#'   "posdata_FULGLA_eynhallow_2009",
#'   "posdata_FULGLA_eynhallow_2007"
#' )
#'
#' toImport <- loadPosdata(files)
#'
#' summary(toImport)
#'
#' writePositions(toImport)
#' }
#' @concept positions
writePositions <- function(datatype = "GLS",
                           positionData,
                           refreshView = TRUE) {
  checkCon()

  datatype <- match.arg(datatype,
    choices = c("GLS", "IRMA", "GPS")
  )

  source_table <- dplyr::case_when(
    datatype == "GLS" ~ "postable_raw",
    datatype == "IRMA" ~ "irma_raw",
    datatype == "GPS" ~ "gps_raw"
  )


  nRowsToImport <- sum(unlist(lapply(positionData, nrow)))

  res <- dplyr::tbl(con, dbplyr::in_schema("positions", source_table))

  nRow_string <- paste0(
    "SELECT count(*) FROM positions.",
    source_table
  )

  DBI::dbWithTransaction(
    con,
    {
      nRowsBefore <- DBI::dbGetQuery(con, nRow_string)
      DBI::dbSendQuery(con, "SET search_path TO positions, public")

      for (i in 1:length(positionData)) {
        dbWriteTable(con,
          source_table,
          positionData[[i]],
          row.names = FALSE,
          append = TRUE
        )
      }

      nRowsAfter <- DBI::dbGetQuery(con, nRow_string)

      nRowsImported <- nRowsAfter - nRowsBefore

      if (nRowsImported != nRowsToImport) {
        dbBreak()
        return("Not all lines could be imported, aborted import!")
      }
    }
  )

  view_name <- dplyr::case_when(
    datatype == "GLS" ~ "postable",
    datatype == "IRMA" ~ "irma",
    datatype == "GPS" ~ "gps"
  )

  if (refreshView) {
    DBI::dbSendQuery(con, paste0("REFRESH MATERIALIZED VIEW positions.", view_name))
  }

  print(paste0(nRowsImported, " rows imported to positions.", source_table))
  return()
}
