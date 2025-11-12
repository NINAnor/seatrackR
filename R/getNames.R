#' Retrieve info on the registered names (people) in the database
#'
#' The database only accepts people names that are registered in the "metadata.people" table. This should contain all people that are relevant to the project.
#'
#'
#' @param asTibble Return the result as a tibble? Boolean
#' @return A tibble of the people id, names and abbreviated names registered in the people table.
#' @export
#' @examples
#' \dontrun{
#' getNames()
#' }


getNames <- function(asTibble = FALSE){

  checkCon()

  res <- dplyr::tbl(con, dbplyr::in_schema("metadata", "people"))

  res <- res %>%
    select(person_id,
           name,
           abbrev_name = abrev_name)

  if(asTibble){
    res <- res  %>% as_tibble()
  }

  return(res)
}





