estimate_query_size <- function(query, con, memory_multiplier = 2) {
    sql <- dbplyr::sql_render(query)

    explain_sql <- paste(
        "EXPLAIN (FORMAT JSON, COSTS FALSE)",
        sql
    )

    plan <- DBI::dbGetQuery(
        con,
        explain_sql
    )[[1]]

    # PostgreSQL returns JSON as a string
    plan <- jsonlite::fromJSON(plan)

    root <- plan[[1]]$Plan

    rows <- root$`Plan Rows`
    width <- root$`Plan Width`

    if (is.null(rows) || is.null(width)) {
        return(NULL)
    }

    estimated_bytes <- rows * width

    list(
        rows = rows,
        database_bytes = estimated_bytes,
        estimated_mb = estimated_bytes * memory_multiplier / 1024^2,
        plan = plan
    )
}

export_data_ui <- function(id) {
    ns <- NS(id)

    tagList(
        downloadButton(
            ns("download"),
            "Export data"
        )
    )
}


export_data_server <- function(id, query_reactive, con, default_filename = "export.csv", max_mb = 500) {
    moduleServer(id, function(input, output, session) {
        output$download <- downloadHandler(
            filename = function() {
                default_filename
            },
            content = function(file) {
                query <- query_reactive()

                estimate <- estimate_query_size(query, con)

                if (!is.null(estimate) &&
                    estimate$estimated_mb > max_mb) {
                    stop(
                        sprintf(
                            "Export estimated at %.1f MB, exceeding the %.1f MB limit.",
                            estimate$estimated_mb,
                            max_mb
                        )
                    )
                }

                query |>
                    dplyr::collect() |>
                    readr::write_csv(file)
            }
        )
    })
}
