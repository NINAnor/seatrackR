#' checkMetadata before import
#'
#' This is a collection of functions to check the integrity of the metadata table before importing it.
#'
#'
#' @param myTable
#'
#' @return Various errors.
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' myCheck <- checkMetadata(sampleMetadata)
#' plot(myCheck) #quickly see how many problems there are
#' myCheck # check the print function for a complete list of the errors
#'
#' #Or run a single test separately
#' checkOpenSession(sampleMetadata)
#' }


checkMetadata <- function(myTable){
  seatrackR:::checkCon()
  sessionErrors <- checkOpenSession(myTable)
  loggerErrors <- checkLoggers(myTable)
  nameErrors <- checkNames(myTable)

  allErrors <- list(sessionErrors, loggerErrors, nameErrors)
  class(allErrors) <- c("metadataErrors", "list")


  if(length(unlist(allErrors)) == 0) {
    message("No errors found")
  } else {
    message("Errors found!")
  }

  return(allErrors)
}

#' @describeIn checkMetadata Check loggers to be deployed or retrieved is in an open logging session
#' @export
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

#' @describeIn checkMetadata Check if loggers are registered in the loggers.logger_info table
#' @export
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


#' @describeIn checkMetadata Check if names in data_responsible exists in the metadata.people table.
#' @export
#'
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

#' @export
print.metadataErrors <- function(x){

  if (length(unlist(x)) == 0){
    cat("No errors found (through the available checking functions)")
  } else

  if(nrow(x[[1]][[1]]) > 0){
    cat("These loggers are not in an open logging session, but metadata contains deployment info.\nStart a new logging session with writeLoggerImport() before importing deployment info.\n")
    print(x[[1]][[1]])
  }

  if(nrow(x[[1]][[2]]) > 0){
    cat("\n")
    cat("These loggers are not in an open logging session, but metadata contains retrieval info.\nStart a new logging session with writeLoggerImport(), and add deployment info before importing retrieval info.\n")
    print(x[[1]][[2]])
  }

  if(nrow(x[[2]][[1]]) > 0){
    cat("\n")
    cat("These loggers are not registered in the table loggers.logger_info, but metadata contains deployment info.\nRegister the loggers with writeLoggerImport() before importing deployment info.\n")
    print(x[[2]][[1]])
  }

  if(nrow(x[[2]][[2]]) > 0){
    cat("\n")
    cat("These loggers are not registered in the table loggers.logger_info, but metadata contains retrieval info.\nRegister the loggers with writeLoggerImport(), and add deployment info before importing retrieval info.\n")
    print(x[[2]][[2]])
  }

  if(nrow(x[[3]][[1]]) > 0){
    cat("\n")
    cat("These names are not in the table metadata.people. Check spelling and compare with getNames().\n")
    print(x[[3]][[1]])

  }

}

#' @export
plot.metadataErrors <- function(x, ...){
  if(length(unlist(x)) == 0) {
    plot(1:10, type = "n", xaxt = "n", yaxt = "n", ylab = "", xlab = "")
    text(6, 5, labels = "No errors found \n(through the available checking functions)")
  } else{
    toPlot <- tibble("reason" = unlist(lapply(x, names)),
                     "errorCount" = c(unlist(lapply(x[[1]], nrow)),
                                      unlist(lapply(x[[2]], nrow)),
                                      unlist(lapply(x[[3]], nrow))))

    ggplot2::ggplot(toPlot) +
      ggplot2::geom_bar(mapping = aes(x = reason, y = errorCount, fill = reason), stat = "identity") +
      ggplot2::theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank()) +
      ggplot2::ggtitle("Number of errors in metadata")

  }

}


#' @export
summary.metadataErrors <- function(x, ...){

    out <- tibble("reason" = unlist(lapply(x, names)),
                     "errorCount" = c(unlist(lapply(x[[1]], nrow)),
                                      unlist(lapply(x[[2]], nrow)),
                                      unlist(lapply(x[[3]], nrow))))

  return(out)

}


