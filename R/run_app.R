run_app <- function(settings_path = file.path(getwd(), "seatrackR_app"), test = FALSE) {
    # settings_path

    app_dir <- system.file("shiny/db_app", package = "seatrackR")
    if (app_dir == "") stop("Could not find Shiny app directory.", call. = FALSE)
    # shiny::shinyOptions(settings_path = settings_path, logging_path = log_path, test = test)
    shiny::shinyOptions(settings_path = settings_path, test = test)
    shiny::runApp(app_dir)
}
