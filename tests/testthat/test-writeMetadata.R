test_that("writeMetdata can write data", {
    skip_if_no_test_db()
    set.seed(123)

    test_startup_data <- data.frame(
        logger_serial_no = paste0("testLogger", c(1:5)),
        logger_model = c("c65", "c65", "c65", "c65", "c65"),
        producer = rep("Migrate Technology", 5),
        production_year = rep(2013, 5),
        project = rep("seatrack", 5),
        starttime_gmt = as.Date(rep("2016-01-01", 5)),
        logging_mode = rep(1, 5),
        started_by = rep("Jens Åström", 5),
        started_where = rep("NINA", 5),
        days_delayed = rep(10, 5),
        programmed_gmt_time = as.Date(rep("2016-01-03", 5)),
        intended_species = rep("Little auk", 5),
        intended_location = rep("Bjørnøya", 5),
        intended_deployer = rep("Vegard Sandøy Bråthen", 5),
        shutdown_session = rep(FALSE, 5),
        shutdown_date = as.Date(rep(NA, 5)),
        field_status = rep(NA_character_, 5),
        downloaded_by = rep(NA_character_, 5),
        download_type = rep(NA_character_, 5),
        download_date = as.Date(rep(NA, 5)),
        decomissioned = rep(NA, 5),
        comment = rep(NA_character_, 5),
        stringsAsFactors = FALSE
    )

    test_deployment_data <- data.frame(
        date = as.Date(rep("2016-01-07", 5)),
        ring_number = paste0(
            "TEST_RING_",
            sample(100000:999999, nrow(test_startup_data))
        ),
        euring_code = rep("NOS", 5),
        color_ring = NA_character_,
        logger_status = rep("individual caught (first deployment)", 5),
        logger_model_retrieved = NA_character_,
        logger_id_retrieved = NA_character_,

        # Derived from startup data
        logger_model_deployed = test_startup_data$logger_model,
        logger_id_deployed = test_startup_data$logger_serial_no,
        species = test_startup_data$intended_species,
        morph = NA_character_,
        subspecies = NA_character_,
        age = NA_character_,
        sex = rep("unknown", 5),
        sexing_method = rep("none_yet", 5),
        weight = c(400, 390, 470, 420, 410),
        scull = c(77.4, 76.1, 81.4, 76.2, 78.0),
        tarsus = NA_real_,
        wing = c(167, 172, 169, 166, 170),
        breeding_stage = rep("breeding/stage_unknown", 5),
        eggs = NA_integer_,
        chicks = NA_integer_,
        hatching_success = NA,
        breeding_success = NA,
        breeding_success_criterion = NA_character_,
        country = rep("norway", 5),

        # Derived from startup data
        colony = test_startup_data$intended_location,
        colony_latitude = rep(65.202, 5),
        colony_longitude = rep(10.995, 5),
        nest_id = NA_character_,
        blood_sample = rep(
            "yes, blood was sampled for different reasons - results can/may be accessed by SEATRACK",
            5
        ),
        feather_sample = rep(
            "yes, feathers was sampled for SEATRACK/ARCTOX-full sample(body, head (alcids), sexing)",
            5
        ),
        other_samples = NA_character_,
        data_responsible = rep("Svein-Håkon Lorentsen", 5),
        back_on_nest = NA,
        logger_mount_method = rep("tarsus", 5),
        comment = rep("Blood for DNA", 5),
        other = c(
            "Culm 45,2, Gonys 33,7",
            "Culm 46,0, Gonys 31,3",
            "Culm 46,0, Gonys 36,2",
            "Culm 43,7, Gonys 37,6",
            "Culm 44,5, Gonys 35,0"
        ),
        old_ring_number = NA_character_,
        stringsAsFactors = FALSE
    )

    # Ensure cleanup happens even if test fails
    withr::defer({
        print("Clean up test records")
        # Delete deployment records
        DBI::dbExecute(
            con,
            "DELETE FROM loggers.startup WHERE session_id LIKE 'testLogger_%'"
        )
        # Delete logger records
        DBI::dbExecute(
            con,
            "DELETE FROM loggers.logger_info WHERE logger_serial_no LIKE 'testLogger_%'"
        )
        # Delete remaining individual records
        DBI::dbExecute(
            con,
            "DELETE FROM individuals.individ_info WHERE ring_number LIKE 'TEST_RING_%'"
        )
    })

    sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))
    loggers <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logger_info"))
    deployments <- dplyr::tbl(con, dbplyr::in_schema("loggers", "deployment"))
    sessions <- dplyr::left_join(sessions, loggers, by = "logger_id")
    status <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_status"))
    info <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_info"))

    test_that("writeMetdata can start loggers", {
        logger_result <- writeLoggerImport(test_startup_data)
        expect_true(logger_result)

        filtered_sessions <- dplyr::filter(
            sessions,
            logger_serial_no %in% test_startup_data$logger_serial_no,
        )
        expect_true(dplyr::tally(filtered_sessions) %>% pull(n) == nrow(test_startup_data))
    })

    test_that("writeMetdata can deploy loggers", {
        metadata_result <- writeMetadata(test_deployment_data)
        expect_true(metadata_result)

        filtered_sessions <- dplyr::filter(
            sessions,
            logger_serial_no %in% test_deployment_data$logger_id_deployed,
            !is.na(deployment_id)
        )
        expect_true(dplyr::tally(filtered_sessions) %>% pull(n) == nrow(test_deployment_data))
    })

    test_that("writeMetdata can retrieve loggers", {
        regular_shutdown <- test_deployment_data[1, ]
        regular_shutdown$logger_model_retrieved <- regular_shutdown$logger_model_deployed
        regular_shutdown$logger_model_deployed <- NA
        regular_shutdown$logger_id_retrieved <- regular_shutdown$logger_id_deployed
        regular_shutdown$logger_id_deployed <- NA
        retrieval_result <- writeMetadata(regular_shutdown)
        expect_true(retrieval_result)

        # Check if the session is retrieved
        filtered_sessions <- dplyr::filter(
            sessions,
            logger_serial_no == regular_shutdown$logger_id_retrieved,
            !is.na(retrieval_id)
        )
        expect_true(dplyr::tally(filtered_sessions) %>% pull(n) == 1)
    })

    test_that("writeMetdata can retrieve sessions with a ring change", {
        if(check_db_version() < 41){
            testthat::skip()
        }
        new_ring_shutdown <- test_deployment_data[2, ]
        new_ring_shutdown$logger_model_retrieved <- new_ring_shutdown$logger_model_deployed
        new_ring_shutdown$logger_model_deployed <- NA
        new_ring_shutdown$logger_id_retrieved <- new_ring_shutdown$logger_id_deployed
        new_ring_shutdown$logger_id_deployed <- NA

        new_ring_shutdown$old_ring_number <- new_ring_shutdown$ring_number
        new_ring_shutdown$ring_number <- paste0(new_ring_shutdown$ring_number,"_NEW")

        retrieval_result <- writeMetadata(new_ring_shutdown)
        expect_true(retrieval_result)

        # check session is closed
        # Check if the session is retrieved
        filtered_sessions <- dplyr::filter(
            sessions,
            logger_serial_no == new_ring_shutdown$logger_id_retrieved,
            !is.na(retrieval_id)
        )
        expect_true(dplyr::tally(filtered_sessions) %>% pull(n) == 1)

        # Check that both rings exist in the status table under the same ID
        filtered_status <- dplyr::filter(status, 
            ring_number %in% c(new_ring_shutdown$old_ring_number, new_ring_shutdown$ring_number)
            ) 
        expect_true(dplyr::tally(filtered_status) %>% pull(n) == 2)
        
        individual_id <- dplyr::distinct(filtered_status, info_id)%>% dplyr::pull(info_id)

        expect_true(length(individual_id) == 1)
        
        # Check that the individual ID is still the same
        filtered_info <- dplyr::filter(info, id == individual_id)%>% dplyr::collect()
        # But the latest ring is stored
        expect_true(new_ring_shutdown$ring_number == filtered_info$ring_number)
        expect_false(paste(new_ring_shutdown$ring_number, new_ring_shutdown$euring_code, sep = "_") == filtered_info$individ_id)
    })

    # Shutdowns
    test_that("Sessions can be shut down", {
        test_shutdown_data <- test_startup_data[1:2, ]
        test_shutdown_data$download_date <- test_shutdown_data$shutdown_date <- test_shutdown_data$starttime_gmt + 1
        test_shutdown_data$download_type <- "Successfully downloaded"
        test_shutdown_data$shutdown_session <- TRUE
        test_shutdown_data$intended_species <- NA
        logger_result <- writeLoggerImport(test_shutdown_data)
        expect_true(logger_result)
    })

    test_that("Non deployment/retrieval statuses can fall within a session", {
        if(check_db_version() < 41){
            testthat::skip()
        }
        regular_status <- test_deployment_data[3, ]
        regular_status$logger_model_deployed <- NA
        regular_status$logger_id_deployed <- NA
        regular_status$sex <- "female"
        regular_status$sexing_method <- "dna"
        status_results <- writeMetadata(regular_status)
        expect_true(status_results)

        #check the status exists and is in the correct session
        filtered_status <- dplyr::filter(status, sex == "female", ring_number == regular_status$ring_number)
        expect_true(dplyr::tally(filtered_status) %>% dplyr::pull(n) == 1)
        status_session_id <- dplyr::pull(filtered_status, session_id)
        deployment_date <- dplyr::filter(sessions, session_id == status_session_id) %>% 
            dplyr::left_join(deployments, by = dplyr::join_by(deployment_id == deployment_id))%>%dplyr::pull(deployment_date)
        expect_true(deployment_date == test_deployment_data[3, ]$date)
        #check the info has the latest sex
        individual_id <- dplyr::distinct(filtered_status, info_id)%>% dplyr::pull(info_id)
        filtered_info <- dplyr::filter(info, id == individual_id)%>% dplyr::collect()
        expect_true(filtered_info$sex == "female")
    })

    test_that("Non deployment/retrieval statuses can fall outside a session", {
        outside_status <- test_deployment_data[1, ]
        outside_status$logger_model_deployed <- NA
        outside_status$logger_id_deployed <- NA
        outside_status$sex <- "female"
        outside_status$sexing_method <- "dna"
        outside_status$date <- outside_status$date + 4
        status_results <- writeMetadata(outside_status)
        expect_true(status_results)

        # check the status exists and is in the correct session
        filtered_status <- dplyr::filter(status, sex == "female", ring_number == outside_status$ring_number)
        expect_true(dplyr::tally(filtered_status) %>% dplyr::pull(n) == 1)
        status_session_id <- dplyr::pull(filtered_status, session_id)
        expect_true(is.na(status_session_id))
        # check the info has the latest sex
        individual_id <- dplyr::distinct(filtered_status, info_id) %>% dplyr::pull(info_id)
        filtered_info <- dplyr::filter(info, id == individual_id) %>% dplyr::collect()
        expect_true(filtered_info$sex == "female")
    })
})

