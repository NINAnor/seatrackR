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
metaRaw$back_on_nest[metaRaw$back_on_nest == ""] <- NA
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

metaRaw[metaRaw == ""] <- NA

metaRaw$date <- as.Date(metaRaw$date, format = "%d/%m/%Y")

sampleMetadata <- metaRaw
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
devtools::use_data(sampleLoggerInfo, overwrite = T)

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
