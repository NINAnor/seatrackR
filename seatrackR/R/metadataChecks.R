#
# compareNA <- function(v1,v2) {
#   same <- (v1 == v2) | (is.na(v1) & is.na(v2))
#   same[is.na(same)] <- FALSE
#   return(same)
# }


checkOpenSession <- function(myTable){
  seatrackR:::checkCon()

  activeSessions <- DBI::dbGetQuery(con,
             "SELECT li.logger_serial_no, li.logger_model
              FROM loggers.logging_session ls, loggers.logger_info li
              WHERE li.logger_id = ls.logger_id
              AND ls.active IS True")


  whichDepNotActive <- !(myTable$logger_id_deployed %in% activeSessions$logger_serial_no & myTable$logger_model_deployed %in% activeSessions$logger_model)
  whichRetrNotActive <- !(myTable$logger_id_retrieved %in% activeSessions$logger_serial_no & myTable$logger_model_retrieved %in% activeSessions$logger_model)

  deployedNotActive <- myTable$logger_id_deployed[whichDepNotActive]
  retrievedNotActive <- myTable$logger_id_retrieved[whichRetrNotActive]

  out <- list()

  out$deployedNotActive <- data.frame("row_number" = which(whichDepNotActive)[!is.na(deployedNotActive)], "logger_serial_no" = deployedNotActive[!is.na(deployedNotActive)])
  out$retrievedNotActive <- data.frame("row_number" = which(whichRetrNotActive)[!is.na(retrievedNotActive)], "logger_serial_no" = retrievedNotActive[!is.na(retrievedNotActive)])
  return(out)
  }


checkLoggers <- function(myTable){
  seatrackR:::checkCon()

  registeredLoggers <- DBI::dbGetQuery(con,
                                    "SELECT * FROM loggers.logger_info")


  whichDepNotReg <- !(myTable$logger_id_deployed %in% registeredLoggers$logger_serial_no & myTable$logger_model_deployed %in% registeredLoggers$logger_model)
  whichRetrNotReg <- !(myTable$logger_id_retrieved %in% registeredLoggers$logger_serial_no & myTable$logger_model_retrieved %in% registeredLoggers$logger_model)

  deployedNotReg <- myTable$logger_id_deployed[whichDepNotReg]
  retrievedNotReg <- myTable$logger_id_retrieved[whichRetrNotReg]

  out <- list()

  out$deployedNotReg <- data.frame("row_number" = which(whichDepNotReg)[!is.na(deployedNotReg)], "logger_serial_no" = deployedNotReg[!is.na(deployedNotReg)])
  out$retrievedNotReg <- data.frame("row_number" = which(whichRetrNotReg)[!is.na(retrievedNotReg)], "logger_serial_no" = retrievedNotReg[!is.na(retrievedNotReg)])
  return(out)
}



checkNames <- function(myTable){
  seatrackR:::checkCon()

  presentNames <- DBI::dbGetQuery(con,
                                    "SELECT * FROM metadata.people")

  whichPeopleNotPresent <- !(myTable$data_responsible %in% presentNames$name)

  peopleNotPresent <- myTable$data_responsible[whichPeopleNotPresent]

  out <- list()
  out$peopleNotPresent <- data.frame("row_number" = which(whichPeopleNotPresent), "name" = peopleNotPresent)

  return(out)
}
