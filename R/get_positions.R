#' Get position data from the database. Either "GLS" data (default), "IRMA" data, or "GPS" data.
#'
#' This is a convenience function that reads position data from the database. The default datatype is "GLS", which reads data from "positions.postable", which is the primary table position table in the DB. Optionally you can fetch "IRMA" data, which is IRMA processed position data, or "GPS" data.
#'
#' @param datatype "GLS", "IRMA","GPS" or "GPS-GSM". Which type of position data to fetch. Default is "GLS".
#' @param species Character string. Option to limit selection to one or a set of species.Default is NULL, indicating all species.
#' The available choices can be seen in the column `species_name_eng` in the result from the function `getSpecies()`.
#' @param colony Character string. Option to limit selection to one or a set of colonies. Default is NULL. The available
#' choices can be seen in the column `colony_int_name` in the result from the function `getColonies()`.
#' @param location Character string. Option to limit selection to one or a set of colonies. Default is NULL. The available
#' @param age_deployment_class Character string. Option to limit selection to one or a set of age classes, "A" or "C". Default is NULL.
#' @param data_repsonsible Character string. Option to limit selection to one or a set of names of data responsible persons. Note that this
#' must conform to the name nomenclature used in the postable. Default is NULL. The available
#' choices can be seen in the column `name` in the result from the function `getNames()`.
#' @param ring_number Character string. Option to limit selection to one or a set of ring numbers. Default is NULL.
#' @param year Character string. Option to limit selection to one or more years that the logging sessions span. The availablle
#' choices can be found in the `year_tracked` column in the result form the `getYears` function.
#' @param session_id Character string. Option to limit selection to one or a set of session ids. Default is NULL.
#' @param individ_id Character string. Option to limit selection to one or a set of individual ids. Default is NULL.
#' @param project subset data for a character vector of project names. Default is NULL.
#' @param lme_area Character string. Option to limit selection to one or a set of LME areas. Default is NULL. The available
#' choices can be seen in the column `name` in the result from the function `getLMEAreas()`.
#' @param polygons An sf object with polygons. If provided, only positions within the polygons will be returned. Default is NULL.
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
#' @aliases getPositions
get_positions <- function(datatype = "GLS",
                         species = NULL,
                         colony = NULL,
                         location = NULL,
                         age_deployment_class = NULL,
                         data_responsible = NULL,
                         ring_number = NULL,
                         year = NULL,
                         session_id = NULL,
                         individ_id = NULL,
                         project = NULL,
                         lme_area = NULL,
                         polygons = NULL,
                         exclude_embargoed = TRUE,
                         loadGeometries = FALSE,
                         asTibble = TRUE,
                         limit = FALSE,
                         ...) {
  checkCon()

  all_args <- as.list(environment())
  other_args <- list(...)
  valid_alias <- c(
    session_id = "sessionId",
    individId = "individ_id",
    ring_number = "ringnumber",
    data_responsible = "dataResponsible"
  )

  for (i in seq_along(valid_alias)) {
    if (valid_alias[[i]] %in% names(other_args)) {
      all_args[[names(valid_alias)[i]]] <- other_args[[valid_alias[[i]]]]
    }
  }

  basic_filter_args <- all_args[!names(all_args) %in% c(
    "age_deployment_class",
    "datatype",
    "project",
    "lme_area",
    "polygons",
    "exclude_embargoed",
    "loadGeometries",
    "as_tibble",
    "limit"
  )]

  # rewrite to be less repetitive
  selectSpecies <- species
  selectColony <- colony
  selectLocation <- location

  datatype <- match.arg(
    datatype,
    choices <- c("GLS", "IRMA", "GPS", "GPS-GSM")
  )

  if (!limit == FALSE && !is.numeric(limit)) {
    stop("limit must be FALSE or a numeric value")
  }

  source_table <- dplyr::case_when(
    datatype == "GLS" ~ "postable",
    datatype == "IRMA" ~ "irma",
    datatype == "GPS" ~ "gps",
    datatype == "GPS-GSM" ~ "gps_gsm"
  )

  if (!is.null(lme_area)) {
    res <- dplyr::tbl(con, sql(glue::glue_sql(
      "SELECT pos.* FROM positions.{`source_table`} pos
      JOIN areas.lme a
            ON ST_Contains(a.geom, pos.geom)
      WHERE a.name IN ({lme_area})
      ",
      .con = con
    )))
  } else if (!is.null(polygons)) {
    st_write(
      obj = polygons,
      dsn = con,
      layer = "temp_postable_poly",
      factorsAsCharacter = FALSE,
      layer_options = c("TEMPORARY=YES"),
      delete_layer = TRUE
    )

    res <- dplyr::tbl(con, sql(glue::glue_sql(
      "SELECT pos.* FROM positions.{`source_table`} pos
        JOIN temp_postable_poly a
              ON ST_Contains(a.geometry, pos.geom)
        ",
      .con = con
    )))
  } else {
    res <- dplyr::tbl(con, dbplyr::in_schema("positions", source_table))
  }



  for (i in seq_along(basic_filter_args)) {
    val_name <- names(basic_filter_args)[i]
    value <- basic_filter_args[[i]]
    if (!is.null(value)) {
      res <- dplyr::filter(res, !!rlang::sym(val_name) %in% value)
    }
  }

  # Non-built in filters

  if (!is.null(age_deployment_class)) {
    res <- res |>
      mutate(
        age_deployment_class = ifelse(!is.na(age_deployment) & tolower(age_deployment) %in% c("pullus", "chick", "pull", "juvenile"), "C", "A")
      ) %>%
      filter(age_deployment_class %in% !!age_deployment_class) %>%
      select(-age_deployment_class)
  }


  if (!is.null(project) || exclude_embargoed) {
    # join to allocation table
    allocation <- tbl(con, dbplyr::in_schema("loggers", "allocation"))
    res <- res |> left_join(select(allocation, session_id, project), by = "session_id")
    if (!is.null(project)) {
      res <- res |> filter(project %in% !!project)
    }
    if (exclude_embargoed) {
      res <- res |> filter(is.na(project) | !grepl("_embargoed", project, fixed = FALSE))
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
        res <- sf::st_read(dsn = con, query = dbplyr::sql_render(res))
      }
    )
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
    }
  }

  res <- res |>
    mutate(date_time_downloaded = lubridate::now())
  return(res)
}

getPositions <- get_positions