paginated_query_server <- function(id, query, order_by = NULL) {
    moduleServer(id, function(input, output, session) {
        get_empty_result <- function() {
            df <- data.frame()
            attr(df, "has_next") <- FALSE
            return(df)
        }

        data <- reactiveVal(get_empty_result())
        loading <- reactiveVal(TRUE)
        page <- reactiveVal(1)
        request_id <- reactiveVal(0)
        page_size <- reactiveVal(50)


        observeEvent(query(), {
            page(1)
        })


        set_page_size <- function(x) {
            page_size(as.numeric(x))
            page(1)
        }

        set_page <- function(page_number) {
            page(max(1L, as.integer(page_number)))
        }


        next_page <- function() {
            if (has_next()) {
                page(page() + 1)
            }
        }


        previous_page <- function() {
            if (page() > 1) {
                page(page() - 1)
            }
        }


        offset <- reactive({
            (page() - 1) * page_size()
        })

        has_next <- reactive(
            isTRUE(attr(data(), "has_next"))
        )


        observeEvent(
            list(query(), page(), page_size()),
            {
                loading(TRUE)
                id <- request_id() + 1
                request_id(id)

                q <- query()

                if (is.null(q)) {
                    data(get_empty_result())
                    return()
                }

                sql <- dbplyr::sql_render(q)

                if (!is.null(order_by)) {
                    sql <- glue::glue(
                        "{sql}
                ORDER BY {order_by}"
                    )
                }

                sql <- glue::glue(
                    "{sql}
            LIMIT {page_size() + 1}
            OFFSET {offset()}"
                )
                sql <- as.character(sql)
                existing_con_info <- DBI::dbGetInfo(con)
                future(
                    {
                        future_con <- DBI::dbConnect(RPostgres::Postgres(),
                            host = existing_con_info$host, ,
                            dbname = existing_con_info$dbname,
                            user = Sys.getenv("SEATRACK_DB_USER", NA),
                            password = Sys.getenv("SEATRACK_DB_PWD", NA),
                        )

                        on.exit(DBI::dbDisconnect(future_con), add = TRUE)

                        DBI::dbGetQuery(future_con, sql)
                    },
                    packages = c("DBI", "RPostgres")
                ) %...>% (function(x) {
                    if (id != request_id()) {
                        return(NULL)
                    }

                    has_next <- nrow(x) > page_size()

                    if (has_next) {
                        x <- x[seq_len(page_size()), , drop = FALSE]
                    }

                    attr(x, "has_next") <- has_next

                    loading(FALSE)
                    data(x)
                }) %...!% (function(e) {
                    warning("Query failed: ", conditionMessage(e))
                    data(get_empty_result())
                    loading(FALSE)
                })
            },
            ignoreInit = FALSE
        )

        list(
            data = data,
            loading = loading,
            pagination = list(
                page = reactive(page()),
                page_size = page_size,
                has_next = has_next,
                offset = offset,
                next_page = next_page,
                previous_page = previous_page,
                set_page = set_page,
                set_page_size = set_page_size
            )
        )
    })
}
