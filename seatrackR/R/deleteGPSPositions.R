#' Delete rows from positions.gps_raw table and updates the materialized view gps
#'
#' This is a convenience function that deletes rows from the "positions.gps" table, specified by which posdata file they originated from.
#' USE THIS WITH CAUTION!
#'
#' @param delFiles A character vector of posdata files to delete from the gps_raw table
#' @param refreshView Refresh the materialized view positions.gps to reflect the changes? Default TRUE.
#'
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' delFiles<-c("posdata_FULGLA_eynhallow_2015")
#' deleteGPSPositions(delFiles)
#'
#' }


deleteGPSPositions <- function(delFiles,
                           refreshView = TRUE){
  seatrackR:::checkCon()

  filesInGPSTable <- list()
    for(i in 1:length(delFiles)){

    toDelete <- paste0("SELECT posdata_file
                     FROM positions.gps_raw
                     WHERE posdata_file = '",
      delFiles[i],
      "'
      LIMIT 1")

    result <- dbGetQuery(con, toDelete)
    filesInGPSTable <- c(filesInGPSTable, result)
  }


  sumFilesExisting <- sum(unlist(lapply(filesInGPSTable, function(x) length(x) > 0)))

  if(length(delFiles) != sumFilesExisting) stop(paste0(delFiles[!(delFiles %in% unlist(filesInGPSTable))], " not in gps table!"))

  rowsInGPStable <- list()
  for(i in 1:length(delFiles)){

    toDelete <- paste0("SELECT count(*)::integer
                     FROM positions.gps_raw
                     WHERE posdata_file = '",
                       delFiles[i],
                       "'
      LIMIT 1")

    result <- dbGetQuery(con, toDelete)
    rowsInGPStable <- c(rowsInGPStable, result)
  }

  nRowsToDelete <- sum(unlist(rowsInGPStable))


  DBI::dbWithTransaction(
    con,
    {
      nRowsBefore <- DBI::dbGetQuery(con, "SELECT count(*) FROM positions.gps_raw")
      DBI::dbSendQuery(con, "SET search_path TO positions, public")


      for(i in 1:length(delFiles)){
        toDelete<-paste0("DELETE
                   FROM positions.gps_raw
                   WHERE posdata_file = '",
                         delFiles[i],
                         "'")

        result <- dbSendQuery(con, toDelete)
      }


      nRowsAfter <- DBI::dbGetQuery(con, "SELECT count(*) FROM positions.gps_raw")

      ##Get rowsToDelete
      nRowsDeleted <- nRowsBefore - nRowsAfter

      if(nRowsDeleted != nRowsToDelete){
        dbBreak()
        return("Not all lines could be deleted, aborted!")

      }

    })

    if(refreshView){
    dbSendQuery(con,
                "REFRESH MATERIALIZED VIEW positions.gps;")
    }

      return(paste0("All ", nRowsToDelete, " lines deleted, attributed to ", sumFilesExisting, " posdata files."))


}


