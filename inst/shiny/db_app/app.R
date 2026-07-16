library(shiny)
library(bslib)

library(seatrackR)
source("main_ui.R")
source("main_server.R")
source("query_constructor.R")
source(system.file(file.path("shiny", "shared_modules", "connect_db.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "selector_modal.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "optional_date.R"), package = "seatrackR"))
readRenviron(".Renviron")



shinyApp(
    ui = main_ui("main"),
    server = function(input, output, session) {
        # bs_themer()
        main_server("main")
    }
)
