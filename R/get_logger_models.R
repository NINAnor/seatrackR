#' Get logger models
#'
#' This function retrieves logger model information from the "metadata.logger_models" table. Optionally, it can filter the results based on specified producers.
#' @param producers Optional vector of character strings representing logger producers to filter the results by.
#' @return A tibble containing logger model information, optionally filtered by producers.
#' @export
#' @concept metadata
getLoggerModels <- function(producers = NULL) {
    logger_models <- dplyr::tbl(con, dbplyr::in_schema("metadata", "logger_models"))
    if (!is.null(producers)) {
        logger_models <- dplyr::filter(logger_models, producer %in% producers)
    }
    return(tibble::as_tibble(logger_models))
}
