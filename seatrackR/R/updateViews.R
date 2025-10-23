#' Manually update the the materialized views of database stats
#'
#' This runs a function that manually updates the materialized views in the schema "views". Earlier this was done automatically after all
#' inserts or updates to postable, but this was time consuming, possibly because it triggered the update many times. Now the needs
#' to be updated manually, for example by using this function. Beware that it takes a couple of minutes to complete.
#'
#'
#'
#'
#' @return NULL
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' updatePosdataSession()
#' }

updateViews <- function(){
  seatrackR:::checkCon()


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
    upd <- DBI::dbSendStatement(con, "SELECT functions.fn_manual_update_materialized_views_on_postable_update()")
    DBI::dbClearResult(upd)

    upd <- DBI::dbSendStatement(con, "SELECT functions.fn_manual_update_materialized_views_on_postable_update2()")
    DBI::dbClearResult(upd)
  }
}


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
    if(all == TRUE){
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
    } else {
    upd <- DBI::dbSendStatement(con, paste0("REFRESH MATERIALIZED VIEW ", specific_table, ";"))
    DBI::dbClearResult(upd)
    }
  }
}

