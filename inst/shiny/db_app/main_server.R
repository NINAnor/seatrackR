show_error_modal <- function(session, e) {
    showModal(
        modalDialog(
            title = "Error!",
            easy_close = TRUE,
            e,
        )
    )
    session$sendCustomMessage("styleModal", "modal-danger")
}

main_server <- function(id) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
        shinyjs::addClass("connect_db-login", "btn-lg")
        busy <- reactiveVal(FALSE)

        connected <- reactiveVal(FALSE)
        session_info <- reactiveVal(NULL)

        observeEvent(connected(), {
            if (connected()) {
                shinyjs::showElement("main_screen")
                shinyjs::hideElement("splash_screen")
            }
        })


        output$splash_image <- renderUI({
            if (input$dark_mode_switch == "light") {
                card_path <- system.file(file.path("img", "SEATRACK_logo_landscape.jpg"), package = "seatrackR")
            } else {
                card_path <- system.file(file.path("img", "SEATRACK_logo_landscape_inverted.png"), package = "seatrackR")
            }
            shinyjs::hideElement("placeholder_splash")
            card_image(file = card_path)
        })

        connect_db <- connect_db_server("connect_db", busy, getShinyOption("test", FALSE),
            on_success = function() {
                connected(TRUE)
            }, on_fail = function(e) {
                show_error_modal(session, e)
            }
        )
        session_filters <- query_server("query_constructor",
            source_data = session_info,
            modal_selectors = list(
                list(name = "colony"),
                list(name = "species"),
                list(name = "sex"),
                list(
                    name = "logger_deployment_date_between",
                    type = "date_range",
                    button_name = "Deployment date",
                    var_name = "deployment_date"
                ),
                list(
                    name = "logger_retrieval_date_between",
                    type = "date_range",
                    button_name = "Retrieval date",
                    var_name = "retrieval_date"
                ),
                list(
                    name = "deployment_age_class",
                    button_name = "Deployment age",
                    choice_function = c(Chick = "C", Adult = "A") # Move this to the view
                ),
                list(name = "logger_type"),
                list(name = "project"),
                list(name = "has_positions"),
                list(name = "has_irma"),
                list(name = "logger_serial_no", extra = TRUE, type = "text"),
                list(name = "individ_id", extra = TRUE, type = "text"),
                list(name = "logger_model", extra = TRUE),
                list(name = "producer", extra = TRUE),
                list(name = "sexing_method", extra = TRUE),
                list(name = "logging_mode", extra = TRUE),
                list(name = "deployment_logger_status", extra = TRUE),
                list(name = "retrieval_logger_status", extra = TRUE),
                list(name = "download_type", extra = TRUE),
                list(
                    name = "logger_shutdown_date_between",
                    type = "date_range",
                    button_name = "Shutdown date",
                    var_name = "shutdown_date",
                    extra = TRUE
                )
            ),
            default_filter = function() {
                list(
                    session_id = NULL,
                    individ_id = NULL,
                    project = NULL,
                    logger_serial_no = NULL,
                    logger_model = NULL,
                    logger_producer = NULL,
                    logger_type = NULL,
                    logger_deployed = NULL,
                    logger_retrieved = NULL,
                    active = NULL,
                    colony = NULL,
                    species = NULL,
                    deployment_age_class = NULL,
                    sex = NULL,
                    sexing_method = NULL,
                    years_tracked = NULL,
                    logger_start_time = NULL,
                    logger_start_time_between = NULL,
                    logging_mode = NULL,
                    logger_deployment_year = NULL,
                    logger_deployment_date_between = NULL,
                    deployment_logger_status = NULL,
                    logger_retrieval_year = NULL,
                    logger_retrieval_date_between = NULL,
                    retrieval_logger_status = NULL,
                    logger_shutdown_date_between = NULL,
                    download_type = NULL,
                    has_positions = NULL,
                    has_irma = NULL,
                    embargoed = FALSE,
                    as_tibble = FALSE
                )
            }
        )

        observeEvent(list(session_filters$filters(), connected()), {
            if (connected()) {
                session_info(do.call(getSessionInfo, session_filters$filters()))
            }
        })

        # Show sessions
        session_display <- session_server("session_display", session_info)
        encounter_display <- encounter_server("encounter_display", connected, session_info)
        position_display <- position_server("position_display", connected, session_info)

        # Show position data
        # Show individual statuses (new view to do the joins to get a session_id)
    })
}
