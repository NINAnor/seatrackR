#' View the database structure in a browser
#'
#' Zoom in with the browser to see the details
#'
#' @param type Open the database model in either "png" or "svg".
#' @return Opens a internet browser window with the database model.
#' @export
#' @examples
#' \dontrun{
#' viewDatabaseModel()
#' }
#' @concept general_db
viewDatabaseModel <- function(type = c("png")) {
  type <- match.arg(type, c("png"))

  browseURL(system.file("img", paste0("seatrackModel.", type), package = "seatrackR"))
}
