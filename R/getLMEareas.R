#' Get LME areas
#'
#' This function retrieves the LME areas from the database. Optionally, it can load geometries for the LME areas.
#'
#' @param loadGeometries Boolean. Should the geometries be loaded as an sf object. Default = FALSE
#'
#' @return A tibble of the LME areas with or without sf geometry.
#' @export
#' @concept metadata
getLMEAreas <- function(loadGeometries = FALSE) {
    checkCon()

    lme_areas <- dplyr::tbl(con, dbplyr::in_schema("areas", "lme")) %>% collect()
    if (loadGeometries) {
        lme_areas <- dplyr::filter(lme_areas, !is.na(geom))
        lme_areas$geom <- sf::st_as_sfc(lme_areas$geom, remove = FALSE)
    } else {
        locations$geom <- NULL
    }

    return(lme_areas)
}
