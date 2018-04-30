#' Retrieve summary info on the registered raw-files
#'
#' This is a convenience function that pulls together various info on the files in the loggers.file_archive table and other tables
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' fileArchive <- getFileArchive()
#' }

getFileArchiveSummary <- function(selectColony = NULL,
                           selectYear = NULL){
  checkCon()

  res <- DBI::dbGetQuery(con,
  "SELECT f.file_id, f.session_id, ls.colony, ii.ring_number, ii.euring_code, ls.year_tracked, li.logger_serial_no, li.logger_model, f.filename
  FROM loggers.file_archive f, loggers.logging_session ls, individuals.individ_info ii, loggers.logger_info li
  WHERE f.session_id = ls.session_id
  AND ls.logger_id = li.logger_id
  AND ls.individ_id = ii.individ_id
  ORDER BY file_id")  %>% as_tibble()


if(!is.null(selectColony)){
  res <- res %>% filter(colony %in% selectColony)
}

if(!is.null(selectYear)){
  res <- res %>% filter(year_tracked %in% selectYear)
}

return(res)

}
