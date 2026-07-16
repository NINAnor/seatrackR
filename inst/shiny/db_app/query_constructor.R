# UI to select various filters
query_ui <- function(id) {
    ns <- NS(id)
    card(
        uiOutput(ns("button_container_output")),
        actionButton(ns("clear_filters"), "Clear filters", class ="btn-danger btn-sm"),
        
        id = ns("button_container_card")
        
    )
}


# Should filter available options
# Should return a list that can be passed up and used in other functions
#
query_server <- function(id, connected, session_info) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
        apply_filter <- function() {
            if (connected() && !is.null(filter_list())) {
                print("Applying filter")
                session_info(do.call(getSessionInfo, filter_list()))
                #print(dbplyr::sql_render(session_info()))
            }
        }

        reset_filters <- function() {
            filter_list(
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
            )
        }

        update_filter_list <- function(new_val, new_key) {
            old_list <- filter_list()
            old_list[[new_key]] <- new_val
            filter_list(old_list)
        }

        generate_ui <- function() {
            ui_list <- list()


            modal_selectors <- list(
                list(name = "colony"), 
                list(name = "species"), 
                list(name = "sex"),
                list(name = "deployment_age_class", button_name = "Deployment age",  choice_function = c(Chick = "C", Adult = "A")), 
                list(name = "logger_type"),
                list(name = "logger_model"),
                list(name = "project"),
                list(name = "has_positions"),
                list(name = "has_irma")
            )

            # list(name = "logger_model"),
            # list(name = "sexing_method"),

            ui_list <- lapply(seq_along(modal_selectors), function(i) 
            {
                modal_selector <- modal_selectors[[i]]
                
                var_name <- modal_selector$name
                if(is.null(modal_selector$button_name)){
                    button_name <- gsub("_", " ",
                        gsub("^([a-z])", "\\U\\1", var_name, perl = TRUE))
                }else{
                    button_name <- modal_selector$button_name
                }
                
                selector_id <- paste0(var_name, "_selector")
                return(selector_modal_ui(session$ns(selector_id), button_name))
            })

            lapply(seq_along(modal_selectors), function(i) {
                modal_selector <- modal_selectors[[i]]
                var_name <- modal_selector$name

                selector_id <- paste0(var_name, "_selector")

                if(is.null(modal_selector$button_name)){
                    name_string <- gsub("_", " ", var_name, perl = TRUE)
                }else{
                    name_string <- tolower(modal_selector$button_name)
                }
                
                if(is.null(modal_selector$choice_function)){
                get_vals_from_db <- function() {
                        
                        vals <- session_info() %>%
                            dplyr::distinct(
                                pick(var_name)
                            ) %>%
                            pull() %>%
                            as.list()
                        names(vals) <- vals
                        return(vals)
                    }
                }else{
                    get_vals_from_db <- modal_selector$choice_function
                }


                selector_modal_server(
                    id = selector_id,
                    modal_title = paste("Filter", name_string),
                    modal_choices = get_vals_from_db,
                    modal_selected = function() {
                        filter_list()[[var_name]]
                    },
                    on_close = function(choices) {
                        print(choices)
                        update_filter_list(choices, var_name)
                    },
                    reset_signal
                )
            })

            # Add activatable year range for deployment
            # Add activatable year range for retrieval

            ui_list <- c(ui_list, list(optional_date_selector(session$ns(("test_date")))))
            test <- optional_date_selector_server("test_date")

            output$button_container_output <- renderUI({
                do.call(layout_column_wrap, ui_list)
            })
        }

        filter_list <- reactiveVal(NULL)
        reset_signal <- reactiveVal(FALSE)

        reset_filters()
        server_list <- generate_ui()

        observeEvent(connected(), {
            if (connected() && is.null(session_info())) {
                apply_filter()
            }
        })


        observeEvent(filter_list(), {
            apply_filter()
        })

        observe({
            print("Reset all filters")
            reset_filters()
            reset_signal(TRUE)
            
        }) |>
            bindEvent(input$clear_filters)


        observeEvent(reset_signal(),{
            if(reset_signal()){
                reset_signal(FALSE)
            }
        })

        observeEvent(input$button, {

    })
    })
}
