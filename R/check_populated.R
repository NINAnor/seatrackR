check_populated <- function(view_name) {
    splitname <- strsplit(view_name, ".", fixed = TRUE)[[1]]

    is_populated <- dbGetQuery(
        con,
        glue::glue("
    SELECT ispopulated
    FROM pg_matviews
    WHERE schemaname = '{splitname[1]}'
        AND matviewname = '{splitname[2]}'
    ")
    )$ispopulated

    if (!is_populated) {
        dbExecute(con, glue::glue("REFRESH MATERIALIZED VIEW {view_name}"))
    }
}
