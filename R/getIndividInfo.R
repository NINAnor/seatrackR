#' Retrieve info on the individuals
#'
#' This is a convenience function that pulls together various info on the files in the individuals.individ_info and individuals.individ_status table and other tables
#'
#' @param colony Optional vector of character string of colonies limit the selection to. Available choices are found in "colony_int_name", from getColonies()
#' @param year_tracked Optional vector of character strings of year_tracked to limit the selection to. This has the form "2020_21", see getYears for available choices.
#' @param deployment_year Optional integer of years, to limit the selection to the year a logger was deployed.
#' @param retrieval_year Optional integer of years, to limit the selection to the year a logger was retrieved.
#' @param species Optional vector of character strings of species to limit the selection to. Available choices are found in "species", from getSpecies()
#' @param age Optional vector of character strings of age to limit the selection to.
#' @param age_at_deployment Optional vector of character strings of age at deployment to limit the selection to. Available choices are "A" for adult and "C" for chick. Default is "A", meaning that by default only individuals that were adults at the time of deployment are included.
#' @param sex Optional vector of character strings of sex to limit the selection to.
#' @param project subset data for a character vector of project names. Default is NULL.
#' @param exclude_embargoed Boolean. If TRUE, records from embaroed projects are not included. Default is TRUE.
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
                           project = NULL,
                           exclude_embargoed = TRUE,
                           event_type = NULL,
                           last_only = FALSE,
                           session_id = NULL) {
  checkCon()

  if (check_db_version() >= 46) {
    return(new_get_indiv_info(
      colony = colony,
      year_tracked = year_tracked,
      deployment_year = deployment_year,
      retrieval_year = retrieval_year,
      species = species,
      age = age,
      age_at_deployment = age_at_deployment,
      sex = sex,
      project = project,
      exclude_embargoed = exclude_embargoed,
      event_type = event_type,
      last_only = last_only,
      session_id = session_id
    ))
  }

  # Old function - can be removed once migration is complete.

  arg_list <- list(
    colony = colony,
    year_tracked = year_tracked,
    species = species,
    age = age,
    age_deployment_class = age_at_deployment,
    session_id = session_id,
    project = project
  )

  sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))

  individs <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_info"))
  status <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_status"))

  # Support new way of handling people.
  if (check_db_version() >= 34) {
    status_people <- dplyr::tbl(con, dbplyr::in_schema("individuals", "status_people"))
    people <- dplyr::tbl(con, dbplyr::in_schema("metadata", "people"))

    status_people <- dplyr::left_join(status_people, people, by = "person_id")
    status_people <- dplyr::group_by(status_people, status_id) %>%
      dbplyr::window_order(person_order) %>%
      dplyr::summarise(data_responsible = stringr::str_flatten(
        full_name,
        collapse = "_"
      ))
    status <- dplyr::left_join(status, status_people,
      by = join_by(id == status_id)
    )
  }

  if (check_db_version() >= 36) {
    individs2 <- individs %>%
      dplyr::mutate(id_chr = as.character(id))

    max_date <- status %>%
      dplyr::mutate(info_id_chr = as.character(info_id)) %>%
      dplyr::group_by(info_id_chr) %>%
      dplyr::summarise(latest_info_date = max(status_date))

    individs <- individs2 %>%
      dplyr::left_join(max_date, by = dplyr::join_by(id_chr == info_id_chr))
  }

  # Filtering
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
  if (exclude_embargoed) {
    sessions <- dplyr::filter(sessions, !grepl("_embargoed", project, fixed = FALSE))
  }

  sessions <- dplyr::left_join(sessions, status, by = "session_id", suffix = c(".session", ".status"), multiple = "all")
  sessions <- dplyr::left_join(sessions, individs, by = "individ_id", suffix = c(".session", ".info"), multiple = "all")


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
    status_age = age.status,
    status_sex = sex.status,
    status_sexing_method = sexing_method,
    status_date,
    weight = weight.status,
    skull = scull.status,
    tarsus = tarsus.status,
    wing = wing.status,
    breeding_stage = breeding_stage.status,
    eggs = eggs.status,
    chicks = chicks.status,
    hatching_success = hatching_success.status,
    breeding_success = breeding_success.status,
    breeding_success_criterion = breeding_success_criterion.status,
    data_responsible = data_responsible.status,
    back_on_nest = back_on_nest.status,
    comment = comment.status,
    latest_sex = sex,
    latest_sexing_method = sexing_method,
    latest_age = age,
    latest_info_date = latest_info_date.info,
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

  out <- dplyr::left_join(query, events,
    by = dplyr::join_by(
      "session_id" == "session_id",
      "status_date" == "status_date"
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

new_get_indiv_info <- function(colony = NULL,
                               year_tracked = NULL,
                               deployment_year = NULL,
                               retrieval_year = NULL,
                               species = NULL,
                               age = NULL,
                               age_at_deployment = "A",
                               sex = NULL,
                               project = NULL,
                               exclude_embargoed = TRUE,
                               event_type = NULL,
                               last_only = FALSE,
                               session_id = NULL) {
  arg_list <- list(
    colony = colony,
    year_tracked = year_tracked,
    species = species,
    status_age = age,
    age_deployment_class = age_at_deployment,
    session_id = session_id,
    project = project,
    deployment_year = deployment_year,
    retrieval_year = retrieval_year
  )

  # add deployment age/year for filtering
  individ_info_view <- dplyr::tbl(con, dbplyr::in_schema("views", "individual_info"))

  deployments <- individ_info_view %>%
    dplyr::filter(event_type == "deployment") %>%
    mutate(
      age_deployment_class = ifelse(!is.na(status_age) & tolower(status_age) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A"),
      deployment_year = lubridate::year(status_date)
    )

  individ_info_view <- dplyr::left_join(individ_info_view, select(deployments, session_id, age_deployment_class, deployment_year), by = "session_id")

  # add retrieval info
  retrievals <- individ_info_view %>%
    dplyr::filter(event_type == "retrieval") %>%
    mutate(
      retrieval_year = lubridate::year(status_date)
    )

  individ_info_view <- dplyr::left_join(individ_info_view, select(retrievals, session_id, retrieval_year), by = "session_id")

  # add project
  allocation <- tbl(con, dbplyr::in_schema("loggers", "allocation"))
  individ_info_view <- dplyr::left_join(individ_info_view, select(allocation, session_id, project), by = "session_id", suffix = c("", ".allocation"))


  for (i in seq_along(arg_list)) {
    val_name <- names(arg_list)[i]
    value <- arg_list[[i]]
    if (!is.null(value)) {
      individ_info_view <- dplyr::filter(individ_info_view, !!rlang::sym(val_name) %in% value)
    }
  }
  if (exclude_embargoed) {
    individ_info_view <- dplyr::filter(individ_info_view, !grepl("_embargoed", project, fixed = FALSE))
  }

  # Drop columns that were added for filtering (for now)
  individ_info_view <- dplyr::select(individ_info_view, -project, -age_deployment_class, -deployment_year, -retrieval_year)

  # Last only filtering
  if (last_only) {
    individ_info_view <- dplyr::group_by(individ_info_view, session_id) %>%
      dplyr::filter(status_date == max(status_date, na.rm = TRUE)) %>%
      dplyr::ungroup()
  }

  # Rename column to match existing schema
  individ_info_view <- dplyr::rename(individ_info_view, eventType = event_type)

  return(dplyr::collect(individ_info_view))
}
