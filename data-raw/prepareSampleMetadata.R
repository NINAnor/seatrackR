# For now, this is a mishmash of the old sample pos data, with the sessions from the sample metadata so it can actually be used.

samplePosData <- read.csv(system.file(file.path("csv", "sample_pos_data.csv"), package = "seatrackR"))

usethis::use_data(samplePosdata, overwrite = TRUE)
