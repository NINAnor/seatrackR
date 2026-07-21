encounter_ui <- function(id) {
    ns <- NS(id)
    tagList(
        card(
            id = ns("button_container_card"),
            uiOutput(ns("button_container_output")),
            actionButton(ns("clear_filters"), "Clear filters", class = "btn-danger btn-sm")
        ),
        table_display_ui(ns("data_display"))
    )
}

encounter_server <- function(id, connected, session_info) {
    moduleServer(id, function(input, output, session) {
        apply_filter <- function() {
            if (connected() && !is.null(filter_list())) {
                print("Applying filter")
                individual_info(do.call(getIndividInfo, filter_list()))
            }
        }

        reset_filters <- function(new_session_ids = c()) {
            filter_list(
                list(
                    session_id = new_session_ids,
                    as_tibble = FALSE,
                    event_type = NULL,
                    last_only = FALSE
                )
            )
        }


        update_filter_list <- function(new_val, new_key) {
            old_list <- filter_list()
            old_list[[new_key]] <- new_val
            filter_list(old_list)
        }

        observeEvent(session_info(), {
            if (!is.null(session_info)) {
                sessions <- session_info() %>%
                    dplyr::distinct(
                        session_id
                    ) %>%
                    pull()
                session_ids(sessions)
            }
        })

        observeEvent(session_ids(), {
            update_filter_list(session_ids(), "session_id")
        })

        generate_ui <- function() {
            modal_selectors <- list(
                list(name = "event_type", var_name = "eventType"),
                list(
                    name = "last_only",
                    button_name = "Last status only?",
                    label = "Only show last recorded status.",
                    type = "binary"
                )
            )


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
                        vals <- individual_info() %>%
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
                                        return(min(session_info() %>% pull(var_name), na.rm = TRUE))
                                    }
                                    return(filter_list()[[filter_name]][1])
                                },
                                end = function() {
                                    if (is.null(filter_list()[[filter_name]])) {
                                        return(max(session_info() %>% pull(var_name), na.rm = TRUE))
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
                    },
                    reset_signal <- reset_signal
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


        observeEvent(filter_list(), {
            apply_filter()
        })

        observeEvent(input$clear_filters, {
            print("Reset all filters")
            reset_filters(session_ids())
            reset_signal(TRUE)
        })

        observeEvent(reset_signal(), {
            if (reset_signal()) {
                reset_signal(FALSE)
            }
        })

        session_ids <- reactiveVal(c())
        filter_list <- reactiveVal(NULL)
        reset_signal <- reactiveVal(FALSE)
        individual_info <- reactiveVal(NULL)

        reset_filters()
        server_list <- generate_ui()
        table_display <- table_display_server("data_display", individual_info,
            order_by = "status_date"
        )

        observeEvent(table_display, {
            print(table_display)
        })
    })
}
