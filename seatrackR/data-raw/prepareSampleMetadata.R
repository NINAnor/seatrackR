metaRaw <- read.csv("../database_struct/Standardtabeller/metadata_sklinna_2016.csv", skip = 1,
                    fileEncoding = "windows-1252", stringsAsFactors =  F)

metaRaw <- metaRaw[-nrow(metaRaw),]
head(metaRaw)
names(metaRaw)[38] <- "other"
names(metaRaw)
str(metaRaw)

metaRaw$weight <- as.numeric(metaRaw$weight)
metaRaw[c(16:19, 22)] <- sapply(metaRaw[c(16:19, 22)], as.numeric)
metaRaw[c(21, 28, 29)] <- sapply(metaRaw[c(21, 28, 29)] , as.numeric)
metaRaw$date <- as.Date(metaRaw$date, format = "%d/%m/%Y")
metaRaw$hatching_success <- as.logical(as.numeric(metaRaw$hatching_success))
metaRaw$breeding_success <- as.logical(as.numeric(metaRaw$breeding_success))
metaRaw$back_on_nest[metaRaw$back_on_nest == ""] <- NA
metaRaw$age <- as.numeric(metaRaw$age)

cap <- function(x) {
  paste(toupper(substring(x, 1, 1)), substring(x, 2),
        sep = "", collapse = " ")
}

metaRaw$species <- sapply(metaRaw$species, cap)
#require(devtools)
#?use_data_raw()
metaRaw$logger_model_retrieved[metaRaw$logger_model_retrieved == "Mk4093"] <- "Mk4083"


metaRaw$subspecies[metaRaw$subspecies == ""] <- NA
metaRaw$sex[metaRaw$sex == ""] <- NA
metaRaw$sexing_method[metaRaw$sexing_method == ""] <- NA

sampleMetadata <- metaRaw
devtools::use_data(sampleMetadata, overwrite = T)

sampleIndividInfo <- sampleMetadata[!duplicated(sampleMetadata[c(2:3)]),c(2:3, 10, 4, 11, 12, 13:15)]
devtools::use_data(sampleIndividInfo, overwrite = T)

sampleLoggerInfo <- sampleMetadata[!duplicated(sampleMetadata[c(7, 6)]), c(7, 6)]
sampleLoggerInfo <- sampleLoggerInfo[sampleLoggerInfo$logger_id_retrieved != "",]
sampleLoggerInfo$producer <- "Biotrack"
sampleLoggerInfo$producer[grep("c", sampleLoggerInfo$logger_model_retrieved)] <- "Migrate Technology"
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

