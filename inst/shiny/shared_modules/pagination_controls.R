pagination_controls_ui <- function(id) {
    ns <- NS(id)

    div(
        class = "pagination-controls d-flex align-items-end",
        div(
            class = "ms-2 me-3",
            selectInput(
                ns("page_size"),
                "Rows per page",
                choices = c(25, 50, 100, 250, 500, 1000, 2000, 5000),
                selected = 50,
                width = "90px"
            )
        ),
        div(
            class = "d-flex gap-2 mb-2 ms-auto",
            actionButton(
                ns("prev_button"),
                "<< Previous"
            ),
            actionButton(
                ns("next_button"),
                "Next >>"
            )
        ),
        div(
            class = "ms-auto mb-2 me-2",
            textOutput(
                ns("status"),
                inline = TRUE
            )
        )
    )
}

pagination_controls_server <- function(id, paged, status = NULL) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$next_button, {
            if (!paged$loading()) {
                paged$pagination$next_page()
            }
        })

        observeEvent(input$prev_button, {
            if (!paged$loading()) {
                paged$pagination$previous_page()
            }
        })

        observeEvent(input$page_size, {
            paged$pagination$set_page_size(input$page_size)
        })

        output$status <- renderText({
            if (is.null(status)) {
                if (paged$pagination$has_next()) {
                    glue::glue("Page {paged$pagination$page()}+")
                } else {
                    glue::glue("Page {paged$pagination$page()} (last page)")
                }
            } else {
                status()
            }
        })

        observe({
            loading <- paged$loading()

            shinyjs::toggleState(
                "next_button",
                paged$pagination$has_next() && !loading
            )

            shinyjs::toggleState(
                "prev_button",
                paged$pagination$page() > 1 && !loading
            )

            shinyjs::toggleState(
                "page_size",
                !loading
            )
        })
    })
}
