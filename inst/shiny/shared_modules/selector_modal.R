search_input <- function(value) {
    list(
        ui = function(session) {
            current_value <-
                if (is.function(value)) value() else value

            textInput(
                session$ns("modal_input"),
                label = NULL,
                value = ifelse(is.null(current_value), "", current_value),
                placeholder = "Search..."
            )
        },
        value = function(input) {
            if (input$modal_input != "") {
                return(input$modal_input)
            } else {
                return(NULL)
            }
        },
        reset = function(session) {
            updateTextInput(
                session,
                inputId = "modal_input",
                value = character(0)
            )
        }
    )
}

binary_modal_input <- function(value, label = NULL) {
    list(
        ui = function(session) {
            current_value <-
                if (is.function(value)) value() else value

            checkboxInput(
                session$ns("modal_input"),
                label = label,
                value = current_value,
            )
        },
        value = function(input) {
            input$modal_input
        },
        reset = function(session) {
            updateCheckboxInput(
                session,
                inputId = "modal_input",
                value = FALSE
            )
        }
    )
}

checkbox_modal_input <- function(choices, selected) {
    list(
        ui = function(session) {
            available_choices <-
                if (is.function(choices)) choices() else choices

            available_selected <-
                if (is.function(selected)) selected() else selected

            checkboxGroupInput(
                session$ns("modal_input"),
                label = NULL,
                choices = available_choices,
                selected = available_selected
            )
        },
        value = function(input) {
            input$modal_input
        },
        reset = function(session) {
            updateCheckboxGroupInput(
                session,
                "modal_input",
                selected = character(0)
            )
        }
    )
}

date_range_modal_input <- function(
  start = NULL,
  end = NULL,
  min = NULL,
  max = NULL
) {
    list(
        ui = function(session) {
            start_value <- if (is.function(start)) start() else start
            end_value <- if (is.function(end)) end() else end
            min_value <- if (is.function(min)) min() else min
            max_value <- if (is.function(max)) max() else max

            dateRangeInput(
                session$ns("modal_input"),
                label = NULL,
                start = start_value,
                end = end_value,
                min = min_value,
                max = max_value,
                width = "100%"
            )
        },
        value = function(input) {
            input$modal_input
        },
        reset = function(session) {
            start_value <- if (is.function(start)) start() else start
            end_value <- if (is.function(end)) end() else end

            updateDateRangeInput(
                session,
                "modal_input",
                start = NULL,
                end = NULL
            )
        }
    )
}

input_modal_ui <- function(id, button_label = "open filter") {
    ns <- NS(id)

    actionButton(ns("open_button"), button_label, class = "btn-sm")
}


input_modal_server <- function(id, input_adapter, on_close = function(chosen) {}, modal_title = "Filter", reset_signal = NULL) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
        close_and_select <- function(new_val) {
            if (!is.null(new_val)) {
                shinyjs::addClass(id = "open_button", "btn-primary")
            } else {
                shinyjs::removeClass(id = "open_button", "btn-primary")
            }
            on_close(new_val)
            removeModal()
        }

        input_reset <- function() {
            if (!is.null(input_adapter$reset)) {
                input_adapter$reset(session)
            }
        }

        # print(paste("Starting server", id))
        observeEvent(input$open_button, {
            showModal(
                modalDialog(
                    p(modal_title),
                    input_adapter$ui(session),
                    layout_columns(
                        actionButton(session$ns("clear"), "Clear",
                            class = "btn-danger"
                        )
                    ),
                    layout_columns(
                        actionButton(session$ns("cancel"), "Cancel"),
                        actionButton(session$ns("apply"), "Apply"),
                        class = "m-0"
                    ),
                    title = NULL,
                    footer = NULL,
                    easyClose = FALSE,
                    fade = FALSE
                )
            )
        })


        observeEvent(input$cancel, {
            removeModal()
        })

        observeEvent(input$apply, {
            close_and_select(input_adapter$value(input))
        })

        observeEvent(input$clear, {
            input_reset()
            close_and_select(NULL)
        })

        if (!is.null(reset_signal)) {
            observeEvent(reset_signal(), {
                if (reset_signal()) {
                    input_reset()
                    close_and_select(NULL)
                }
            })
        }
    })
}
