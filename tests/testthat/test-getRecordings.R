get_recording_expected <- function(type){
    if(type == "light"){
        return(c(
            session_id = "character",
            individ_id = "character",
            date_time = "POSIXct",
            raw_light = "numeric",
            std_light = "numeric"
        ))        
    }else if(type == "temperature"){
        return(c(
            session_id = "character",
            individ_id = "character",
            date_time = "POSIXct",
            wet_temp_min = "numeric",
            wet_temp_max = "numeric",
            wet_temp_mean = "numeric",
            num_samples = "integer"
        ))
    }else if (type == "activity"){
        return(c(
            session_id = "character",
            individ_id = "character",
            date_time = "POSIXct",
            conductivity = "numeric",
            std_conductivity = "numeric"
        ))
    }
    stop("Unnown recording type")
}

for(type in c("light", "temperature", "activity")){
    test_that(paste("getRecordings() returns", type, "data"), {
        skip_if_no_test_db()

        recording_data <- getRecordings(type = type)
        expected <- get_recording_expected(type = type)

        # Check column names and order
        expect_identical(names(recording_data), names(expected))

        #Check column classes
        actual <- vapply(recording_data, function(x) class(x)[1], character(1))
        expect_identical(actual, expected)

    })
}

