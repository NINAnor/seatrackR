#' Connect to seatrack database
#'
#' This function establishes a connection to the Seatrack database. Note that connections are only accepted from limited IP-adresses.
#' Ideally, credentials should first be set using `set_credentials_renviron()`. This should only have to be done once per project.
#' After this, credentials will be loaded automatically.
#'
#' The function opens a connection to the database, which other functions in seatrackRdb will use.
#' @param Username Character. If not provided, first attempts to check environmental variables then calls set_credentials_renviron()
#' @param Password Character. If not provided, first attempts to check environmental variables then calls set_credentials_renviron()
#' @param host Character. The host of the database. For testing purposes. There should be no need for the user to change this.
#' @param dbname Character. Name of database, for testing purposes. Default is "seatrack" which is the production database.
#' @param bigint Character. How to handle big integers. Default is "integer". Other options are "numeric" and "character".
#' @param save_credentials Boolean. If TRUE, credentials will be saved to .Renviron for future use. Default is TRUE.
#' @param global Boolean. If TRUE, the connection object will be assigned to the global environment. If FALSE, the connection object will be returned. Default is TRUE.
#' @param ... Additional arguments passed to DBI::dbConnect()
#' @return Assigns a connection object to the global variable `con`.
#' @import DBI
#' @export
#' @concept db_connection
connectSeatrack <- function(Username = NULL,
                            Password = NULL,
                            host = "seatrack.nina.no",
                            dbname = "seatrack",
                            bigint = "integer",
                            save_credentials = TRUE,
                            global = TRUE,
                            ...) {

  if (is.null(Username)) {
    Username <- Sys.getenv("SEATRACK_DB_USER", NA)
    if (is.na(Username)) {
      Username <- NULL
    }
  }

  if (is.null(Password)) {
    Password <- Sys.getenv("SEATRACK_DB_PWD", NA)
    if (is.na(Password)) {
      Password <- NULL
    }
  }


  set_credentials_renviron(Username, Password, save = save_credentials)

  Username <- Sys.getenv("SEATRACK_DB_USER", NA)
  Password <- Sys.getenv("SEATRACK_DB_PWD", NA)


  tmp <- DBI::dbConnect(RPostgres::Postgres(),
    host = host,
    dbname = dbname,
    user = Username,
    password = Password,
    bigint = bigint,
    ...
  )
  if(global){
    assign("con", tmp, .GlobalEnv)
    assign(".pass", Password, envir = passEnv)
  }else{
    return(tmp)
  }


}

#' @export
#' @rdname connectSeatrack
#' @concept db_connection
disconnectSeatrack <- function() {
  DBI::dbDisconnect(con)
}
