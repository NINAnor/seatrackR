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
#' @deleteActivity Delete also recordings. Defaults to true. Note that in order to allow this, the recording tables does not have any foreign keys.
#'
#' @return Status message
#' @import dplyr
#' @export
#' @examples
#' dontrun{
#' deleteRecords(selectUpdateTime = "2018-04-20")
#' }


deleteRecords <- function(colony = NULL,
                          intendedLocation = NULL,
                          year = NULL,
                          species = NULL,
                          updatedAfter = NULL,
                          updatedBefore = NULL,
                          updatedBy = NULL,
                          sessionId = NULL,
                          force = FALSE,
                          deleteActivity = TRUE){

  seatrackR:::checkCon()

#append dummy condition to ease later conditions
deleteTemp<- "DELETE FROM recordings.temperature
                USING recordings.temperature as t
                LEFT OUTER JOIN loggers.logging_session as ls ON
                t.session_id = ls.session_id
                LEFT OUTER JOIN loggers.allocation a ON
                ls.session_id = a.session_id
                WHERE temperature.id = t.id"

#append dummy condition to ease later conditions
deleteAct<- "DELETE FROM recordings.activity
                USING recordings.activity as act
                LEFT OUTER JOIN loggers.logging_session as ls ON
                act.session_id = ls.session_id
                LEFT OUTER JOIN loggers.allocation a ON
                ls.session_id = a.session_id
                WHERE activity.id = act.id"

deleteLight<- "DELETE FROM recordings.light
                USING recordings.light as lig
                LEFT OUTER JOIN loggers.logging_session as ls ON
                lig.session_id = ls.session_id
                LEFT OUTER JOIN loggers.allocation a ON
                ls.session_id = a.session_id
                WHERE light.id = lig.id"


#append dummy condition to ease later conditions
deleteSessions <- "DELETE FROM loggers.logging_session
                  USING loggers.logging_session as ls
                  LEFT OUTER JOIN loggers.allocation a ON
                  ls.session_id = a.session_id
                  WHERE logging_session.id = ls.id"

#deleteSessions <- "DELETE FROM loggers.logging_session as ls USING loggers.allocation a WHERE ls.session_id = a.session_id"

##Is this really necessary?
 deleteStartups <- "DELETE FROM loggers.startup
                USING loggers.startup as s
                LEFT OUTER JOIN loggers.logging_session as ls ON s.session_id = ls.session_id
                 LEFT OUTER JOIN loggers.allocation a ON ls.session_id = a.session_id
               WHERE startup.id = s.id"

# deleteStartups <- "DELETE FROM loggers.startup s USING loggers.logging_session as ls, loggers.allocation a
# 	WHERE s.session_id = ls.session_id
#         AND ls.session_id = a.session_id"

deleteMetadata <- "WITH foo as(SELECT a.intended_location, bar.*
                                  FROM (SELECT ls.session_id, ls.colony, ls.species, deployment_date \"date\"
                                          FROM loggers.deployment d LEFT JOIN
                                          loggers.logging_session ls on d.session_id = ls.session_id UNION
                                  SELECT ls.session_id, ls.colony, ls.species, retrieval_date \"date\" FROM loggers.retrieval r LEFT JOIN
                                        loggers.logging_session ls on r.session_id = ls.session_id) bar LEFT OUTER JOIN loggers.allocation a ON bar.session_id = a.session_id)
                  DELETE FROM imports.metadata_import USING imports.metadata_import as m
                  LEFT OUTER JOIN foo ON foo.colony = m.colony AND foo.date = m.date
                  WHERE metadata_import.id = m.id"

selectQuery <- "SELECT count(*) FROM loggers.logging_session as ls LEFT OUTER JOIN loggers.allocation a ON ls.session_id = a.session_id WHERE 1=1"

selectQueryTemp <- "SELECT count(distinct(filename)) FROM recordings.temperature as t
LEFT OUTER JOIN loggers.logging_session as ls ON
t.session_id = ls.session_id
LEFT OUTER JOIN loggers.allocation a ON
ls.session_id = a.session_id
WHERE 1=1"

selectQueryAct <- "SELECT count(distinct(filename)) FROM recordings.activity as act
                LEFT OUTER JOIN loggers.logging_session as ls ON
                act.session_id = ls.session_id
                LEFT OUTER JOIN loggers.allocation a ON
                ls.session_id = a.session_id
                WHERE 1=1"

selectQueryLight <- "SELECT count(distinct(filename)) FROM recordings.light as lig
                LEFT OUTER JOIN loggers.logging_session as ls ON
                lig.session_id = ls.session_id
                LEFT OUTER JOIN loggers.allocation a ON
                ls.session_id = a.session_id
                WHERE 1=1"


if(!is.null(colony)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.colony = '", colony, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.colony = '", colony, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.colony = '", colony, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.colony = '", colony, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.colony = '", colony, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.colony = '", colony, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.colony = '", colony, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.colony = '", colony, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND ls.colony = '", colony, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND ls.colony = '", colony, "'")
}

