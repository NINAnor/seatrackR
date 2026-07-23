# UI to select various filters
query_ui <- function(id) {
    ns <- NS(id)
    card(
        id = ns("button_container_card"),
        uiOutput(ns("button_container_output")),
        shinyjs::hidden(
            actionButton(ns("show_extra"), "More filters...", class = "btn-secondary btn-sm"),
            uiOutput(ns("extra_button_container_output"))
        ),
        actionButton(ns("clear_filters"), "Clear filters", class = "btn-danger btn-sm")
    )
}


# Should filter available options
# Should return a list that can be passed up and used in other functions
#
query_server <- function(id, source_data, choice_data = NULL, modal_selectors = list(), default_filters = function() {
                             list()
                         }) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
        reset_filters <- function() {
            filter_list(
                default_filters()
            )
        }

        update_filter_list <- function(new_val, new_key) {
            old_list <- filter_list()
            old_list[[new_key]] <- new_val
            filter_list(old_list)
        }

        generate_ui <- function() {
            all_ui_list <- lapply(seq_along(modal_selectors), function(i) {
                modal_selector <- modal_selectors[[i]]

                filter_name <- modal_selector$name
                if (is.null(modal_selector$button_name)) {
                    button_name <- gsub(
                        "_", " ",
                        gsub("^([a-z])", "\\U\\1", filter_name, perl = TRUE)
                    )
                } else {
                    button_name <- modal_selector$button_name
                }

                selector_id <- paste0(filter_name, "_selector")
                return(input_modal_ui(session$ns(selector_id), button_name))
            })

            ui_list <- list()
            extra_ui_list <- list()
            for (i in seq_along(modal_selectors)) {
                modal_selector <- modal_selectors[[i]]
                ui_element <- all_ui_list[i]
                if (!is.null(modal_selector$extra) && modal_selector$extra) {
                    extra_ui_list <- c(extra_ui_list, ui_element)
                } else {
                    ui_list <- c(ui_list, ui_element)
                }
            }
            if (length(extra_ui_list) > 0) {
                shinyjs::showElement(id = "show_extra", anim = FALSE)
            }

            lapply(seq_along(modal_selectors), function(i) {
                modal_selector <- modal_selectors[[i]]
                filter_name <- modal_selector$name
                selector_id <- paste0(filter_name, "_selector")
                type <- modal_selector$type %||% "checkbox"
                if (is.null(modal_selector$var_name)) {
                    var_name <- filter_name
                } else {
                    var_name <- modal_selector$var_name
                }

                if (is.null(modal_selector$button_name)) {
                    name_string <- gsub("_", " ", filter_name, perl = TRUE)
                } else {
                    name_string <- tolower(modal_selector$button_name)
                }

                if (is.null(modal_selector$label)) {
                    label_string <- name_string
                } else {
                    label_string <- modal_selector$label
                }

                if (is.null(modal_selector$choice_function)) {
                    get_vals_from_db <- function() {
                        vals <- source_data() %>%
                            dplyr::distinct(
                                pick(var_name)
                            ) %>%
                            pull() %>%
                            as.list()
                        names(vals) <- vals
                        return(vals)
                    }
                } else {
                    get_vals_from_db <- modal_selector$choice_function
                }

                adapter <-
                    switch(type,
                        checkbox =
                            checkbox_modal_input(
                                choices = get_vals_from_db,
                                selected = function() filter_list()[[filter_name]]
                            ),
                        date_range =
                            date_range_modal_input(
                                start = function() {
                                    if (is.null(filter_list()[[filter_name]])) {
                                        db_min <- min(source_data() %>% pull(var_name), na.rm = TRUE)
                                        if (is.infinite(db_min)) {
                                            db_min <- as.Date("2000-01-01")
                                        }
                                        return(db_min)
                                    }
                                    return(filter_list()[[filter_name]][1])
                                },
                                end = function() {
                                    if (is.null(filter_list()[[filter_name]])) {
                                        db_max <- max(source_data() %>% pull(var_name), na.rm = TRUE)
                                        if (is.infinite(db_max)) {
                                            db_max <- NULL
                                        }
                                        return(db_max)
                                    }
                                    return(filter_list()[[filter_name]][2])
                                }
                            ),
                        binary =
                            binary_modal_input(
                                label = label_string,
                                value = function() filter_list()[[filter_name]]
                            ),
                        text = search_input(
                            value = function() filter_list()[[filter_name]]
                        )
                    )

                input_modal_server(
                    id = selector_id,
                    modal_title = paste("Filter", name_string),
                    input_adapter = adapter,
                    on_close = function(choices) {
                        update_filter_list(choices, filter_name)
                    }, reset_signal = reset_signal
                )
            })

            output$button_container_output <- renderUI({
                do.call(layout_column_wrap, ui_list)
            })
            if (length(extra_ui_list) > 0) {
                output$extra_button_container_output <- renderUI({
                    do.call(layout_column_wrap, extra_ui_list)
                })
            }
        }

        filter_list <- reactiveVal(default_filters())
        reset_signal <- reactiveVal(FALSE)

        reset_filters()
        server_list <- generate_ui()


        observeEvent(input$clear_filters, {
            reset_filters()
            reset_signal(TRUE)
        })

        extras_shown <- reactiveVal(FALSE)
        observeEvent(input$show_extra, {
            shinyjs::toggleElement(id = "extra_button_container_output", anim = FALSE)
            updateActionButton(inputId = "show_extra", label = ifelse(extras_shown(), "Show more filters", "Hide extra filters"))
            extras_shown(!extras_shown())
        })


        observeEvent(reset_signal(), {
            if (reset_signal()) {
                reset_signal(FALSE)
            }
        })

        return(list(filters = reactive(filter_list())))
    })
}
