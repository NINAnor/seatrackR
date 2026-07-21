table_display_ui <- function(id) {
    ns <- NS(id)

    tagList(
        div(
            id = ns("table_header"),
            class = "table-header",
            fluidRow(
                column(
                    4,
                    selectInput(
                        ns("page_size"),
                        "Rows per page",
                        choices = c(25, 50, 100, 250, 500),
                        selected = 50
                    )
                ),
                column(
                    8,
                    div(
                        style = "margin-top:25px",
                        actionButton(ns("prev_button"), "<< Previous"),
                        actionButton(ns("next_button"), "Next >>"),
                        textOutput(ns("status"), inline = TRUE)
                    )
                )
            ),
            div(
                id = ns("table_scroll_top"),
                class = "table-scroll-top",
                div(class = "table-scroll-top-inner")
            )
        ),
        div(
            id = ns("table_container"),
            DT::DTOutput(ns("table"))
        ),
        tags$head(
            tags$style(HTML("
                .table-header {
                    position: sticky;
                    top: 0;
                    z-index: 100;
                    background: inherit;
                    padding-bottom: 5px;
                    padding-top: 16px;
                }

                .table-scroll-top {
                    overflow-x: auto;
                    overflow-y: hidden;
                    height: 16px;
                }

                .table-scroll-top-inner {
                    height: 1px;
                }

                #table_container {
                    overflow: hidden;
                }
            "))
        )
    )
}

table_display_server <- function(id, query, order_by = NULL) {
    moduleServer(id, function(input, output, session) {
        page <- reactiveVal(1)

        n_rows <- reactive({
            q <- query()

            if (is.null(q)) {
                return(0)
            }

            q %>%
                summarise(n = n()) %>%
                collect() %>%
                pull(n)
        })

        observeEvent(query(), {
            page(1)
        })

        observeEvent(input$next_button, {
            max_page <- ceiling(n_rows() / as.numeric(input$page_size))

            if (page() < max_page) {
                page(page() + 1)
            }
        })

        observeEvent(input$prev_button, {
            if (page() > 1) {
                page(page() - 1)
            }
        })


        current_data <- reactive({
            q <- query()
            if (is.null(q)) {
                return(data.frame())
            }

            start <- (page() - 1) * as.numeric(input$page_size)
            offset <- (page() - 1) * as.numeric(input$page_size)
            sql <- dbplyr::sql_render(q)

            sql <- glue::glue("{sql} ORDER BY {ifelse(!is.null(order_by), order_by, colnames(q[1]))} LIMIT {input$page_size} OFFSET {offset}")

            dbGetQuery(con, sql)
        })

        output$table <- DT::renderDT({
            data <- current_data()

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
                current_data(),
                rownames = FALSE,
                style = "auto",
                options = list(
                    scrollX = TRUE,
                    scrollY = "60vh",
                    scrollCOllapse = TRUE,
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

        resizeTopScrollbar();

        top.on('scroll', function() {
            body.scrollLeft(top.scrollLeft());
        });

        body.on('scroll', function() {
            top.scrollLeft(body.scrollLeft());
        });

    });
        ",
                    session$ns("table"),
                    session$ns("table_scroll_top")
                ))
            )
        })

        output$status <- renderText({
            glue::glue(
                "Page {page()} of {ceiling(n_rows() / as.numeric(input$page_size))} ({n_rows()} rows)",
            )
        })

        return(list(
            data = current_data,
            page = page,
            n_rows = n_rows
        ))
    })
}
