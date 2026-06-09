#' Retrieve info on the individuals
#'
#' This is a convenience function that pulls together various info on the files in the individuals.individ_info and individuals.individ_status table and other tables
#'
#' @param colony Optional vector of character string of colonies limit the selection to. Available choices are found in "colony_int_name", from getColonies()
#' @param deployment_year Optional integer of years, to limit the selection to the year a logger was deployed.
#' @param retrieval_year Optional integer of years, to limit the selection to the year a logger was retrieved.
#' @param year_tracked Optional vector of character strings of year_tracked to limit the selection to. This has the form "2020_21", see getYears for available choices.
#' @param species Optional vector of character strings of species to limit the selection to. Available choices are found in "species", from getSpecies()
#' @param sex Optional vector of character strings of sex to limit the selection to.
#' @param age_at_deployment Optional vector of character strings of age at deployment to limit the selection to. Available choices are "A" for adult and "C" for chick. Default is "A", meaning that by default only individuals that were adults at the time of deployment are included.
#' @param age Optional vector of character strings of age to limit the selection to.
#' @param event_type Optional vector of character strings of event types to limit the selection to. Available choices are "Deployment" and "Retrieval".
#' @param last_only Logical. If TRUE, only the most recent status info per individual is returned. Default is FALSE.
#' @param session_id Optional vector of character strings of session_id to limit the selection to.
#' @return Data frame.
#' @export
#' @examples
#' \dontrun{
#' seatrackConnect(Username = "testreader", Password = "testreader")
#' individInfo <- getInfividInfo()
#' }
#' @concept metadata
getIndividInfo <- function(colony = NULL,
                           year_tracked = NULL,
                           deployment_year = NULL,
                           retrieval_year = NULL,
                           species = NULL,
                           age = NULL,
                           age_at_deployment = "A",
                           sex = NULL,
                           project = "SEATRACK",
                           event_type = NULL,
                           last_only = FALSE,
                           session_id = NULL) {
  checkCon()

  arg_list <- list(colony = colony, year_tracked = year_tracked, species = species, age = age, age_deployment_class = age_at_deployment, session_id = session_id, project = project)

  sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))

  individs <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_info"))
  status <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_status"))

  sessions <- left_join(sessions, individs, by = c("individ_id" = "individ_id"), suffix = c("", ".y"))
  sessions <- select(sessions, -dplyr::ends_with(".y"))

  db_deployments <- dplyr::tbl(con, dbplyr::in_schema("loggers", "deployment"))
  db_deployments <- dplyr::left_join(db_deployments, status, dplyr::join_by("session_id", deployment_date == status_date), suffix = c("", ".status"))
  db_deployments <- dplyr::mutate(db_deployments,
    age_deployment = age,
  )
  sessions <- dplyr::left_join(sessions, db_deployments, by = "deployment_id", suffix = c("", ".deployment"))

  sessions <- sessions |>
    mutate(
      age_deployment_class = ifelse(!is.na(age_deployment) & tolower(age_deployment) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A")
    )

  allocation <- tbl(con, dbplyr::in_schema("loggers", "allocation"))
  sessions <- dplyr::left_join(sessions, select(allocation, session_id, project), by = "session_id", suffix = c("", ".allocation"))

  for (i in seq_along(arg_list)) {
    val_name <- names(arg_list)[i]
    value <- arg_list[[i]]
    if (!is.null(value)) {
      sessions <- dplyr::filter(sessions, !!rlang::sym(val_name) %in% value)
    }
  }
  sessions <- select(sessions, -age_deployment_class, -age_deployment, -ends_with(".deployment"), -project)

  sessions <- inner_join(sessions, status, by = c("session_id" = "session_id"), suffix = c("", ".y"))

  query <- select(sessions, session_id,
    colony,
    year_tracked,
    individ_id,
    ring_number = ring_number,
    country_code = euring_code,
    color_ring = color_ring,
    species = species,
    subspecies = subspecies,
    morph = morph,
    status_age = age,
    status_sex = sex,
    status_sexing_method = sexing_method,
    status_date,
    weight,
    skull = scull,
    tarsus,
    wing,
    breeding_stage,
    eggs,
    chicks,
    hatching_success,
    breeding_success,
    breeding_success_criterion,
    data_responsible = data_responsible,
    back_on_nest,
    comment,
    latest_sex = sex.y,
    latest_sexing_method = sexing_method.y,
    latest_age = age.y,
    latest_info_date,
    deployment_id,
    retrieval_id
  )

  deployments <- dplyr::tbl(con, dbplyr::in_schema("loggers", "deployment"))
  deployments <- dplyr::mutate(deployments, eventType = "Deployment", status_date = deployment_date)
  deployments <- dplyr::mutate(deployments, year_deployed = lubridate::year(status_date))

  if (!is.null(deployment_year)) {
    deployments <- dplyr::filter(deployments, year_deployed %in% deployment_year)
  }

  deployment_ids <- dplyr::distinct(select(query, deployment_id))
  deployments <- dplyr::inner_join(deployments, deployment_ids,
    by = "deployment_id"
  )
  deployments <- dplyr::select(deployments, -year_deployed)
  deployment_session_ids <- dplyr::distinct(select(deployments, session_id))

  retrievals <- dplyr::tbl(con, dbplyr::in_schema("loggers", "retrieval"))
  retrievals <- dplyr::mutate(retrievals, eventType = "Retrieval", status_date = retrieval_date)

  retrievals <- dplyr::mutate(retrievals, year_retrieved = lubridate::year(status_date))

  if (!is.null(retrieval_year)) {
    retrievals <- dplyr::filter(retrievals, year_retrieved %in% retrieval_year)
    retrieval_session_ids <- dplyr::distinct(select(retrievals, session_id))
    deployments <- dplyr::inner_join(deployments, retrieval_session_ids,
      by = "session_id"
    )
    deployment_session_ids <- dplyr::distinct(select(deployments, session_id))
  }

  retrievals <- dplyr::inner_join(retrievals, deployment_session_ids,
    by = "session_id"
  )
  retrievals <- dplyr::select(retrievals, -year_retrieved)

  events <- dplyr::union(deployments, retrievals)
  if (!is.null(event_type)) {
    events <- dplyr::filter(events, eventType %in% event_type)
  }
  events <- dplyr::select(events, -dplyr::starts_with("deployment"), -dplyr::starts_with("retrieval"))
  query <- dplyr::select(query, -retrieval_id, -deployment_id)

  out <- dplyr::inner_join(query, events,
    by = c(
      "session_id" = "session_id",
      "status_date" = "status_date"
    ),
    suffix = c("", ".y"),
  )
  out <- dplyr::select(out, -dplyr::ends_with(".y"))

  if (last_only) {
    out <- dplyr::group_by(out, session_id) %>%
      dplyr::filter(status_date == max(status_date, na.rm = TRUE)) %>%
      dplyr::ungroup()
  }

  out <- dplyr::arrange(
    out,
    colony,
    species,
    year_tracked,
    ring_number,
    status_date
  )
  
  out <- dplyr::select(out, -id, -logger_fate, -attribute_name)

  return_query <- tibble::as_tibble(out)

  return(return_query)
}
