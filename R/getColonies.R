#' Retrieve info on the registered colonies and locations within colonies in the database
#'
#' This function either reads from the metadata.colony or the metadata.location table, depending on the parameter allLocations.
#' If
#'
#' @param allLocations True, False. Should all locations within colonies be loaded. Default = False.
#' @param loadGeometries True, False. Should the geometries be loaded as an sf object. Default = False.
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
