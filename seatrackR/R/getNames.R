#' Retrieve info on the registered names (people) in the database
#'
#' The database only accepts people names that are registered in the "metadata.people" table. This should contain all people that are relevant to the project.
#'
#'
#'
#' @return A tibble of the people id, names and abbreviated names registered in the people table.
#' @export
#' @examples
#' dontrun{
#' getNames()
#' }


getNames <- function(){
  checkCon()

  people <- dbReadTable(con, DBI::Id(schema = "metadata", table = "people"))

  out <- as_tibble(people) %>%
    select(person_id,
           name,
           abbrev_name = abrev_name)

  return(out)
}


#fileStatus <- listFileArchive()





