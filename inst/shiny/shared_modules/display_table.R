table_display_css <- function() {
    tags$head(
        tags$style(HTML("
            .table-header {
                position: sticky;
                top: 0;
                z-index: 100;
                background: inherit;
                padding-top: 16px;
                padding-bottom: 5px;
            }

            .table-scroll-top {
                overflow-x: auto;
                overflow-y: hidden;
                height: 16px;
            }

            .table-scroll-top-inner {
                height: 100%;
            }

            .table-container {
                overflow: hidden;
                position:relative
            }

            .table-loading-overlay {
                display: none;
                position: absolute;
                inset: 0;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }

            .table-loading-overlay.active {
                display: flex;
            }

            .table-loading-overlay .loading-text {
                background: rgba(255,255,255,0.85);
                padding: 10px 20px;
                border-radius: 5px;
            }
        "))
    )
}

table_display_ui <- function(id) {
    ns <- NS(id)

    tagList(
        div(
            id = ns("table_header"),
            class = "table-header",
            pagination_controls_ui(ns("pagination")),
            div(
                id = ns("table_scroll_top"),
                class = "table-scroll-top",
                div(class = "table-scroll-top-inner")
            )
        ),
        div(
            id = ns("table_container"),
            class = "table-container",
            div(
                id = ns("loading_overlay"),
                class = "table-loading-overlay",
                div(class = "loading-text", "Fetching data...")
            ),
            DT::DTOutput(ns("table"))
        ),
        table_display_css()
    )
}

table_display_server <- function(id, paged) {
    moduleServer(id, function(input, output, session) {
        pagination_controls_server("pagination", paged)

        output$table <- DT::renderDT({
            data <- paged$data()

            if (nrow(data) == 0) {
                return(
                    DT::datatable(
                        data.frame(Message = "No data available"),
                        options = list(
                            paging = FALSE,
                            searching = FALSE,
                            ordering = FALSE,
                            info = FALSE
                        )
                    )
                )
            }

            DT::datatable(
                data,
                rownames = FALSE,
                style = "auto",
                options = list(
                    scrollX = TRUE,
                    scrollY = "60vh",
                    scrollCollapse = TRUE,
                    autoWidth = TRUE,
                    paging = FALSE,
                    searching = FALSE,
                    ordering = FALSE,
                    info = FALSE,
                    columnDefs = list(
                        list(
                            targets = "_all",
                            render = DT::JS(
                                "function(data, type, row, meta) {",
                                "return type === 'display' && data != null && data.length > 30 ?",
                                "'<span title=\"' + data + '\">' + data.substr(0, 30) + '...</span>' : data;",
                                "}"
                            )
                        )
                    )
                ),
                callback = DT::JS(sprintf(
                    "
          table.on('init.dt', function() {

            var body = $('#%s .dataTables_scrollBody');
            var top = $('#%s');
            var inner = top.find('.table-scroll-top-inner');

            function resizeTopScrollbar() {
              inner.width(body[0].scrollWidth);
            }

            resizeTopScrollbar()

            top.on('scroll', function() {
                body.scrollLeft(top.scrollLeft())
            })

            body.on('scroll', function() {
                top.scrollLeft(body.scrollLeft())
            })

          });
          ",
                    session$ns("table"),
                    session$ns("table_scroll_top")
                ))
            )
        })

        output$status <- renderText({
            glue::glue(
                "Page {paged$pagination$page()} of {paged$pagination$page_count()} ({paged$pagination$n_rows()} rows)"
            )
        })

        observe({
            if (paged$loading()) {
                shinyjs::show("loading_overlay")
            } else {
                shinyjs::hide("loading_overlay")
            }
        })

    })
}
