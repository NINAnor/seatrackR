session_ui <- function(id) {
    ns <- NS(id)
    tagList(

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

session_server <- function(id, session_info) {
    moduleServer(id, function(input, output, session) {
        # UI modification
        shinyjs::addClass(id = "navbar", class = "nav-fill")

        force_render <- reactiveVal(FALSE)
        paged <- paginated_query_server(
            "paged",
            query = session_info,
            order_by <- NULL
        )

        observeEvent(input$navbar, {
            if (input$navbar == "Map" && !force_render()) {
                force_render(TRUE)
            }
        })


        table_display_server(
            "table",
            paged = paged
        )

        pagination_controls_server("pagination", paged)

        export_data_server("export", session_info, con, "session_export.csv")

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
