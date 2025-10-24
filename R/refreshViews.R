#' Manually update the the materialized views in the database
#'
#' Update all or optionally single materialized views in the database. Typically done after data imports.
#'
#'
#' @param all Update all materialized views?
#' @param onlySummaryTables only refresh (smaller) summary tables. Useful if you have already refreshed the position data at import.
#' @param onlyGLS Only update positions.postable?
#' @param onlyGPS Only update positions.gps?
#' @param onlyIrma Only update positions.irma?
#'
#' @return NULL
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' refreshViews()
#' }

refreshViews <- function(all = TRUE,
                         onlySummaryTables = FALSE,
                         onlyGLS = FALSE,
                         onlyGPS = FALSE,
                         onlyIrma = FALSE){

  seatrackR:::checkCon()

  if(all & sum(all, onlySummaryTables, onlyGLS, onlyGPS, onlyIrma) > 1) stop("Cannot select particular view if 'all' is TRUE!")
  if(sum(onlySummaryTables, onlyGLS, onlyGPS, onlyIrma) > 1) stop("Can only select 1 particular view in a time!")
  if(!all & sum(all, onlySummaryTables, onlyGLS, onlyGPS, onlyIrma) < 1) stop("Well, you've got to select something.")

  specific_table <- dplyr::case_when(
    isTRUE(onlyGLS) ~ "positions.postable",
    isTRUE(onlyGPS) ~ "positions.gps",
    isTRUE(onlyIrma) ~ "positions.irma"
  )

  current_user <- DBI::dbGetQuery(con, "SELECT current_user")

  current_roles <- DBI::dbGetQuery(con, paste0("select rolname from pg_user
                                                    join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
                                                    join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
                                                    where
                                                    pg_user.usename = '", current_user, "'"))
  current_roles <- current_roles[,1]

  if(!("admin" %in% current_roles || "seatrack_writer" %in% current_roles)) stop("Connected user needs to be part of seatrack_writer or admin group")

  answer <- menu(c("Yes (1)", "No (2)"), title = paste0("This will take a couple of minutes. Are you sure?"))


  if(answer == 1){
    if(all){
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.categories;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.longersum;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.shorttable;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.shorttableeqfilter3;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW positions.postable;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW positions.gps;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW positions.irma;")
      DBI::dbClearResult(upd)
    } else if(onlySummaryTables){
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.categories;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.longersum;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.shorttable;")
      DBI::dbClearResult(upd)
      upd <- DBI::dbSendStatement(con, "REFRESH MATERIALIZED VIEW views.shorttableeqfilter3;")
    } else {
      upd <- DBI::dbSendStatement(con, paste0("REFRESH MATERIALIZED VIEW ", specific_table, ";"))
      DBI::dbClearResult(upd)
    }
  }
}

