#' Run the seatrackR Shiny app
#'
#' Function to run the seatrackR Shiny app. The app can be run from the package directory or from a separate directory where the app is installed.
#' @param settings_path Character. Path to the directory where the app is installed. Default is the current working directory. The app will look for a subdirectory called "seatrackR_app" in this directory.
#' @param test Logical. If TRUE, the app will run in test mode. Default is FALSE. In test mode, the app will use a test database.
#' @return None. The function runs the Shiny app.
#' @export
#' @examples
#' \dontrun{
#' run_app()
#' }
#' @concept shiny
#' @importFrom shiny runApp
#' @importFrom shinyjs useShinyjs
#' @importFrom future plan
#' @importFrom promises %...>%
#' @import bslib
#' @import leaflet
#' @import leaflet.extras
run_app <- function(settings_path = file.path(getwd(), "seatrackR_app"), test = FALSE) {
    # settings_path

    app_dir <- system.file("shiny/db_app", package = "seatrackR")
    if (app_dir == "") stop("Could not find Shiny app directory.", call. = FALSE)
    shiny::shinyOptions(settings_path = settings_path, test = test)
    shiny::runApp(app_dir)
}
