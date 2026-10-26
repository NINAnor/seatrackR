#' Retrieve logger session information
#'
#' This function retrieves information about logger sessions from the database view `logger.session_details`.
#' It provides comprehensive filtering argument to narrow down the results.
#' @param session_id Optional vector of session IDs to filter by.
#' @param individ_id Optional vector of individual IDs to filter by.
#' @param project Optional vector of project names to filter by.
#' @param logger_serial_no Optional vector of logger serial numbers to filter by.
#' @param logger_model Optional vector of logger models to filter by.
#' @param logger_producer Optional vector of logger producers to filter by.
#' @param logger_type Optional vector of logger types to filter by.
#' @param active Optional logical indicating whether to filter by active logger sessions.
#' @param colony Optional vector of colony names to filter by.
#' @param location Optional vector of location names to filter by.
#' @param species Optional vector of species names to filter by.
#' @param deployment_age_class Optional vector of age deployment classes ("C" or "A") to filter by.
#' @param sex Optional vector of sexes to filter by.
#' @param sexing_method Optional vector of sexing methods to filter by.
#' @param years_tracked Optional vector of years tracked to filter by.
#' @param logger_start_time Optional vector of logger start times to filter by.
#' @param logger_start_time_between Optional vector of two dates to filter logger start times between.
#' @param logging_mode Optional vector of logging modes to filter by.
#' @param logger_deployed Optional logical indicating whether to filter by deployed loggers.
#' @param deployment_year Optional vector of deployment years to filter by.
#' @param deployment_date_between Optional vector of two dates to filter deployment dates between.
#' @param deployment_logger_status Optional vector of deployment logger statuses to filter by.
#' @param logger_retrieved Optional logical indicating whether to filter by retrieved loggers.
#' @param retrieval_year Optional vector of retrieval years to filter by.
#' @param retrieval_date_between Optional vector of two dates to filter retrieval dates between.
#' @param retrieval_logger_status Optional vector of retrieval logger statuses to filter by.
#' @param shutdown_date_between Optional vector of two dates to filter shutdown dates between.
#' @param dates_deployed_overlap Optional vector of two dates to filter sessions to any loggers that were deployed during that time period. This is an overlap filter, meaning that any session that overlaps with the specified date range will be included.
#' @param download_type Optional vector of download types to filter by.
#' @param has_positions Optional logical indicating whether to filter by sessions with position data.
#' @param has_irma Optional logical indicating whether to filter by sessions with IRMA data.
#' @param embargoed Optional logical indicating whether to include embargoed sessions. Default is FALSE.
#' @param lme_area Character string. Option to limit selection to one or a set of LME areas. Default is NULL. The available
#' choices can be seen in the column `name` in the result from the function `getLMEAreas()`.
#' @param polygons Optional sf object with polygons to filter sessions by spatial intersection. Default is NULL.
#' @param include_sample_info Optional logical indicating whether to include sample information (blood, feathers etc.) in the results. Default is FALSE.
#' @param as_tibble Logical indicating whether to return the result as a tibble.
#' @return Either a lazy db query or a tibble containing the filtered logger session information.
#' @export
#' @concept logger_info
#' @rdname get_session_info
get_session_info <- function(
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
  location = NULL,
  species = NULL,
  deployment_age_class = NULL,
  sex = NULL,
  sexing_method = NULL,
  years_tracked = NULL,
  logger_start_time = NULL,
  logger_start_time_between = NULL,
  logging_mode = NULL,
  deployment_year = NULL,
  deployment_date_between = NULL,
  deployment_logger_status = NULL,
  retrieval_year = NULL,
  retrieval_date_between = NULL,
  retrieval_logger_status = NULL,
  shutdown_date_between = NULL,
  dates_deployed_overlap = NULL,
  download_type = NULL,
  has_positions = NULL,
  has_irma = NULL,
  embargoed = FALSE,
  lme_area = NULL,
  polygons = NULL,
  as_tibble = TRUE,
  include_sample_info = FALSE
) {
    checkCon()

    all_args <- as.list(environment())

    basic_filter_args <- all_args[!names(all_args) %in% c(
        "include_sample_info",
        "as_tibble",
        "logger_start_time_between",
        "logger_deployment_date_between",
        "logger_retrieval_date_between",
        "shutdown_date_between",
        "dates_deployed_overlap",
        "lme_area",
        "polygons"
    )]

    between_filter_args <- list(
        logger_start_time = logger_start_time_between,
        deployment_date = deployment_date_between,
        retrieval_date = retrieval_date_between,
        shutdown_date = shutdown_date_between
    )

    intersection_filter_args <- list(
        dates_deployed_overlap = list(
            value = dates_deployed_overlap,
            start_date = "deployment_date",
            end_date = "retrieval_date"
        )
    )

    source_table <- dplyr::case_when(
        include_sample_info ~ "session_sample_details",
        .default = "session_details"
    )

    session_details <- dplyr::tbl(con, dbplyr::in_schema("loggers", source_table))
    session_details <- mutate(session_details,
        age_deployment_class = ifelse(!is.na(deployment_age) & tolower(deployment_age) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A"),
    ) # Move this to the view

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
            if (length(value) != 2) {
                stop("Between filter values must be a vector of length 2.")
            }
            start_val <- value[1]
            end_val <- value[2]
            if (!is.na(end_val) && end_val < start_val) {
                stop("Second element of between filter values must be NA or greater than first.")
            }

            session_details <- dplyr::filter(session_details, !!rlang::sym(val_name) >= start_val)
            if (!is.na(end_val)) {
                session_details <- dplyr::filter(session_details, !!rlang::sym(val_name) <= end_val)
            }
        }
    }

    for (i in seq_along(intersection_filter_args)) {
        arg_i <- intersection_filter_args[[i]]
        value <- arg_i$value
        val_names <- c(arg_i$start_date, arg_i$end_date)
        if (!is.null(value)) {
            if (length(value) != 2) {
                stop("Overlap filter values must be a vector of length 2.")
            }
            start_val <- value[1]
            end_val <- value[2]
            start_val_name <- val_names[1]
            end_val_name <- val_names[2]
            # x_start <= y_end && y_start <= x_end
            session_details <- dplyr::filter(session_details, (is.na(!!rlang::sym(end_val_name)) | start_val <= !!rlang::sym(end_val_name)) & !!rlang::sym(start_val_name) <= end_val)
        }
    }

    # Spatial intersection
    if (!is.null(lme_area) || !is.null(polygons)) {
        print("Filtering sessions by spatial intersection with LME areas or provided polygons. This may take some time for large datasets.")
        # Find all positions for these sessions
        session_data_types <- dplyr::distinct(session_details, session_id, logger_type)
        all_data_types <- distinct(session_data_types, logger_type) %>% pull(logger_type)

        all_session_ids <- c()
        for (data_type in all_data_types) {
            data_type_session_ids <- dplyr::filter(session_data_types, logger_type == data_type) %>% pull(session_id)
            session_id_chunks <- split(
                data_type_session_ids,
                ceiling(seq_along(data_type_session_ids) / 100)
            )
            print(paste0("Processing ", length(session_id_chunks), " chunks of session IDs for data type: ", data_type))
            for (i in seq_along(session_id_chunks)) {
                session_id_chunk <- session_id_chunks[[i]]
                print(paste0("Processing chunk ", i, " of ", length(session_id_chunks), " for data type: ", data_type))
                loc_table <- get_positions(
                    datatype = data_type,
                    species = species,
                    colony = colony,
                    location = location,
                    session_id = session_id_chunk,
                    individ_id = individ_id,
                    project = project,
                    lme_area = lme_area,
                    polygons = polygons,
                    loadGeometries = FALSE,
                    as_tibble = FALSE
                )
                all_session_ids <- c(all_session_ids, dplyr::distinct(loc_table, session_id) %>% pull(session_id))
            }
        }
        print(paste0("Found ", length(all_session_ids), " sessions with positions in the specified LME areas or polygons."))
        session_details <- dplyr::filter(session_details, session_id %in% !!all_session_ids)
    }

    if (as_tibble) {
        session_details <- dplyr::collect(session_details)
    }
    return(session_details)
}

#' @rdname get_session_info
#' @export
getSessionInfo <- get_session_info