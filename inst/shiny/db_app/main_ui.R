main_ui <- function(id) {
    ns <- NS(id)
    no_styling_classes <- "border-0 shadow-none bg-transparent"
    theme <- bs_theme(version = 5, preset = "bootstrap")
    theme <- bs_theme_update(theme,
        secondary = "#7499BA", font_scale = NULL,
        `enable-rounded` = FALSE, preset = "bootstrap"
    )

    page_fluid(
        shinyjs::useShinyjs(),
        tags$head(
            tags$style(HTML("
      .modal-danger .modal-content {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .modal-danger .modal-header {
        border-bottom-color: #f5c6cb;
      }

      .modal-danger .modal-footer {
        border-top-color: #f5c6cb;
      }


    ")),
            tags$script(HTML("
      Shiny.addCustomMessageHandler('styleModal', function(cls) {
        $('.modal').addClass(cls);
      });
    "))
        ),
        input_dark_mode(id = ns("dark_mode_switch"), mode = NULL),
        div(
            id = ns("splash_screen"),
            card(
            card_image(id = ns("placeholder_splash"), file = system.file(file.path("img", "SEATRACK_logo_landscape.jpg"), package = "seatrackR")),
            uiOutput(ns("splash_image")),
                class = paste(no_styling_classes, "pt-3 ps-3 pe-3 mb-0"),
                fillable = FALSE
            ),
            card(
                card_body(
                    connect_db_ui(ns("connect_db")),
                    class = "w-50"
                ),
                class = paste(no_styling_classes, "px-3 py-0 justify-content-center align-items-center"),
                fillable = FALSE,
            )
        ),
        shinyjs::hidden(
            div(
                id = ns("main_screen"),
                query_ui(ns("query_constructor")),
                navset_card_pill(
                    id = ns("main_display"),
                    full_screen = TRUE,
                    nav_panel(
                        title = "Logging sessions",
                        session_ui(ns("session_display"))
                    ),
                    nav_panel(
                        title = "Encounters",
                        encounter_ui(ns("encounter_display"))
                    ),
                    nav_panel(
                        title = "Positions",
                        position_ui(ns("position_display"))
                    ),
                    nav_panel(
                        title = "Recordings",
                        p("To do")
                    )
                ) # nav tabs go here to display the different outputs
            )
        )
    )
}
