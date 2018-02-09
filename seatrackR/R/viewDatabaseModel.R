#' View the database structure in a browser
#'
#' Zoom in with the browser to see the details
#'
#'
#' @return Opens a internet browser window with the database model.
#' @export
#' @examples
#' dontrun{
#' viewDatabaseModel()
#' }
#'

viewDatabaseModel <- function(){

  browseURL(system.file("img", "seatrackModel.png", package = "seatrackR"))
}
