#' Get responsible species and colony
#'
#' @param session Optional vector of session IDs to filter by.
#' @param species Optional vector of species names to filter by.
#' @param colony Optional vector of colony names to filter by.
#' @param return_string Logical indicating whether to return responsible as a formatted string. Default is TRUE.
#' @return A data frame with species, colony, and distinct responsible persons.
#' @export
#' @concept metadata
get_responsible <- function(session = NULL, species = NULL, colony = NULL, return_string = TRUE) {
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
