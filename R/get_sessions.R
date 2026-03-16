#' Retrieve logger session information
#'
#' This function retrieves information about logger sessions from the database, allowing for various filters to narrow down the results.
#' @param logger_ids Optional vector of character strings representing logger serial numbers to filter the sessions.
#' @param individ_ids Optional vector of character strings representing individual IDs to filter the sessions.
#' @param logger_deployment_year Optional vector of integers representing the years of logger deployment to filter the sessions.
#' @param logger_retrieval_year Optional vector of integers representing the years of logger retrieval to filter the sessions.
#' @param colony_names Optional vector of character strings representing colony names to filter the sessions.
#' @param species_names Optional vector of character strings representing species names to filter the sessions.
#' @param logger_year_tracked Optional vector of character strings representing the years tracked by the logger to filter the sessions.
#' @param logger_active Optional boolean to filter sessions based on whether the logger is currently active.
#' @param logger_deployed Optional boolean to filter sessions based on whether the logger has been deployed.
#' @param logger_retrieved Optional boolean to filter sessions based on whether the logger has been retrieved.
#' @param has_pos_data Optional boolean to filter sessions based on whether they have associated position data.
#' @param logger_download_type Optional vector of character strings representing the download types of the loggers to filter the sessions.
#' @param posdata_filename Optional vector of character strings representing position data filenames to filter the sessions (without extension).
#' @return A tibble containing the filtered logger session information.
#' @export
#' @concept logger_info
getSessionInfo <- function(
  logger_ids = NULL,
  individ_ids = NULL,
  logger_deployment_year = NULL,
  logger_retrieval_year = NULL,
  colony_names = NULL,
  species_names = NULL,
  logger_year_tracked = NULL,
  logger_active = NULL,
  logger_deployed = NULL,
  logger_retrieved = NULL,
  has_pos_data = NULL,
  logger_download_type = NULL,
  posdata_filename = NULL
) {
    sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))
    postable <- dplyr::tbl(con, dbplyr::in_schema("positions", "postable_raw"))
    pos_sessions <- dplyr::distinct(select(postable, session_id))
    pos_sessions <- dplyr::mutate(pos_sessions, pos_data = TRUE)
    sessions <- dplyr::left_join(sessions, pos_sessions, by = "session_id")
    sessions <- dplyr::mutate(sessions, pos_data = !is.na(pos_data))
    if (!is.null(has_pos_data)) {
        sessions <- dplyr::filter(sessions, pos_data == has_pos_data)
    }
    if (!is.null(logger_deployed)) {
        sessions <- dplyr::filter(sessions, !is.na(deployment_id) == logger_deployed)
    }
    if (!is.null(logger_retrieved)) {
        sessions <- dplyr::filter(sessions, !is.na(retrieval_id) == logger_retrieved)
    }
    if (!is.null(logger_active)) {
        sessions <- dplyr::filter(sessions, active == logger_active)
    }
    if (!is.null(individ_ids)) {
        sessions <- dplyr::filter(sessions, individ_id %in% individ_ids)
    }
    if (!is.null(colony_names)) {
        sessions <- dplyr::filter(sessions, colony %in% colony_names)
    }
    if (!is.null(species_names)) {
        sessions <- dplyr::filter(sessions, species %in% species_names)
    }
    if (!is.null(logger_year_tracked)) {
        sessions <- dplyr::filter(sessions, year_tracked %in% logger_year_tracked)
    }

    loggers <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logger_info"))
    sessions <- dplyr::left_join(sessions, dplyr::select(loggers, logger_id, logger_serial_no, logger_model), by = "logger_id")

    if (!is.null(logger_ids)) {
        sessions <- dplyr::filter(sessions, logger_serial_no %in% logger_ids)
    }

    deployments <- dplyr::tbl(con, dbplyr::in_schema("loggers", "deployment"))
    retrievals <- dplyr::tbl(con, dbplyr::in_schema("loggers", "retrieval"))
    startups <- dplyr::tbl(con, dbplyr::in_schema("loggers", "startup"))
    shutdowns <- dplyr::tbl(con, dbplyr::in_schema("loggers", "shutdown"))

    sessions <- dplyr::left_join(sessions, dplyr::select(deployments, deployment_id, deployment_date), by = "deployment_id")
    sessions <- dplyr::left_join(sessions, dplyr::select(retrievals, retrieval_id, retrieval_date), by = "retrieval_id")

    sessions <- dplyr::mutate(sessions, deployment_year = lubridate::year(deployment_date), retrieval_year = lubridate::year(retrieval_date))

    if (!is.null(posdata_filename)) {
        sessions <- dplyr::mutate(sessions, logger_id_year = paste(logger_serial_no, retrieval_year, logger_model, sep = "_"))
        sessions <- dplyr::filter(sessions, logger_id_year %in% posdata_filename)
    }

    if (!is.null(logger_deployment_year)) {
        sessions <- dplyr::filter(sessions, deployment_year %in% logger_deployment_year)
    }

    if (!is.null(logger_retrieval_year)) {
        sessions <- dplyr::filter(sessions, retrieval_year %in% logger_retrieval_year)
    }

    sessions <- dplyr::left_join(sessions, dplyr::select(startups, session_id, starttime_gmt, started_by, started_where, days_delayed, programmed_gmt_time), by = "session_id")
    sessions <- dplyr::left_join(sessions, dplyr::select(shutdowns, session_id, download_date, download_type), by = "session_id")

    if (!is.null(logger_download_type)) {
        sessions <- dplyr::filter(sessions, download_type %in% logger_download_type)
    }

    new_sessions <- dplyr::select(
        sessions,
        session_id,
        individ_id,
        logger_serial_no,
        logger_model,
        colony,
        species,
        starttime_gmt,
        started_by,
        started_where,
        days_delayed,
        programmed_gmt_time,
        deployment_date,
        deployment_year,
        retrieval_date,
        download_date,
        retrieval_year,
        download_type,
        pos_data
    )
    return(tibble::as_tibble(new_sessions))
}
