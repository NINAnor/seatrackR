#' Get responsible species and colony
#'
#' @param session Optional vector of session IDs to filter by.
#' @param species Optional vector of species names to filter by.
#' @param colony Optional vector of colony names to filter by.
#' @param by_year Logical indicating whether to group results by year. Default is TRUE.
#' @param return_string Logical indicating whether to return responsible as a formatted string. Default is TRUE.
#' @return A data frame with species, colony, and distinct responsible persons.
#' @export
#' @concept metadata
get_responsible <- function(session = NULL, species = NULL, colony = NULL, by_year = TRUE, return_string = TRUE) {
    # ensure args are vectors

    if (!is.null(species) && !is.vector(species)) species <- c(species)
    if (!is.null(colony) && !is.vector(colony)) colony <- c(colony)
    if (!is.null(session) && !is.vector(session)) session <- c(session)

    if (length(species) == 0) species <- NULL
    if (length(colony) == 0) colony <- NULL
    if (length(session) == 0) session <- NULL

    arg_list <- list(
        species = species,
        colony = colony,
        session = session
    )

    if (check_db_version() >= 50) {
        sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))
        for (i in seq_along(arg_list)) {
            val_name <- names(arg_list)[i]
            value <- arg_list[[i]]
            if (!is.null(value)) {
                sessions <- dplyr::filter(sessions, !!rlang::sym(val_name) %in% value)
            }
        }
        people <- dplyr::tbl(con, dbplyr::in_schema("metadata", "people"))
        statuses <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_status"))
        deployments <- dplyr::tbl(con, dbplyr::in_schema("loggers", "deployment"))
        retrievals <- dplyr::tbl(con, dbplyr::in_schema("loggers", "retrieval"))

        deployments <- dplyr::left_join(sessions, deployments, by = "session_id", suffix = c("_session", "_deployment"))
        deployment_status <- dplyr::semi_join(statuses, deployments, by = "status_id")

        retrievals <- dplyr::left_join(sessions, retrievals, by = "session_id", suffix = c("_session", "_retrieval"))
        retrieval_status <- dplyr::semi_join(statuses, retrievals, by = "status_id")

        all_status <- dplyr::rows_append(deployment_status, retrieval_status)

        status_people <- dplyr::tbl(con, dbplyr::in_schema("individuals", "status_people"))
        all_status <- dplyr::left_join(all_status, status_people, by = dplyr::join_by(id == status_id)) %>%
            dplyr::left_join(
                people,
                by = "person_id"
            )

        people_summary <- dplyr::select(all_status, location, species, status_date, full_name, affiliation, email, person_order)
        if (by_year) {
            people_summary <- dplyr::mutate(people_summary, year = lubridate::year(status_date), .before = full_name) %>%
                dplyr::arrange(location, species, year, person_order)
        } else {
            people_summary <- dplyr::arrange(people_summary, location, species, person_order)
        }
        people_summary <- dplyr::select(people_summary, -status_date) %>%
            dplyr::distinct() %>%
            dplyr::collect()

        if (return_string) {
            people_summary <- dplyr::group_by(people_summary, location, species)
            if (by_year) {
                people_summary <- dplyr::group_by(people_summary, year, .add = TRUE)
            }
            people_lists <- dplyr::summarise(people_summary, people_list = list(unique(full_name)), .groups = "keep")

            string_func <- function(x) {
                x <- x[[1]]
                if (length(x) == 1) {
                    return(x[1])
                }
                paste(c(paste(x[seq_len(length(x) - 1)], collapse = ", "), x[length(x)]), collapse = " and ")
            }

            people_summary <- dplyr::mutate(people_lists, people_string = string_func(people_list)) %>% dplyr::select(-people_list)
        }

        return(people_summary)
    }

    # Optionally ignore year?
    # Optionally collapse to string

    db_arg_list <- lapply(names(arg_list), function(arg_name) {
        arg_value <- arg_list[[arg_name]]
        if (!is.null(arg_value)) {
            return(R_vector_to_db_values(arg_value))
        }
    })
    names(db_arg_list) <- c("species", "location", "session_id")
    where_statement <- lapply(names(db_arg_list), function(arg_name) {
        arg_value <- db_arg_list[[arg_name]]
        if (!is.null(arg_value)) {
            return(arg_list[[arg_name]] <<- glue::glue("indstatus.{arg_name} IN ({arg_value})"))
        }
    })
    where_statement <- paste(where_statement[!sapply(where_statement, is.null)], collapse = " AND ")

    query <- glue::glue("
    SELECT
        indstatus.species,
        indstatus.location,
        ARRAY_AGG(DISTINCT elem ORDER BY elem) AS distinct_responsible
    FROM individuals.individ_status indstatus,
        unnest(STRING_TO_ARRAY(indstatus.data_responsible, '_')) AS elem
    WHERE
        {where_statement}
    GROUP BY indstatus.species, indstatus.location;
    ")

    res <- DBI::dbGetQuery(
        con,
        query
    )
    for (i in seq_len(nrow(res))) {
        res$distinct_responsible[i] <- gsub("\"", "", res$distinct_responsible[i])
        res$distinct_responsible[i] <- gsub("[{}]", "", res$distinct_responsible[i])
    }

    res$distinct_responsible <- strsplit(res$distinct_responsible, ",")
    if (return_string) {
        res$distinct_responsible <- sapply(res$distinct_responsible, function(x) {
            if (length(x) == 1) {
                return(x[1])
            }
            paste(c(paste(x[seq_len(length(x) - 1)], collapse = ", "), x[length(x)]), collapse = " and ")
        })
    }

    return(res)
}
