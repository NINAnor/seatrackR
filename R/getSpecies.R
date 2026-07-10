#' Retrieve info on the registered species in the database
#'
#' @param include_subspecies Include subspecies in the output? Boolean
#'
#' @return A tibble of the metadata.subspecies table
#' @export
#' @examples
#' \dontrun{
#' getSpecies()
#' }
#' @concept metadata
getSpecies <- function(include_subspecies = FALSE) {
  checkCon()

  if (check_db_version() >= 60 && include_subspecies) {
    species <- dbReadTable(con, DBI::Id(schema = "metadata", table = "all_species"))
  } else {
    species <- dbReadTable(con, DBI::Id(schema = "metadata", table = "species"))
  }

  return(species)
}
