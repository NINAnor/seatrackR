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
                            ...) {
  if (!requireNamespace("DBI", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it using devtools::install_github(\"rstats-db/DBI\") ",
      call. = FALSE
    )
  }


  if (!requireNamespace("RPostgres", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it using devtools::install_github(\"rstats-db/RPostgres\") ",
      call. = FALSE
    )
  }

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


  set_credentials_renviron(Username, Password)

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

  assign("con", tmp, .GlobalEnv)
  assign(".pass", Password, envir = passEnv)

  # Set the timezone to correspond to the database timezone
  Sys.setenv(TZ = "Europe/Oslo")
}

#' @export
#' @rdname connectSeatrack
#' @concept db_connection
disconnectSeatrack <- function() {
  DBI::dbDisconnect(con)
}
