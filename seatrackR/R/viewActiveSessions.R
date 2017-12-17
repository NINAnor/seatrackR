#' View the active logger sessions
#'
#' This is a convenience function that reads from the view "views.active_logging_sessions. It simply lists all logging
#' sessions marked "active = TRUE"
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' activeSessions <- viewActiveSessions()
#' }

viewActiveSessions <- function() {
  seatrackR:::checkCon()
  dbGetQuery(con, "SELECT * FROM views.active_logging_sessions")
}

