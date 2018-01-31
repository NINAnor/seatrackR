## ----setup, include = FALSE-------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  tidy = T
)
options(width = 60)

## ---- eval = F--------------------------------------------
#  devtools::install_github("NINAnor/seatrack-db/seatrackR")

## ----connect, message=FALSE-------------------------------
library(seatrackR)
connectSeatrack(Username = "testwriter", Password = "testwriter")

library(tidyverse)

## ----disconnect, error = T--------------------------------

disconnectSeatrack()

seatrackR:::checkCon() ##produces error if not connected

connectSeatrack(Username = "testwriter", Password = "testwriter")

seatrackR:::checkCon() ##returns nothing if the connection exists


## ---------------------------------------------------------
head(sampleLoggerImport)

## ---------------------------------------------------------
noStartups <- sampleLoggerImport %>% 
  summarize("no_startups" = sum(!is.na(starttime_gmt)))
noStartups

## ---------------------------------------------------------
writeLoggerImport(sampleLoggerImport)

## ---------------------------------------------------------
loggerInfo <- getLoggerInfo() # This reads from the loggers.logger_info table
loggerInfo

## ---------------------------------------------------------
activeSessions <- getActiveSessions() # This reads from the table loggers.logging_session. 
activeSessions


## ---------------------------------------------------------
activeSessions %>% 
    summarise("no_deployed" = sum(!is.na(deployment_id)), 
              "no_retrieved" = sum(!is.na(retrieval_id)))

## ---------------------------------------------------------
head(sampleMetadata)

## ---------------------------------------------------------
noDepRetr <- sampleMetadata %>% 
  summarise("noDeployments" = sum(!is.na(logger_id_deployed)), 
            "noRetrievals" = sum(!is.na(logger_id_retrieved)))
noDepRetr

## ---- include = F-----------------------------------------

sampleMetadata$data_responsible[20] <- "Alkekungen himself"
sampleMetadata$logger_id_retrieved[103:105] <- "scraped off!"


## ---------------------------------------------------------
myErrors <- checkMetadata(sampleMetadata)

## ----errorPlot--------------------------------------------
plot(myErrors)

## ---------------------------------------------------------
summary(myErrors)

## ---------------------------------------------------------
myErrors

## ---------------------------------------------------------
ringsOfErrors <- sampleMetadata$ring_number[103:105]
sampleMetadata[sampleMetadata$ring_number %in% ringsOfErrors, ]


## ---------------------------------------------------------
sampleMetadata$logger_id_retrieved[103:105] <- c("Z231", "Z236", "Z234")  

## ---------------------------------------------------------
sampleMetadata %>% 
  select(date, colony, species, data_responsible) %>% 
  filter(row_number() %in% 18:22)

##Looks like it should be Svein-Håkon
sampleMetadata$data_responsible[20] <- sampleMetadata$data_responsible[19]

## ---------------------------------------------------------
myErrors <- checkMetadata(sampleMetadata)

## ---------------------------------------------------------
writeMetadata(sampleMetadata)

## ---------------------------------------------------------
activeSessions <- getActiveSessions()


activeSessions %>% 
    summarise("no_deployed" = sum(!is.na(deployment_id)), 
              "no_retrieved" = sum(!is.na(retrieval_id)))

## ---------------------------------------------------------
activeSessions %>% 
  filter(!is.na(retrieval_id))

## ---------------------------------------------------------
sampleLoggerShutdown


## ---------------------------------------------------------
sampleLoggerShutdown %>% 
  select(logger_serial_no, logger_model, shutdown_session:comment)

## ---------------------------------------------------------
downloadTypes <- sampleLoggerShutdown %>% 
  group_by(download_type) %>% 
  tally()

## ---------------------------------------------------------
writeLoggerImport(sampleLoggerShutdown)

## ---------------------------------------------------------
activeSessions <- getActiveSessions()
activeSessions

## ---------------------------------------------------------
fileArchive <- getFileArchive()

fileArchive

## ---------------------------------------------------------
fileArchive %>% 
  group_by(logger_serial_no, logger_model) %>% 
  tally() %>%  
  group_by(logger_model) %>% 
  summarise(mean(n)) 

## ---------------------------------------------------------
fileArchive %>% 
  summarise("noShutdownLoggers" = n_distinct(logger_serial_no, logger_model))

