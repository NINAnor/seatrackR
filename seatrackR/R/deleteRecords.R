#' Delete records from the database, based on subselection criteria
#'
#' This is a convenience function that deletes records from the logging_session table, which cascades to dependent tables
#' (individ info and status, deployment and retrieval info, startup and shutdown tables, and file archive).
#'
#' @param selectSpecies Character string. Option to limit selection to one or a set of species.Default is NULL, indicating all species.
#' @param selectColony Character string. Option to limit selection to one or a set of colonies. Default is NULL.
#' @param selectUpdateTime Timestamp or character string that can be interpreted as a timestamp through as.POSIXct. Delete only
#' records that where last updated after this timestamp
#' @param selectSpecies Character string. Option to limit selection to one or a set of species. Default is NULL.
#' @param Force True, False (default = False). Skip confirmation check (for non interactive functionality)
#'
#' @return Status message
#' @import dplyr
#' @export
#' @examples
#' dontrun{
#' deleteRecords(selectUpdateTime = "2018-04-20")
#' }


deleteRecords <- function(selectColony = NULL,
                          selectYear = NULL,
                          selectSpecies = NULL,
                          Force = F){

  #checkCon()


#append dummy condition to ease later conditions
deleteSessions <- "DELETE FROM loggers.logging_session as ls WHERE 1=1"
deleteStartups <- "DELETE FROM loggers.startup USING loggers.startup as s
                LEFT OUTER JOIN loggers.logging_session as ls ON s.session_id = ls.session_id
                WHERE startup.id = s.id"


deleteMetadata <- "WITH foo as(SELECT ls.colony, ls.species, deployment_date \"date\" FROM loggers.deployment d LEFT JOIN
                  loggers.logging_session ls on d.session_id = ls.session_id UNION
                  SELECT ls.colony, ls.species, retrieval_date \"date\" FROM loggers.retrieval r LEFT JOIN
                  loggers.logging_session ls on r.session_id = ls.session_id)
                  DELETE FROM imports.metadata_import USING imports.metadata_import as m
                  LEFT OUTER JOIN foo ON foo.colony = m.colony AND foo.date = m.date
                  WHERE metadata_import.id = m.id"

selectQuery <- "SELECT count(*) FROM loggers.logging_session as ls WHERE 1=1"



if(!is.null(selectColony)){
  deleteSessions <- paste0(deleteSessions, "\nAND ls.colony = '", selectColony, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.colony = '", selectColony, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.colony = '", selectColony, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.colony = '", selectColony, "'")
}

if(!is.null(selectYear)){
  deleteSessions <- paste0(deleteSessions, "\nAND ls.year_tracked = '", selectYear, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.year_tracked = '", selectYear, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.year_tracked = '", selectYear, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.year_tracked = '", selectYear, "'")
}


if(!is.null(selectSpecies)){
  deleteSessions <- paste0(deleteSessions, "\nAND ls.species = '", selectSpecies, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.species = '", selectSpecies, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.species = '", selectSpecies, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.species = '", selectSpecies, "'")
}


noAffectedRows <- DBI::dbGetQuery(con, selectQuery)

if(isTRUE(Force)){
  DBI::dbSendQuery(con, deleteMetadata)
  DBI::dbSendQuery(con, deleteStartups)
  DBI::dbSendQuery(con, deleteSessions)


} else{

  answer <- menu(c("Yes (1)", "No (2)"), title = paste0("You are about to delete ", noAffectedRows[1,1], " records. Are you sure?"))

  if(answer == 1){
    DBI::dbSendQuery(con, deleteMetadata)
    DBI::dbSendQuery(con, deleteStartups)
    DBI::dbSendQuery(con, deleteSessions)


  }


}

}

