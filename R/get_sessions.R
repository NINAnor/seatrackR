#' Retrieve logger session information
#'
#' This function retrieves information about logger sessions from the database, allowing for various filters to narrow down the results.
#' @param session_id Optional vector of session IDs to filter by.
#' @param individ_id Optional vector of individual IDs to filter by.
#' @param project Optional vector of project names to filter by.
#' @param logger_serial_no Optional vector of logger serial numbers to filter by.
#' @param logger_model Optional vector of logger models to filter by.
#' @param logger_producer Optional vector of logger producers to filter by.
#' @param logger_type Optional vector of logger types to filter by.
#' @param active Optional logical indicating whether to filter by active logger sessions.
#' @param colony Optional vector of colony names to filter by.
#' @param species Optional vector of species names to filter by.
#' @param deployment_age_class Optional vector of age deployment classes ("C" or "A") to filter by.
#' @param sex Optional vector of sexes to filter by.
#' @param sexing_method Optional vector of sexing methods to filter by.
#' @param years_tracked Optional vector of years tracked to filter by.
#' @param logger_start_time Optional vector of logger start times to filter by.
#' @param logger_start_time_between Optional vector of two dates to filter logger start times between.
#' @param logging_mode Optional vector of logging modes to filter by.
#' @param logger_deployed Optional logical indicating whether to filter by deployed loggers.
#' @param logger_deployment_year Optional vector of deployment years to filter by.
#' @param logger_deployment_date_between Optional vector of two dates to filter deployment dates between.
#' @param deployment_logger_status Optional vector of deployment logger statuses to filter by.
#' @param logger_retrieved Optional logical indicating whether to filter by retrieved loggers.
#' @param logger_retrieval_year Optional vector of retrieval years to filter by.
#' @param logger_retrieval_date_between Optional vector of two dates to filter retrieval dates between.
#' @param retrieval_logger_status Optional vector of retrieval logger statuses to filter by.
#' @param logger_shutdown_date_between Optional vector of two dates to filter shutdown dates between.
#' @param download_type Optional vector of download types to filter by.
#' @param has_positions Optional logical indicating whether to filter by sessions with position data.
#' @param has_irma Optional logical indicating whether to filter by sessions with IRMA data.
#' @param embargoed Optional logical indicating whether to include embargoed sessions. Default is FALSE.
#' @param as_tibble Logical indicating whether to return the result as a tibble.
#' @return Either a lazy db query or a tibble containing the filtered logger session information.
#' @export
#' @concept logger_info
getSessionInfo <- function(
    session_id = NULL,
    individ_id = NULL,
    project = NULL,
    logger_serial_no = NULL,
    logger_model = NULL,
    logger_producer = NULL,
    logger_type = NULL,
    logger_deployed = NULL,
    logger_retrieved = NULL,
    active = NULL,
    colony = NULL,
    species = NULL,
    deployment_age_class = NULL,
    sex = NULL,
    sexing_method = NULL,
    years_tracked = NULL,
    logger_start_time = NULL,
    logger_start_time_between = NULL,
    logging_mode = NULL,
    logger_deployment_year = NULL,
    logger_deployment_date_between = NULL,
    deployment_logger_status = NULL,
    logger_retrieval_year = NULL,
    logger_retrieval_date_between = NULL,
    retrieval_logger_status = NULL,
    logger_shutdown_date_between = NULL,
    download_type = NULL,
    has_positions = NULL,
    has_irma = NULL,
    embargoed = FALSE,
    as_tibble = TRUE
) {

      checkCon()

    if (check_db_version() >= 61) {
        all_args <- as.list(environment())
        
        basic_filter_args <- all_args[!names(all_args) %in% c("as_tibble", "logger_start_time_between" ,"logger_deployment_date_between", "logger_retrieval_date_between", "shutdown_date_between")]
        
        between_filter_args <- list(
            logger_start_time = logger_start_time_between,
            deployment_date = logger_deployment_date_between,
            retrieval_date = logger_retrieval_date_between,
            shutdown_date = logger_shutdown_date_between
        )
        
        session_details <- dplyr::tbl(con, dbplyr::in_schema("loggers", "session_details"))
        session_details <- mutate(session_details, 
            age_deployment_class = ifelse(!is.na(deployment_age) & tolower(deployment_age) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A"),
        )# Move this to the view
        
        for (i in seq_along(basic_filter_args)) {
            val_name <- names(basic_filter_args)[i]
            value <- basic_filter_args[[i]]
            if (!is.null(value)) {
            session_details <- dplyr::filter(session_details, !!rlang::sym(val_name) %in% value)
            }
        }

        for (i in seq_along(between_filter_args)) {
            val_name <- names(between_filter_args)[i]
            value <- between_filter_args[[i]]
            if (!is.null(value)) {
                if(length(value) != 2){
                    stop("Between filter values must be a vector of length 2.")
                }
                start_val <- value[1]
                end_val <- value[2]
                if(!is.na(end_val) && end_val < start_val){
                    stop("Second element of between filter values must be NA or greater than first.")
                }

                session_details <- dplyr::filter(session_details, !!rlang::sym(val_name) >= start_val)
                if(!is.na(end_val)){
                   session_details <- dplyr::filter(session_details, !!rlang::sym(val_name) <= end_val) 
                }
            }
        }
        if(as_tibble){
            session_details <- dplyr::collect(session_details)
        }        
        return(session_details)
    }

    sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))
    postable <- dplyr::tbl(con, dbplyr::in_schema("positions", "postable_raw"))
    pos_sessions <- dplyr::distinct(select(postable, session_id))
    pos_sessions <- dplyr::mutate(pos_sessions, pos_data = TRUE)
    sessions <- dplyr::left_join(sessions, pos_sessions, by = "session_id")
    sessions <- dplyr::mutate(sessions, pos_data = !is.na(pos_data))
    if (!is.null(session_ids)) {
        sessions <- dplyr::filter(sessions, session_id %in% session_ids)
    }
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

    sessions <- dplyr::left_join(sessions, dplyr::select(startups, session_id, starttime_gmt, started_where, days_delayed, programmed_gmt_time), by = "session_id")
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
    if(as_tibble){
        return(tibble::as_tibble(new_sessions))
    }
    return(new_sessions)
    
}
