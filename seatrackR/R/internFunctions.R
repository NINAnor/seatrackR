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

passEnv <- new.env()


.getFtpUrl <- function(){
  checkCon()

  password = get(".pass", envir = passEnv)
  current_user <- DBI::dbGetQuery(con, "SELECT current_user")

  pwd <- paste0(password, current_user)

  pwd <- paste0(current_user, ":", pwd)

  url <- "ftp://seatrack.nina.no"

  out <- list("url" = url,
              "pwd" = pwd)
  return(out)

}

# .getFtpUrl <- function(write = F){
#   checkCon()
#
#   if(write == T){
#     current_user <- DBI::dbGetQuery(con, "SELECT current_user")
#
#     current_roles <- DBI::dbGetQuery(con, paste0("select rolname from pg_user
#                                                  join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
#                                                  join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
#                                                  where
#                                                  pg_user.usename = '", current_user, "'"))
#
#   if(!("admin" %in% current_roles)) stop("Connected user needs to be part of admin group")
#
#   pwd <- DBI::dbGetQuery(con, "SELECT pwd from restricted.write WHERE name = 'ftp.nina.no'")
#
#   pwd <- paste0("ftp.nina.no|ftpintern:", pwd)
#
#   url <- "ftp://ftp.nina.no/Download/Seatrack/"
#
#   out <- list("url" = url,
#               "pwd" = pwd)
#
#   return(out)
#   }
#
#   if(write == F) {
#
#     pwd <- DBI::dbGetQuery(con, "SELECT pwd from restricted.read WHERE name = 'ftp.nina.no'")
#
#     pwd <- paste0("ftp.nina.no|ftpekstern:", pwd)
#
#     url <- "ftp://ftp.nina.no/Download/Seatrack/"
#
#     out <- list("url" = url,
#                 "pwd" = pwd)
#     return(out)
#   }
#
# }


reakHavoc <- function(){

  checkCon()

  answer <- menu(c("Yes (1)", "No (2)"), title ="You are about to delete all logger records!!! Are you sure?")

  havoc1 <- "TRUNCATE TABLE loggers.logger_info RESTART IDENTITY CASCADE;"
  havoc2 <- "TRUNCATE TABLE individuals.individ_info RESTART IDENTITY CASCADE;"



  if(answer == 1){
    dbSendStatement(con, havoc1)
    dbSendStatement(con, havoc2)
    return("Things are gone, database should be clean!")
    } else return("Nothing")

}
