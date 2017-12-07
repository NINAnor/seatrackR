#' Connect to seatrack database
#'
#' This function establishes a connection to the Seatrack database. It is a simple convenience function that uses the
#' packages DBI and RPostgres (available from github via devtools::install_github("rstats-db/DBI") and
#' devtools::install_github("rstats-db/DBI"). Note that connections are only accepted from a limited IP-adresses.
#'
#' @param Username Character. Default = seatrack_reader
#' @param Password Character.
#' @return A DBI connection to the Seatrack database
#' @import DBI
#' @export
#' @examples
#' dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' dbGetQuery(con, "SELECT * FROM loggers.logging_session LIMIT 10")
#' dbDisconnect(con)
#' }

seatrackConnect <- function(Username, Password, host = "ninseatrack01.nina.no") {

  if (!requireNamespace("DBI", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it using devtools::install_github(\"rstats-db/DBI\") ",
         call. = FALSE)
  }


  if (!requireNamespace("RPostgres", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it using devtools::install_github(\"rstats-db/RPostgres\") ",
         call. = FALSE)
  }


  tmp <- DBI::dbConnect(RPostgres::Postgres(), host = host, dbname = "seatrack", user = Username, password = Password)
  assign("con", tmp, .GlobalEnv)

}

