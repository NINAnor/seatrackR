#' Retrieve info on the years where we have position data
#'
#' This lists the available years and the abbreviation used to identify them, for example in the postable.
#'
#' @return A tibble of the years represented in the database
#' @export
#' @examples
#' \dontrun{
#' getYears()
#' }
getYears <- function() {
  checkCon()

  yearsQ <- "SELECT distinct year_tracked
            FROM positions.postable"

  years <- DBI::dbGetQuery(con, yearsQ)

  out <- dplyr::as_tibble(years)

  return(out)
}
