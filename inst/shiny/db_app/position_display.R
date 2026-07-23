position_ui <- function(id) {
    ns <- NS(id)
    tagList(
        card(selectizeInput(ns("location_type"), label = "Position type", choices = c("GLS", "IRMA", "GPS", "GPS-GSM"))),
        navset_tab(
            id = ns("navbar"),
            nav_panel(title = "Table", table_display_ui(ns("table"))),
            nav_panel(title = "Map", tagList(
                pagination_controls_ui(ns("pagination")),
                map_display_ui(ns("map"))
            )),
            nav_panel(title = "Export", export_data_ui(ns("export")))
        ),
        tags$head(
            tags$style(".card{overflow: visible !important;}"),
            tags$style(".card-body{overflow: visible !important;}")
        )
    )
}

position_server <- function(id, connected, session_info) {
    moduleServer(id, function(input, output, session) {
        # UI modification
        shinyjs::addClass(id = "navbar", class = "nav-fill")

        # Reactive values
        force_render <- reactiveVal(FALSE)
        locations <- reactiveVal(NULL)
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

        observeEvent(list(session_ids(), input$location_type, connected()), {
            if (connected()) {
                filter_list <- list()
                filter_list$sessionId <- session_ids()
                filter_list$asTibble <- FALSE
                filter_list$datatype <- input$location_type
                locations(do.call(getPositions, filter_list))
            }
        })

        observeEvent(input$navbar, {
            if (input$navbar == "Map" && !force_render()) {
                force_render(TRUE)
            }
        })

        paged <- paginated_query_server(
            "paged",
            query = locations,
            order_by = NULL
        )


        table_display_server(
            "table",
            paged = paged
        )

        export_data_server("export", session_info, con, "position_export.csv")

        pagination_controls_server("pagination", paged)


        map_display_server("map",
            paged = paged,
            coord_fn = function(data) {
                data$x <- data$lon
                data$y <- data$lat
                data$identifier <- data$session_id
                return(data)
            },
            render_fn = default_line_renderer,
            force_render = force_render
        )
    })
}
