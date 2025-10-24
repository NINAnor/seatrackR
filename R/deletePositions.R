#' deletePositions
#'
#' Delete position data from either positions.postable_raw, positions.gps_raw, or positions.irma_raw, based on session_ids, and optionally refresh views.
#'
#' @param datatype "GLS", "IRMA", or "GPS".
#' @param session_ids_to_delete Character string (or vector of character trings), specifying which session_ids to remove data from.
#' @param refreshView Should the materialized position views be refreshed after the deletion? Defaults to TRUE.
#'
#' @return Message with affected rows
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' deletePositions(datatype = "GLS",
#'               session_ids_to_delete = c("60171_2022-06-30", "63170_2022-06-30"),
#'               refreshView = TRUE)
#' }

deletePositions <- function(datatype = "GLS",
                            session_ids_to_delete,
                            refreshView = TRUE){
  seatrackR:::checkCon()

  datatype <- match.arg(datatype,
                        choices = c("GLS", "IRMA", "GPS")
                        )

  source_table <- dplyr::case_when(datatype == "GLS" ~ "postable_raw",
                                   datatype == "IRMA" ~ "irma_raw",
                                   datatype == "GPS" ~ "gps_raw")

  res <- dplyr::tbl(con, dbplyr::in_schema("positions", source_table))

  nRowsToDelete <- res |>
    filter(session_id %in% session_ids_to_delete) |>
    tally() |>
    pull()

  sessionsInTable <- res |>
    filter(session_id %in% session_ids_to_delete) |>
    select(session_id) |>
    distinct() |>
    pull()


  if(length(session_ids_to_delete) != length(unique(sessionsInTable))) stop("Sessions ", paste0(session_ids_to_delete[!(session_ids_to_delete %in% sessionsInTable)], " not in table!"))

  nRow_string <- paste0("SELECT count(*) FROM positions.",
                        source_table)

  delete_string <- paste0("DELETE FROM positions.",
                          source_table,
                          " WHERE session_id %in% '",
                          paste(session_ids_to_delete,
                                collapse = "','"),
                          "'")

  DBI::dbWithTransaction(
    con,
    {
      nRowsBefore <- DBI::dbGetQuery(con,
                                     nRow_string)

      DBI::dbSendStatement(con,
                           delete_string)

      nRowsAfter <- DBI::dbGetQuery(con,
                                     nRow_string)

      nRowsDeleted <- nRowsBefore - nRowsAfter

      if(nRowsDeleted != nRowsToDelete){
        dbBreak()
        return("Not all lines could be deleted, aborted!")
      }

    })

  if(refreshView){
    refresh_string <- paste0("REFRESH MATERIALIZED VIEW positions.", source_table)
    dbSendQuery(con,
                refresh_string)
  }

  return(paste0("All ", nRowsToDelete, " lines deleted, attributed to ", length(unique(sessionsInTable)), " session IDs."))

}

