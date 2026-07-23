library(shiny)
library(bslib)

library(seatrackR)
source("main_ui.R")
source("main_server.R")
source("encounter_display.R")
source("sessions_display.R")
source("position_display.R")
source(system.file(file.path("shiny", "shared_modules", "connect_db.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "selector_modal.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "display_table.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "display_map.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "pagination_controls.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "paginated_query.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "query_constructor.R"), package = "seatrackR"))
source(system.file(file.path("shiny", "shared_modules", "export_data.R"), package = "seatrackR"))


library(future)
library(promises)

plan(sequential)
plan(multisession)

shinyApp(
    ui = main_ui("main"),
    server = function(input, output, session) {
        # bs_themer()
        main_server("main")
    }
)
