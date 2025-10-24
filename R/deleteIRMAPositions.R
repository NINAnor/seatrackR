#' Delete rows in positions.irma_raw table, and update the positions.irma view
#'
#' @param sessionId Vector of sessionsIDs to remove in table.
#' @param refreshView Optionally refresh the irma view to reflect changes. Default TRUE.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' #' connectSeatrack(Username = "testreader", Password = "testreader")
#' delFiles<-c("L296_2014-04-25")
#' deletePostable(delFiles)
#' }
#'
#'


deleteIRMAPositions <- function(sessionId,
                       refreshView = TRUE){
  seatrackR:::checkCon()

  sessionsInTable <- list()
  for(i in 1:length(sessionId)){

    toDelete <- paste0("SELECT sessionid
                     FROM positions.irma
                     WHERE session_id = '",
                       sessionId[i],
                       "'
      LIMIT 1")

    result <- dbGetQuery(con, toDelete)
    sessionsInTable <- c(sessionsInTable, result)
  }


  sumSessionsExisting <- sum(unlist(lapply(sessionsInTable, function(x) length(x) > 0)))

  if(length(sessionId) != sumSessionsExisting) stop(paste0(sessionId[!(sessionId %in% unlist(sumSessionsExisting))], " not in IRMA table!"))

  rowsInTable <- list()
  for(i in 1:length(delFiles)){

    toDelete <- paste0("SELECT count(*)::integer
                     FROM positions.irma_raw
                     WHERE sessionId = '",
                       sessionId[i],
                       "'
      LIMIT 1")

    result <- dbGetQuery(con, toDelete)
    rowsInTable <- c(rowsInTable, result)
  }

  nRowsToDelete <- sum(unlist(rowsInTable))


  DBI::dbWithTransaction(
    con,
    {
      nRowsBefore <- DBI::dbGetQuery(con, "SELECT count(*) FROM positions.irma_raw")
      DBI::dbSendQuery(con, "SET search_path TO positions, public")


      for(i in 1:length(delFiles)){
        toDelete<-paste0("DELETE
                   FROM positions.irma_raw
                   WHERE posdata_file = '",
                         sessionId[i],
                         "'")

        result <- dbSendQuery(con, toDelete)
      }


      nRowsAfter <- DBI::dbGetQuery(con, "SELECT count(*) FROM positions.irma_raw")

      ##Get rowsToDelete
      nRowsDeleted <- nRowsBefore - nRowsAfter

      if(nRowsDeleted != nRowsToDelete){
        dbBreak()
        return("Not all lines could be deleted, aborted!")

      }

    })

  if(refreshView){
    dbSendQuery(con,
                "REFRESH MATERIALIZED VIEW positions.irma;")
  }

  return(paste0("All ", nRowsToDelete, " lines deleted, attributed to ", sumFilesExisting, " session IDs."))


}
