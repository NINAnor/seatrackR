#' Update the positions.postable
#'
#' This is a convenience function that writes to the "positions.postable" table, the main table for the position data.
#'
#' @param datatype "GLS", "IRMA", or "GPS" data
#' @param positionData A list of position data to be read into the postable in the database. Usually created by `loadPosdata`.
#' @return Message of affected rows
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#'
#'  files<-c("posdata_FULGLA_eynhallow_2014",
#'           "posdata_FULGLA_eynhallow_2013",
#'           "posdata_FULGLA_eynhallow_2012",
#'           "posdata_FULGLA_eynhallow_2011",
#'           "posdata_FULGLA_eynhallow_2010",
#'           "posdata_FULGLA_eynhallow_2009",
#'           "posdata_FULGLA_eynhallow_2007"
#'           )
#'
#' toImport <- loadPosdata(files)
#'
#' summary(toImport)
#'
#' writePositions(toImport)
#'
#' }


writePositions <- function(datatype = "GLS",
                           positionData,
                           refreshView = TRUE){
  seatrackR:::checkCon()

  datatype <- match.arg(datatype,
                        choices = c("GLS", "IRMA", "GPS")
  )

  source_table <- dplyr::case_when(datatype == "GLS" ~ "postable_raw",
                                   datatype == "IRMA" ~ "irma_raw",
                                   datatype == "GPS" ~ "gps_raw")


  nRowsToImport <- sum(unlist(lapply(positionData, nrow)))

  res <- dplyr::tbl(con, dbplyr::in_schema("positions", source_table))

  nRow_string <- paste0("SELECT count(*) FROM positions.",
                        source_table)

  DBI::dbWithTransaction(
    con,
    {
      nRowsBefore <- DBI::dbGetQuery(con, nRow_string)
      DBI::dbSendQuery(con, "SET search_path TO positions, public")

      for(i in 1:length(positionData)){
        dbWriteTable(con, source_table, positionData[[i]],
                     row.names = F,
                     append = T)
      }

      nRowsAfter <- DBI::dbGetQuery(con, nRow_string)

      nRowsImported <- nRowsAfter - nRowsBefore

      if(nRowsImported != nRowsToImport){
        dbBreak()
        return("Not all lines could be imported, aborted import!")
      }

    })

      return(paste0("All ", nRowsToImport, " lines imported."))
}


