#' Retrieve info on the individuals
#'
#' This is a convenience function that pulls together various info on the files in the individuals.individ_info and individuals.individ_status table and other tables
#'
#' @param colony Optional vector of character string of colonies. Available choices are found in "colony_int_name", from getColonies()
#' @param year_tracked Optional vector of character strings of year_tracked to limit the selection to. This has the form "2020_21", see getYears for available choices.
#' @param deployment_year Optional integer of years, to limit the selection to the year a logger was deployed.
#' @param retrieval_year Optional integer of years, to limit the selection to the year a logger was retrieved.
#' @param species Optional vector of character strings of species to limit the selection to. Available choices are found in "species", from getSpecies()
#' @param age Optional vector of character strings of age to limit the selection to.
#' @param age_at_deployment Optional vector of character strings of age at deployment to limit the selection to. Available choices are "A" for adult and "C" for chick. Default is "A", meaning that by default only individuals that were adults at the time of deployment are included.
#' @param sex Optional vector of character strings of sex to limit the selection to.
#' @param project subset data for a character vector of project names. Default is NULL.
#' @param location Optional vector of character string of locations. Available choices are found in "location_name", from getColonies(allLocations = TRUE)
#' @param exclude_embargoed Boolean. If TRUE, records from embaroed projects are not included. Default is TRUE.
#' @param event_type Optional vector of character strings of event types to limit the selection to. Available choices are "Deployment" and "Retrieval".
#' @param last_only Logical. If TRUE, only the most recent status info per individual is returned. Default is FALSE.
#' @param session_id Optional vector of character strings of session_id to limit the selection to.
#' @param as_tibble Logical. If TRUE, the output is returned as a tibble. If FALSE, the output is returned as a lazy query object. Default is TRUE.
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
                           location = NULL,
                           exclude_embargoed = TRUE,
                           event_type = NULL,
                           last_only = FALSE,
                           session_id = NULL,
                           as_tibble = TRUE) {
  checkCon()

      query <- new_get_indiv_info(
      colony = colony,
      location = location,
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
    )
    if(as_tibble){
      query <- dplyr::collect(query)
    }

    return(query)
  }



new_get_indiv_info <- function(colony = NULL,
                               location = NULL,
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
    location = location,
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
  db_individ_info_view <- dplyr::tbl(con, dbplyr::in_schema("individuals", "full_status"))

  deployments <- db_individ_info_view %>%
    dplyr::filter(event_type == "deployment") %>%
    mutate(
      age_deployment_class = ifelse(!is.na(status_age) & tolower(status_age) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A"),
      deployment_year = lubridate::year(status_date)
    )

  individ_info_view <- dplyr::left_join(db_individ_info_view, select(deployments, session_id, age_deployment_class, deployment_year), by = "session_id")

  # add retrieval info
  retrievals <- db_individ_info_view %>%
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
    individ_info_view <- dplyr::filter(individ_info_view, is.na(project) | !grepl("_embargoed", project, fixed = FALSE))
  }

  # Drop columns that were added for filtering (for now)
  #individ_info_view <- dplyr::select(individ_info_view, -project, -age_deployment_class, -deployment_year, -retrieval_year)

  # Last only filtering
  if (last_only) {
    individ_info_view <- dplyr::group_by(individ_info_view, session_id) %>%
      dplyr::filter(status_date == max(status_date, na.rm = TRUE)) %>%
      dplyr::ungroup()
  }

  # Rename column to match existing schema
  individ_info_view <- dplyr::rename(individ_info_view, eventType = event_type)

  return(individ_info_view)
}

