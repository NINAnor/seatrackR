#' Connect to seatrack database
#'
#' This function establishes a connection to the Seatrack database. It is a simple convenience function that uses the
#' packages DBI and RPostgres (available from github via devtools::install_github("rstats-db/DBI") and
#' devtools::install_github("rstats-db/DBI"). Note that connections are only accepted from a limited IP-adresses.
#'
#' @param Username Character. Default = seatrack_reader
#' @param Password Character.
#' @return A DBI connection to the Seatrack database
#'
#' @examples
#' dontrun{
#' con <- seatrackConnect(Username = "testreader", Password = "testreader")
#' dbGetQuery(con, "SELECT * FROM loggers.logging_session LIMIT 10")
#' dbDisconnect(con)
#' }

seatrackConnect <- function(Username, Password) {

  if (!requireNamespace("DBI", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it using devtools::install_github(\"rstats-db/DBI\") ",
         call. = FALSE)
  }


  if (!requireNamespace("RPostgres", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it using devtools::install_github(\"rstats-db/RPostgres\") ",
         call. = FALSE)
  }


  con <- DBI::dbConnect(RPostgres::Postgres(), host = "localhost", dbname = "seatrack", user = Username, password = Password)

}

