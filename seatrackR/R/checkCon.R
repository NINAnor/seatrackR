#' Check valid seatrack database connection
#'
#' Internal function
#'
checkCon <- function() {if(!exists("con")){ stop("No connection, run connectSeatrac()")} else{
  if(class(con)!= "PqConnection"){ stop("\"con\" is not of class \"PqConnection\". Have you run connectSeatrac()?")}
  if(!DBI::dbIsValid(con)) { stop("No connection, run connectSeatrac()")}
  }
}
