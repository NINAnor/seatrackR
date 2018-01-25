metaRaw <- read.csv("../database_struct/Standardtabeller/metadata_sklinna_2016.csv", skip = 1,
                    fileEncoding = "windows-1252", stringsAsFactors =  F)

metaRaw <- metaRaw[1:169,]

head(metaRaw)
tail(metaRaw)
names(metaRaw)[38] <- "other"
names(metaRaw)
str(metaRaw)


metaRaw$weight <- as.numeric(metaRaw$weight)
metaRaw[c(16:19, 22)] <- sapply(metaRaw[c(16:19, 22)], as.numeric)
metaRaw[c(21, 28, 29)] <- sapply(metaRaw[c(21, 28, 29)] , as.numeric)

metaRaw$hatching_success <- as.logical(as.numeric(metaRaw$hatching_success))
metaRaw$breeding_success <- as.logical(as.numeric(metaRaw$breeding_success))
metaRaw$age <- as.numeric(metaRaw$age)

cap <- function(x) {
  paste(toupper(substring(x, 1, 1)), substring(x, 2),
        sep = "", collapse = " ")
}

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = "[- ]"), cap, USE.NAMES = !is.null(names(s)))
}

metaRaw$data_responsible <- capwords(metaRaw$data_responsible)
metaRaw$data_responsible <- gsub("Svein Håkon", "Svein-Håkon", metaRaw$data_responsible)

metaRaw$species <- sapply(metaRaw$species, cap)
metaRaw$colony <- sapply(metaRaw$colony, cap)
#require(devtools)
#?use_data_raw()
metaRaw$logger_model_retrieved[metaRaw$logger_model_retrieved == "Mk4093"] <- "mk4093"
#metaRaw$logger_model_retrieved[metaRaw$logger_model_retrieved == "Mk4083"] <- "mk4083"

#
# metaRaw$subspecies[metaRaw$subspecies == ""] <- NA
# metaRaw$sex[metaRaw$sex == ""] <- NA
# metaRaw$sexing_method[metaRaw$sexing_method == ""] <- NA
# metaRaw$logger_id_deployed[metaRaw$logger_id_deployed == ""] <- NA
# metaRaw$logger_model_deployed[metaRaw$logger_model_deployed == ""] <- NA
# metaRaw$logger_id_retrieved[metaRaw$logger_id_retrieved == ""] <- NA
# metaRaw$logger_id_retrieved[metaRaw$logger_id_retrieved == ""] <- NA
# metaRaw$breeding_success_criterion[metaRaw$breeding_success_criterion == ""] <- NA
# metaRaw$colony[metaRaw$colony == ""]
metaRaw[metaRaw == "NA"] <- NA
metaRaw[metaRaw == ""] <- NA

metaRaw$date <- as.Date(metaRaw$date, format = "%d/%m/%Y")
#metaRaw <-
metaRaw <- metaRaw[order(metaRaw$date),]
metaRaw$data_responsible[metaRaw$data_responsible == "Signe Christensen Dalsgaard"] <- "Signe Christensen-Dalsgaard"
metaRaw <-metaRaw[is.na(metaRaw$logger_id_retrieved), ] ##Remove all retrievals in this data, since none of them are deployed. We need to add some retrievals

##Make up some retrievals artificially that matches the deployments

tempRetr <- metaRaw[head(!is.na(metaRaw$logger_id_deployed), 20), ]
tempRetr$logger_id_retrieved <- tempRetr$logger_id_deployed
tempRetr$logger_model_retrieved <- tempRetr$logger_model_deployed
tempRetr$logger_id_deployed <- NA
tempRetr$logger_model_deployed <- NA
tempRetr$date <- tempRetr$date + 365


sampleMetadata <- rbind(metaRaw, tempRetr)

devtools::use_data(sampleMetadata, overwrite = T)

sampleIndividInfo <- sampleMetadata[!duplicated(sampleMetadata[c(2:3)]),c(2:3, 10, 4, 11, 12, 13:15)]
devtools::use_data(sampleIndividInfo, overwrite = T)

tempLoggers <- rbind(sampleMetadata[c(7, 6)], setNames(sampleMetadata[c(9, 8)], names(sampleMetadata[c(7, 6)])))

sampleLoggerInfo <- tempLoggers[!duplicated(tempLoggers),]
sampleLoggerInfo <- sampleLoggerInfo[sampleLoggerInfo$logger_id_retrieved != "",]
sampleLoggerInfo <- sampleLoggerInfo[!is.na(sampleLoggerInfo$logger_id_retrieved),]

sampleLoggerInfo$producer <- "Biotrack"
sampleLoggerInfo$producer[grep("c", sampleLoggerInfo$logger_model_retrieved)] <- "Migrate Technology"
sampleLoggerInfo$producer[grep("f", sampleLoggerInfo$logger_model_retrieved)] <- "Migrate Technology"
sampleLoggerInfo$producer[grep("w", sampleLoggerInfo$logger_model_retrieved)] <- "Migrate Technology"

sampleLoggerInfo$producer[grep("mk15", sampleLoggerInfo$logger_model_retrieved)] <- "BAS"
sampleLoggerInfo$logger_model_retrieved[sampleLoggerInfo$logger_model_retrieved == "Mk4083"] <- "mk4083"

sampleLoggerInfo$production_year <- 2013
sampleLoggerInfo$project <- "seatrack"
sampleLoggerInfo <- sampleLoggerInfo[c(1, 3, 4, 2, 5)]
names(sampleLoggerInfo)[c(1, 4)] <- c("logger_serial_no", "logger_model")