if(!is.null(intendedLocation)){
  deleteTemp <- paste0(deleteTemp, "\nAND a.intended_location = '", intendedLocation, "'")
  deleteAct <- paste0(deleteAct, "\nAND a.intended_location = '", intendedLocation, "'")
  deleteLight <- paste0(deleteLight, "\nAND a.intended_location = '", intendedLocation, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND a.intended_location = '", intendedLocation, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND a.intended_location = '", intendedLocation, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.intended_location = '", intendedLocation, "'")
  selectQuery <- paste0(selectQuery, "\nAND a.intended_location = '", intendedLocation, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND a.intended_location = '", intendedLocation, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND a.intended_location = '", intendedLocation, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND a.intended_location = '", intendedLocation, "'")
}


if(!is.null(year)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.year_tracked = '", year, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.year_tracked = '", year, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.year_tracked = '", year, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.year_tracked = '", year, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.year_tracked = '", year, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.year_tracked = '", year, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.year_tracked = '", year, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND a.intended_location = '", intendedLocation, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND a.intended_location = '", intendedLocation, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND a.intended_location = '", intendedLocation, "'")
}


if(!is.null(species)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.species = '", species, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.species = '", species, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.species = '", species, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.species = '", species, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.species = '", species, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.species = '", species, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.species = '", species, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.species = '", species, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND ls.species = '", species, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND ls.species = '", species, "'")
}

if(!is.null(updatedAfter)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.last_updated > '", updatedAfter, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.last_updated > '", updatedAfter, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.last_updated > '", updatedAfter, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.last_updated > '", updatedAfter, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.last_updated > '", updatedAfter, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND m.last_updated > '", updatedAfter, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.last_updated > '", updatedAfter, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.last_updated > '", updatedAfter, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND ls.last_updated > '", updatedAfter, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND ls.last_updated > '", updatedAfter, "'")
}

if(!is.null(updatedBefore)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.last_updated < '", updatedBefore, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.last_updated < '", updatedBefore, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.last_updated < '", updatedBefore, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.last_updated < '", updatedBefore, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.last_updated < '", updatedBefore, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND m.last_updated < '", updatedBefore, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.last_updated < '", updatedBefore, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.last_updated < '", updatedBefore, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND ls.last_updated < '", updatedBefore, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND ls.last_updated < '", updatedBefore, "'")
}

if(!is.null(updatedBy)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.updated_by = '", updatedBy, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.updated_by = '", updatedBy, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.updated_by = '", updatedBy, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.updated_by = '", updatedBy, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.updated_by = '", updatedBy, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND m.updated_by = '", updatedBy, "'")
  selectQuery <- paste0(selectQuery, "\nAND updated_by = '", updatedBy, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND updated_by = '", updatedBy, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND updated_by = '", updatedBy, "'")
  selectQueryLight <- paste0(selectQueryLight, "\nAND updated_by = '", updatedBy, "'")
}

if(!is.null(sessionId)){
  deleteTemp <- paste0(deleteTemp, "\nAND ls.session_id = '", sessionId, "'")
  deleteAct <- paste0(deleteAct, "\nAND ls.session_id = '", sessionId, "'")
  deleteLight <- paste0(deleteLight, "\nAND ls.session_id = '", sessionId, "'")
  deleteSessions <- paste0(deleteSessions, "\nAND ls.session_id = '", sessionId, "'")
  deleteStartups <- paste0(deleteStartups, "\nAND ls.session_id = '", sessionId, "'")
  deleteMetadata <- paste0(deleteMetadata, "\nAND foo.session_id = '", sessionId, "'")
  selectQuery <- paste0(selectQuery, "\nAND ls.session_id = '", sessionId, "'")
  selectQueryTemp <- paste0(selectQueryTemp, "\nAND ls.session_id = '", sessionId, "'")
  selectQueryAct <- paste0(selectQueryAct, "\nAND ls.session_id = '", sessionId, "'")
  selectQueryLught <- paste0(selectQueryLight, "\nAND ls.session_id = '", sessionId, "'")
}


noAffectedRows <- DBI::dbGetQuery(con, selectQuery)
noAffectedRowsTemp <- DBI::dbGetQuery(con, selectQueryTemp)
noAffectedRowsAct <- DBI::dbGetQuery(con, selectQueryAct)
noAffectedRowsLight <- DBI::dbGetQuery(con, selectQueryLight)

if(isTRUE(force)){
   if(isTrue(deleteActivity)){
    DBI::dbExecute(con, deleteLight)
    DBI::dbExecute(con, deleteTemp)
    DBI::dbExecute(con, deleteAct)
  }
  DBI::dbExecute(con, deleteMetadata)
  DBI::dbExecute(con, deleteStartups)
  DBI::dbExecute(con, deleteSessions)


} else {

  answer <- menu(c("Yes (1)", "No (2)"), title = paste0("Your selection corresponds to  \n", noAffectedRows[1,1], " logging sessions,\n",
                                                        noAffectedRowsTemp[1,1], " temperature files, \n",
                                                        noAffectedRowsAct[1,1], " activity files, \n",
                                                        noAffectedRowsLight[1,1], " light files, \n",
                                                        "Are you sure?"))

  if(answer == 1){

    if(isTRUE(deleteActivity)){
      DBI::dbExecute(con, deleteLight)
      DBI::dbExecute(con, deleteTemp)
      DBI::dbExecute(con, deleteAct)
    }
    DBI::dbExecute(con, deleteMetadata)
    DBI::dbExecute(con, deleteStartups)
    DBI::dbExecute(con, deleteSessions)

  }


}

}

