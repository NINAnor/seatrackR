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
        busy <- reactiveVal(FALSE)

        connected <- reactiveVal(FALSE)
        session_info <- reactiveVal(NULL)

        observeEvent(connected(), {
            if (connected()) {
                shinyjs::showElement("main_screen")
                shinyjs::hideElement("splash_screen")
            }
        })
        observeEvent(session_info(), {
            if (!is.null(session_info())) {
                print(head(session_info()))
            }
        })

        connect_db <- connect_db_server("connect_db", busy, getShinyOption("test", FALSE),
            on_success = function() {
                print("Succesfully connected")
                connected(TRUE)
            }, on_fail = function(e) {
                show_error_modal(session, e)
            }
        )
        shinyjs::addClass("connect_db-login", "btn-lg")
        query_constructor <- query_server("query_constructor", connected, session_info)
    })
}
