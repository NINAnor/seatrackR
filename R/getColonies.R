#' Retrieve info on the registered colonies and locations within colonies in the database
#'
#' This function either reads from the metadata.colony or the metadata.location table, depending on the parameter allLocations.
#' If loadGeometries is set to TRUE, the function will return an sf object with the geometries of the colonies or locations.
#'
#' @param allLocations Boolean. Should all locations within colonies be loaded. Default = FALSE
#' @param loadGeometries Boolean. Should the geometries be loaded as an sf object. Default = FALSE
#'
#' @return A tibble of the metadata.colony or metadata.location table with or without sf geometry.
#' @export
#' @examples
#' \dontrun{
#' colony <- getColonies(loadGeometries = T)
#' plot(colony["colony_int_name"],
#'   pch = 16
#' )
#' }
#' @concept metadata
getColonies <- function(allLocations = FALSE,
                        loadGeometries = FALSE) {
  checkCon()

  if (allLocations) {
    locations <- dbReadTable(con, DBI::Id(schema = "metadata", table = "location"))
  } else {
    locations <- dbReadTable(con, DBI::Id(schema = "metadata", table = "colony"))
  }

  if (loadGeometries) {
    locations <- locations[!is.na(locations$geom),]
    locations <- sf::st_as_sf(coords = c("lon", "lat"), locations, remove = FALSE)
  }
  locations$geom <- NULL
  return(locations)

}