##On second thought, we won't write to logger_info, but include this in logger_import instead

sampleLoggerImport <- sampleLoggerInfo
sampleLoggerImport$starttime_gmt <- Sys.time()
sampleLoggerImport$logging_mode <- 1
sampleLoggerImport$started_by <- "Jens Åström"
sampleLoggerImport$started_where <- "NINA"
sampleLoggerImport$days_delayed <- 10
sampleLoggerImport$programmed_gmt_time <- Sys.time()
sampleLoggerImport$intended_species <- "Little auk"
sampleLoggerImport$intended_location <- "Bjørnøya"
sampleLoggerImport$intended_deployer <- "Vegard Sandøy Bråthen"
sampleLoggerImport$data_responsible <- "Jens Åström"
sampleLoggerImport$shutdown_session <- F
sampleLoggerImport$field_status <- NA
sampleLoggerImport$downloaded_by <- NA
sampleLoggerImport$download_date <- NA
sampleLoggerImport$download_type <- NA
sampleLoggerImport$decomissioned <- NA
sampleLoggerImport$comment <- NA

sampleLoggerImport <- sampleLoggerImport[c("logger_serial_no", "logger_model", "producer",
                                           "production_year", "project", "starttime_gmt",
                                           "logging_mode", "started_by", "started_where",
                                           "days_delayed", "programmed_gmt_time", "intended_species",
                                           "intended_location", "intended_deployer", "data_responsible",
                                           "shutdown_session", "field_status", "downloaded_by", "download_type",
                                           "download_date", "decomissioned", "comment")]


devtools::use_data(sampleLoggerImport, overwrite = T)

sampleLoggerShutdown <- sampleLoggerImport

sampleLoggerShutdown <-  sampleLoggerShutdown[sampleLoggerShutdown$logger_serial_no %in% sampleMetadata$logger_id_retrieved[!is.na(sampleMetadata$logger_id_retrieved)], ]
names(sampleLoggerShutdown)
sampleLoggerShutdown[3:15] <- NA
sampleLoggerShutdown$shutdown_session = T
sampleLoggerShutdown$download_type[1:30] <- "Successfully downloaded"
sampleLoggerShutdown$download_type[31:nrow(sampleLoggerShutdown)] <- "Nonresponsive"
sampleLoggerShutdown$field_status[1:30] <- "OK"
sampleLoggerShutdown$field_status[31:nrow(sampleLoggerShutdown)] <- "Error"
sampleLoggerShutdown$downloaded_by <- "Jens Åström"
sampleLoggerShutdown$download_date <- Sys.Date()
sampleLoggerShutdown$decomissioned <- F

devtools::use_data(sampleLoggerShutdown, overwrite = T)


sampleLoggerModels <- sampleLoggerInfo[!duplicated(sampleLoggerInfo[c(2, 4)]), c(2, 4)]
names(sampleLoggerModels) <- c("producer", "model")
devtools::use_data(sampleLoggerModels, overwrite = T)

tmpLoggerInfo <- dbGetQuery(con, "SELECT * FROM loggers.logger_info")
sampleLoggerImport<- tmpLoggerInfo["logger_id"]
sampleLoggerImport$startdate_gmt <- Sys.Date()
sampleLoggerImport$starttime_gmt <- Sys.time()
sampleLoggerImport$logging_mode <- "testmode"
sampleLoggerImport$started_by <- "Jens Åström"
sampleLoggerImport$started_where <- "NINA"
sampleLoggerImport$days_delayed <- 0
sampleLoggerImport$programmed_gmt_date <- Sys.Date()
sampleLoggerImport$programmed_gmt_time <- Sys.time()

DBI::dbSendQuery(con, "SET search_path TO imports, public")
DBI::dbWriteTable(con, "logger_import", sampleLoggerImport, append = T, overwrite = F)

 # oldLoggerInfo <- DBI::dbGetQuery(con, "SELECT * FROM loggers.logger_info")
 # newLoggerInfo <- anti_join(sampleLoggerInfo, oldLoggerInfo)
 # writeLoggerInfo(newLoggerInfo)

##Add this function
compareNA <- function(v1,v2) {
  # This function returns TRUE wherever elements are the same, including NA's,
  # and false everywhere else.
  same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}



metadata <- metaRaw
# metadata <- metadata[!compareNA(metadata$logger_id_retrieved, "v2014037"),]
# metadata <- metadata[!compareNA(metadata$logger_id_retrieved, "v2014025"),]
# metadata <- metadata[!compareNA(metadata$logger_id_retrieved, "c406"),]
# metadata <- metadata[!compareNA(metadata$logger_id_retrieved, "C406"),]
# metadata <- metadata[!compareNA(metadata$logger_id_retrieved, "C415"),]
# metadata <- metadata[!compareNA(metadata$logger_id_retrieved, "C393"),]


#No loggers retrieved after deployment in this data set.
##Test setting retrieval date one year later

##add hoc to compensate for earlier insert
metadata <- metadata[-which(metadata$logger_id_deployed %in% c("T089", "B1263")), ]

metaRetr <- metaRaw[metaRaw$logger_id_retrieved %in% retr$logger_id_retrieved,]
#metaRetr$date <-
metaRetr$date <- metaRetr$date + 365
metaRetr$logger_id_deployed <- NA
metaRetr$logger_model_deployed <- NA


writeMetadata(metadata)
writeMetadata(metaRetr)
