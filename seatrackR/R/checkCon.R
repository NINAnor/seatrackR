#' Internal functions
#'
#'
#'

checkCon <- function() {if(!exists("con")){ stop("No connection, run connectSeatrack()")} else{
  if(class(con)!= "PqConnection"){ stop("\"con\" is not of class \"PqConnection\". Have you run connectSeatrack()?")}
  if(!DBI::dbIsValid(con)) { stop("No connection, run connectSeatrack()")}
  }
}


compareNA <- function(v1,v2) {
  # This function returns TRUE wherever elements are the same, including NA's,
  # and false everywhere else.
  same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}
