connect_db_ui <- function(id) {
    ns <- NS(id)

    actionButton(ns("login"), "Login to database")
}

connect_db_server <- function(id, busy = reactiveVal(FALSE), test = FALSE, on_busy = function(is_busy) {}, on_success = function() {}, on_fail = function(exception) {}, app_settings = reactiveVal(list())) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
        observeEvent(busy(), {
            on_busy(busy())
        })

        # app_settings_list <- app_settings()
        # input$username <- ifelse(!is.null(app_settings_list$db_username), app_settings_list$db_username, "")

        observe({
            app_settings_list <- app_settings()
            loaded_username <- ifelse(!is.null(app_settings_list$db_username), app_settings_list$db_username, "")
            showModal(
                modalDialog(
                    textInput(session$ns("username"), "Username:", value = loaded_username),
                    passwordInput(session$ns("password"), "Password:"),
                    br(),
                    layout_columns(
                        actionButton(session$ns("cancel"), "Cancel"),
                        actionButton(session$ns("connect"), "Connect"),
                        class = "m-0"
                    ),
                    title = NULL,
                    easyClose = FALSE,
                    footer = NULL,
                    fade = FALSE
                )
            )
        }) |>
            bindEvent(input$login)

        observe({
            removeModal()
        }) |>
            bindEvent(input$cancel)


        observe({
            tryCatch(
                {
                    app_settings_list <- app_settings()
                    app_settings_list$db_username <- input$username
                    app_settings(app_settings_list)
                    if (!test) {
                        seatrackR::connectSeatrack(input$username, input$password)
                    } else {
                        seatrackR::connectSeatrack(input$username, input$password, host = "localhost", "seatrack_test")
                    }
                    removeModal()

                    on_success()
                },
                error = function(e) {
                    on_fail(e)
                }
            )
        }) |>
            bindEvent(input$connect)
    })
}
