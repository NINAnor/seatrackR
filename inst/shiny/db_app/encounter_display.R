encounter_ui <- function(id) {
    ns <- NS(id)
    tagList(
        query_ui(ns("query_constructor")),
        navset_tab(
            id = ns("navbar"),
            nav_panel(title = "Table", table_display_ui(ns("table"))),
            nav_panel(title = "Map", tagList(
                pagination_controls_ui(ns("pagination")),
                map_display_ui(ns("map"))
            )),
            nav_panel(title = "Export", export_data_ui(ns("export")))
        )
    )
}

encounter_server <- function(id, connected, session_info) {
    moduleServer(id, function(input, output, session) {
        # UI modification
        shinyjs::addClass(id = "navbar", class = "nav-fill")

        # Reactive values
        force_render <- reactiveVal(FALSE)
        individual_info <- reactiveVal(NULL)
        session_ids <- reactiveVal(c())

        # Static variables


        # Event observers
        observeEvent(session_info(), {
            if (!is.null(session_info())) {
                sessions <- session_info() %>%
                    dplyr::distinct(session_id) %>%
                    pull()
                session_ids(sessions)
            }
        })

        observeEvent(list(session_ids(), individual_filters$filters(), connected()), {
            if (connected()) {
                filter_list <- individual_filters$filters()
                filter_list$session_id <- session_ids()
                filter_list$as_tibble <- FALSE
                individual_info(do.call(getIndividInfo, filter_list))
            }
        })

        observeEvent(input$navbar, {
            if (input$navbar == "Map" && !force_render()) {
                force_render(TRUE)
            }
        })

        # Servers
        individual_filters <- query_server(
            "query_constructor",
            source_data = individual_info,
            modal_selectors = list(
                list(
                    name = "event_type",
                    var_name = "eventType"
                ),
                list(
                    name = "last_only",
                    button_name = "Last status only?",
                    label = "Only show last recorded status.",
                    type = "binary"
                )
            ),
            default_filters = function() {
                list(
                    event_type = NULL,
                    last_only = FALSE,
                    as_tibble = FALSE
                )
            }
        )

        paged <- paginated_query_server(
            "paged",
            query = individual_info,
            order_by = "status_date"
        )


        table_display_server(
            "table",
            paged = paged
        )

        export_data_server("export", session_info, con, "encounter_export.csv")
        pagination_controls_server("pagination", paged)


        map_display_server("map",
            paged = paged, coord_fn = function(data) {
                all_locations <- getColonies(allLocations = TRUE)
                data <- dplyr::group_by(data, colony) %>% dplyr::summarise(value = n())
                data <- left_join(data,
                    select(all_locations, location_name, x = lon, y = lat),
                    by = dplyr::join_by(colony == location_name)
                )

                return(data)
            },
            render_fn = heatmap_renderer,
            force_render = force_render
        )
    })
}
