#' View the active logger sessions
#'
#' This is a convenience function that reads from the view "views.active_logging_sessions. It simply lists all logging
#' sessions marked "active = TRUE"
#'
#' @return Data frame.
#' @examples
#' dontrun{
#' con <- seatrackConnect(Username = "testreader", Password = "testreader")
#' activeSessions <- viewActiveSessions()
#' }

viewActiveSessions <- function(connection = con) {
  dbGetQuery(connection, "SELECT * FROM views.active_logging_sessions")
}

