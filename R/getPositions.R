#' Get position data from the database. Either "GLS" data (default), "IRMA" data, or "GPS" data.
#'
#' This is a convenience function that reads position data from the database. The default datatype is "GLS", which reads data from "positions.postable", which is the primary table position table in the DB. Optionally you can fetch "IRMA" data, which is IRMA processed position data, or "GPS" data.
#'
#' @param datatype "GLS", "IRMA", or "GPS". Which type of position data to fetch. Default is "GLS".
#' @param sessionId Character string of session ids to limit the selection to.
#' @param individId Character string of individ ids to limit the selection to.
#' @param species Character string. Option to limit selection to one or a set of species.Default is NULL, indicating all species.
#' The available choices can be seen in the column `species_name_eng` in the result from the function `getSpecies()`.
#' @param colony Character string. Option to limit selection to one or a set of colonies. Default is NULL. The available
#' choices can be seen in the column `colony_int_name` in the result from the function `getColonies()`.
#' @param age_deployment_class Character string. Option to limit selection to one or a set of age classes. Default is NULL.
#' @param dataResponsible Character string. Option to limit selection to one or a set of names of data responsible persons. Note that this
#' must conform to the name nomenclature used in the postable. Default is NULL. The available
#' choices can be seen in the column `name` in the result from the function `getNames()`.
#' @param ringnumber Character string. Option to limit selection to one or a set of ring numbers. Default is NULL.
#' @param year Character string. Option to limit selection to one or more years that the logging sessions span. The availablle
#' choices can be found in the `year_tracked` column in the result form the `getYears` function.
#' @param sessionId Character string. Option to limit selection to one or a set of session ids. Default is NULL.
#' @param individId Character string. Option to limit selection to one or a set of individual ids. Default is NULL.
#' @param project subset data for a character vector of project names. Default is NULL.
#' @param exclude_embargoed Boolean. If TRUE, records from embargoed projects are not included. Default is TRUE.
#' @param loadGeometries Boolean. If True, the returned object is a simple features object with only rows of eqfilter == TRUE. Default = False
#' @param limit FALSE or Integer. Limit the number of rows returned to this number. Default = False.
#' @param asTibble Boolean. Should the result be given as a tibble instead of a lazy query? Tibble is a little bit slower, but also here forces the timezone to "UTC".
#' @return A lazy query or optionally a tibble of postable records. In the case of loadGeometries = T (default), also of class sf (simple feature) with geometries based on lat lon.
#' @import dplyr
#' @export
#' @examples
#' \dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#'
#' positions <- getPositions(
#'   colony = "Kongsfjorden",
#'   dataResponsible = "Sebastien Descamps",
#'   species = "Little auk",
#'   limit = F,
#'   loadGeometries = F
#' )
#'
#' positions
#'
#' # get data with geometries (default)
#' positions2 <- getPositions(
#'   datatype = "GPS",
#'   limit = 500
#' )
#'
#' positions2
#'
#' # make a simple plot
#' plot(positions2["logger_model"], pch = 16)
#' }
#' @export
#' @concept positions


getPositions <- function(datatype = "GLS",
                         species = NULL,
                         colony = NULL,
                         age_deployment_class = NULL,
                         dataResponsible = NULL,
                         ringnumber = NULL,
                         year = NULL,
                         sessionId = NULL,
                         individId = NULL,
                         project = NULL,
                         exclude_embargoed = TRUE,
                         loadGeometries = FALSE,
                         asTibble = TRUE,
                         limit = FALSE) {
  checkCon()

  selectSpecies <- species
  selectColony <- colony
  selectAge <- age_deployment_class

  datatype <- match.arg(datatype,
    choices = c("GLS", "IRMA", "GPS")
  )

  if (!limit == FALSE && !is.numeric(limit)) {
    stop("limit must be FALSE or a numeric value")
  }

  source_table <- dplyr::case_when(
    datatype == "GLS" ~ "postable",
    datatype == "IRMA" ~ "irma",
    datatype == "GPS" ~ "gps"
  )

  res <- tbl(con, dbplyr::in_schema("positions", source_table))


  if (!is.null(species)) {
    res <- res |> filter(species %in% selectSpecies)
  }

  if (!is.null(colony)) {
    res <- res |> filter(colony %in% selectColony)
  }

  if (!is.null(selectAge)) {
    res <- res |>
      mutate(
        age_deployment_class = ifelse(!is.na(age_deployment) & tolower(age_deployment) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A")
      ) %>%
      filter(age_deployment_class %in% selectAge) %>%
      select(-age_deployment_class)
  }

  if (!is.null(dataResponsible)) {
    res <- res |> filter(data_responsible %in% dataResponsible)
  }

  if (!is.null(ringnumber)) {
    res <- res |> filter(ring_number %in% ringnumber)
  }

  if (!is.null(year)) {
    res <- res |> filter(year_tracked %in% year)
  }

  if (!is.null(sessionId)) {
    res <- res |> filter(session_id %in% sessionId)
  }

  if (!is.null(individId)) {
    res <- res |> filter(individ_id %in% individId)
  }

  if (!is.null(project) || exclude_embargoed) {
    # join to allocation table
    allocation <- tbl(con, dbplyr::in_schema("loggers", "allocation"))
    res <- res |> left_join(select(allocation, session_id, project), by = "session_id")
    if (!is.null(project)) {
      res <- res |> filter(project %in% !!project)
    }
    if (exclude_embargoed) {
      res <- res |> filter(!grepl("_embargoed", project, fixed = FALSE))
    }
    res <- res |> select(-"project")
  }

  if (!limit == FALSE) {
    res <- res |> head(limit)
  }


  if (loadGeometries) {
    if (datatype == "GLS") {
      res <- res |>
        filter(eqfilter)
    }

    DBI::dbWithTransaction(
      con,
      {
        res <- st_read(dsn = con, query = dbplyr::sql_render(res))
      }
    )
    res <- res |>
      mutate(date_time = lubridate::force_tz(date_time,
        tzone = "UTC"
      ))
  } else {
    res <- res |>
      select(-geom)

    if (asTibble) {
      DBI::dbWithTransaction(
        con,
        {
          res <- res |> dplyr::collect()
        }
      )
      res <- res |>
        mutate(date_time = lubridate::force_tz(date_time,
          tzone = "UTC"
        ))
    }
  }

  res <- res |>
    mutate(date_time_downloaded = lubridate::now())
  return(res)
}
