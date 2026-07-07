test_that("Can write data", {
    skip_if_no_test_db()
    set.seed(123)

    test_gps_gsm_data <- # Create test GPS data
        data.frame(
            device_id = rep("testLogger_gps_gsm1", 1),
            UTC_datetime = as.POSIXct(
                c(
                    "2026-06-10 17:40:55",
                    "2026-06-11 09:05:11",
                    "2026-06-11 09:17:20"
                ),
                tz = "UTC"
            ),
            UTC_date = as.Date(c(
                "2026-06-10",
                "2026-06-11",
                "2026-06-11"
            )),
            UTC_time = c(
                "17:40:55",
                "09:05:11",
                "09:17:20"
            ),
            datatype = c("GPS", "GPS", "GPS"),
            satcount = c(0, 8, 8),
            U_bat_mV = c(4159, 4151, 4156),
            bat_soc_pct = c(100, 100, 100),
            solar_I_mA = c(0, 0, 7),
            hdop = c(0.0, 2.0, 1.8),
            Latitude = c(
                0.000000000000000,
                59.863781000000003,
                59.865036000000003
            ),
            Longitude = c(
                0.000000000000000,
                10.716355000000000,
                10.718146000000001
            ),
            Altitude_m = c(0, 3, 11),
            speed_km_h = c(0, 0, 23),
            direction_deg = c(0, 0, 140),
            temperature_C = c(24, 21, 24),
            mag_x = c(6, -765, -337),
            mag_y = c(-21, -321, -276),
            mag_z = c(-25, -90, -175),
            acc_x = c(-7, 215, -27),
            acc_y = c(45, -238, 505),
            acc_z = c(970, 916, 1065)
        )

    test_gps_data <- data.frame(
        tag_id = rep("testLogger_gps1", 6),
        date_time = as.POSIXct(
            c(
                "2026-05-24 17:24:08",
                "2026-05-24 17:29:08",
                "2026-05-24 17:34:13",
                "2026-05-24 17:39:08",
                "2026-05-24 17:44:04",
                "2026-05-24 17:49:03"
            ),
            tz = "UTC"
        ),
        day_second = c(62648.06, 62948.12, 63253.25, 63548.11, 63844.37, 64143.89),
        n_satellites = c(5, 5, 5, 5, 8, 7),
        latitude = c(64.74170, 64.74242, 64.74225, 64.74234, 64.73815, 64.73698),
        longitude = c(10.77379, 10.77436, 10.77412, 10.77412, 10.77891, 10.77953),
        altitude = c(132.25, 71.25, 58.25, 57.50, 56.00, 48.75),
        clock_offset = c(9999.999, 4.690, 4.630, 4.700, 4.775, 4.815),
        accuracy = c(
            9.212300e-07,
            7.796080e-07,
            5.518100e-08,
            2.975290e-07,
            4.370963e-06,
            3.682506e-06
        ),
        battery = c(4.08, 4.08, 4.08, 4.08, 4.10, 4.08),
        filename = rep("BLK_SG_2026_TagtestLogger_gps1.pos", 6),
        stringsAsFactors = FALSE
    )

    test_gps_wet_data <- data.frame(
        tag_id = rep("testLogger_gps1", 6),
        date_time = as.POSIXct(
            c(
                "2026-07-10 12:50:28",
                "2026-07-10 12:54:28",
                "2026-07-10 12:58:28",
                "2026-07-10 13:02:28",
                "2026-07-10 13:06:28",
                "2026-07-10 13:10:28"
            ),
            tz = "UTC"
        ),
        wet = rep(c(TRUE, FALSE), each = 3),
        filename = rep("Obs030626_162209_TagtestLogger_gps1AccWetDry.txt", 6),
        stringsAsFactors = FALSE
    )

    test_gps_accel_data <- data.frame(
        tag_id = rep("testLogger_gps1", 6),
        date_time = as.POSIXct(
            c(
                "2026-07-10 13:18:28",
                "2026-07-10 13:18:29",
                "2026-07-10 13:18:30",
                "2026-07-10 13:18:31",
                "2026-07-10 13:18:32",
                "2026-07-10 13:18:33"
            ),
            tz = "UTC"
        ),
        x_acceleration = c(0.3438, 0.3906, 0.3750, 0.3750, 0.3594, 0.3906),
        y_acceleration = c(0.6719, 0.6406, 0.6406, 0.6719, 0.6719, 0.6719),
        z_acceleration = c(0.6563, 0.6250, 0.6406, 0.6406, 0.6406, 0.6406),
        acceleration_3d = c(1.0001, 0.9765, 0.9805, 1.0012, 0.9955, 1.0072),
        filename = rep("Obs030626_162209_TagtestLogger_gps1Accel.txt", 6),
        stringsAsFactors = FALSE
    )


    test_gps_startup_data <- data.frame(
        logger_serial_no = paste0("testLogger_gps", c(1:5)),
        logger_model = rep("PicoFix_GEO_mini3", 5),
        producer = rep("PathTrack", 5),
        production_year = rep(2013, 5),
        project = rep("seatrack", 5),
        starttime_gmt = as.Date(rep("2026-01-01", 5)),
        logging_mode = rep(1, 5),
        started_by = rep("Jens Åström", 5),
        started_where = rep("NINA", 5),
        days_delayed = rep(10, 5),
        programmed_gmt_time = as.Date(rep("2026-01-01", 5)),
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

    test_gps_gsm_startup_data <- data.frame(
        logger_serial_no = paste0("testLogger_gps_gsm", c(1:5)),
        logger_model = rep("OrniTrack10", 5),
        producer = rep("Ornitela", 5),
        production_year = rep(2013, 5),
        project = rep("seatrack", 5),
        starttime_gmt = as.Date(rep("2026-01-01", 5)),
        logging_mode = rep(1, 5),
        started_by = rep("Jens Åström", 5),
        started_where = rep("NINA", 5),
        days_delayed = rep(10, 5),
        programmed_gmt_time = as.Date(rep("2026-01-01", 5)),
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

    test_gps_gsm_deployment_data <- data.frame(
        date = as.Date(rep("2026-01-01", 5)),
        ring_number = paste0(
            "TEST_RING_GPS_GSM",
            sample(100000:999999, nrow(test_gps_gsm_startup_data))
        ),
        euring_code = rep("NOS", 5),
        color_ring = NA_character_,
        logger_status = rep("individual caught (first deployment)", 5),
        logger_model_retrieved = NA_character_,
        logger_id_retrieved = NA_character_,
        logger_model_deployed = test_gps_gsm_startup_data$logger_model,
        logger_id_deployed = test_gps_gsm_startup_data$logger_serial_no,
        species = test_gps_gsm_startup_data$intended_species,
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
        colony = test_gps_gsm_startup_data$intended_location,
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

    test_gps_deployment_data <- data.frame(
        date = as.Date(rep("2026-01-01", 5)),
        ring_number = paste0(
            "TEST_RING_GPS",
            sample(100000:999999, nrow(test_gps_startup_data))
        ),
        euring_code = rep("NOS", 5),
        color_ring = NA_character_,
        logger_status = rep("individual caught (first deployment)", 5),
        logger_model_retrieved = NA_character_,
        logger_id_retrieved = NA_character_,
        logger_model_deployed = test_gps_startup_data$logger_model,
        logger_id_deployed = test_gps_startup_data$logger_serial_no,
        species = test_gps_startup_data$intended_species,
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
        colony = test_gps_startup_data$intended_location,
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

    test_startup_data <- data.frame(
        logger_serial_no = paste0("testLogger", c(1:5)),
        logger_model = c("c65", "c65", "c65", "c65", "TEST_MODEL_FOO"),
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


    n_per_logger <- 100

    test_gls_data <-
        do.call(
            rbind,
            lapply(seq_len(nrow(test_startup_data)), function(i) {
                startup_date <- test_startup_data$starttime_gmt[i]
                deployment_date <- test_deployment_data$date[i]
                logger <- test_startup_data$logger_serial_no[i]

                session_id <- paste(
                    logger,
                    format(startup_date, "%Y-%m-%d"),
                    sep = "_"
                )

                date_time <- seq(
                    from = as.POSIXct(deployment_date, tz = "UTC") + 12 * 3600,
                    by = "12 hours",
                    length.out = n_per_logger
                )
                twl_type <- rep(c(1, 2), length.out = n_per_logger)

                lon_raw <- 12 + cumsum(rnorm(n_per_logger, 0.1, 0.05))
                lat_raw <- 65 + cumsum(rnorm(n_per_logger, 0.1, 0.05))

                data.frame(
                    session_id = rep(session_id, n_per_logger),
                    date_time = date_time,
                    lon_raw = lon_raw,
                    lat_raw = lat_raw,
                    lon = lon_raw,
                    lat = lat_raw,
                    eqfilter = NA,
                    tfirst = date_time - 3600,
                    tsecond = date_time + 3600,
                    twl_type = twl_type,
                    sun = -3.25,
                    light_threshold = 1,
                    analyzer = test_startup_data$started_by[i],
                    stringsAsFactors = FALSE
                )
            })
        )

    # Ensure cleanup happens even if test fails
    withr::defer({
        print("Clean up test records")

        DBI::dbExecute(
            con,
            "DELETE FROM positions.postable_raw WHERE session_id LIKE 'testLogger_%'"
        )

        DBI::dbExecute(
            con,
            "DELETE FROM positions.gps_raw WHERE session_id LIKE 'testLogger_%'"
        )

        DBI::dbExecute(
            con,
            "DELETE FROM positions.gps_gsm_raw WHERE session_id LIKE 'testLogger_%'"
        )

        DBI::dbExecute(
            con,
            "DELETE FROM recordings.accelerometer_raw WHERE session_id LIKE 'testLogger_%'"
        )

        DBI::dbExecute(
            con,
            "DELETE FROM recordings.activity_raw WHERE session_id LIKE 'testLogger_%'"
        )

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
        DBI::dbExecute(
            con,
            "DELETE FROM metadata.logger_models WHERE model LIKE 'TEST_MODEL_%'"
        )
    })

    sessions <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logging_session"))
    loggers <- dplyr::tbl(con, dbplyr::in_schema("loggers", "logger_info"))
    deployments <- dplyr::tbl(con, dbplyr::in_schema("loggers", "deployment"))
    sessions <- dplyr::left_join(sessions, loggers, by = "logger_id")
    status <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_status"))
    info <- dplyr::tbl(con, dbplyr::in_schema("individuals", "individ_info"))
    models <- dplyr::tbl(con, dbplyr::in_schema("metadata", "logger_models"))
    immersion <- dplyr::tbl(con, dbplyr::in_schema("recordings", "activity"))
    acceleration <- dplyr::tbl(con, dbplyr::in_schema("recordings", "accelerometer"))

    if (check_db_version() >= 45) {
        observation <- dplyr::tbl(con, dbplyr::in_schema("individuals", "observation"))
    }

    if (check_db_version() >= 51) {
        sampling_events <- dplyr::tbl(con, dbplyr::in_schema("loggers", "sampling_events"))
    }

    if (check_db_version() >= 56) {
        gps_gsm <- dplyr::tbl(con, dbplyr::in_schema("positions", "gps_gsm"))
        gps <- dplyr::tbl(con, dbplyr::in_schema("positions", "gps"))
    }

    # Add test model
    DBI::dbExecute(
        con,
        "INSERT INTO metadata.logger_models(producer, model, logger_type) VALUES('Migrate Technology', 'TEST_MODEL_FOO', 'GLS')"
    )

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
        regular_shutdown <- test_deployment_data[c(1, 5), ]
        regular_shutdown$date <- regular_shutdown$date + 10
        regular_shutdown$logger_model_retrieved <- regular_shutdown$logger_model_deployed
        regular_shutdown$logger_model_deployed <- NA
        regular_shutdown$logger_id_retrieved <- regular_shutdown$logger_id_deployed
        regular_shutdown$logger_id_deployed <- NA
        retrieval_result <- writeMetadata(regular_shutdown)
        expect_true(retrieval_result)

        # Check if the session is retrieved
        filtered_sessions <- dplyr::filter(
            sessions,
            logger_serial_no %in% regular_shutdown$logger_id_retrieved,
            !is.na(retrieval_id)
        )
        expect_true(dplyr::tally(filtered_sessions) %>% pull(n) == 2)
    })

    test_that("writeMetdata can retrieve sessions with a ring change", {
        if (check_db_version() < 45) {
            testthat::skip()
        }
        new_ring_shutdown <- test_deployment_data[2, ]
        new_ring_shutdown$date <- new_ring_shutdown$date + 10
        new_ring_shutdown$logger_model_retrieved <- new_ring_shutdown$logger_model_deployed
        new_ring_shutdown$logger_model_deployed <- NA
        new_ring_shutdown$logger_id_retrieved <- new_ring_shutdown$logger_id_deployed
        new_ring_shutdown$logger_id_deployed <- NA

        new_ring_shutdown$old_ring_number <- new_ring_shutdown$ring_number
        new_ring_shutdown$ring_number <- paste0(new_ring_shutdown$ring_number, "_NEW")

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
        filtered_status <- dplyr::filter(
            status,
            ring_number %in% c(new_ring_shutdown$old_ring_number, new_ring_shutdown$ring_number)
        )
        expect_true(dplyr::tally(filtered_status) %>% pull(n) == 2)

        individual_id <- dplyr::distinct(filtered_status, info_id) %>% dplyr::pull(info_id)

        expect_true(length(individual_id) == 1)

        # Check that the individual ID is still the same
        filtered_info <- dplyr::filter(info, id == individual_id) %>% dplyr::collect()
        # But the latest ring is stored
        expect_true(new_ring_shutdown$ring_number == filtered_info$ring_number)
        expect_false(paste(new_ring_shutdown$ring_number, new_ring_shutdown$euring_code, sep = "_") == filtered_info$individ_id)
    })

    # Shutdowns
    test_that("Sessions can be shut down", {
        test_shutdown_data <- test_startup_data[1:2, ]
        test_shutdown_data$download_date <- test_shutdown_data$shutdown_date <- test_shutdown_data$starttime_gmt + 11
        test_shutdown_data$download_type <- "Successfully downloaded"
        test_shutdown_data$shutdown_session <- TRUE
        test_shutdown_data$intended_species <- NA
        logger_result <- writeLoggerImport(test_shutdown_data)
        expect_true(logger_result)
    })

    test_that("During shutdown, models with no logger_files should fail", {
        test_shutdown_data <- test_startup_data[5, ]
        test_shutdown_data$download_date <- test_shutdown_data$shutdown_date <- test_shutdown_data$starttime_gmt + 11
        test_shutdown_data$download_type <- "Successfully downloaded"
        test_shutdown_data$shutdown_session <- TRUE
        test_shutdown_data$intended_species <- NA
        expect_error(writeLoggerImport(test_shutdown_data))
    })

    test_that("Non deployment/retrieval statuses can fall within a session", {
        if (check_db_version() < 45) {
            testthat::skip()
        }
        regular_status <- test_deployment_data[3, ]
        regular_status$date <- regular_status$date + 1
        regular_status$logger_model_deployed <- NA
        regular_status$logger_id_deployed <- NA
        regular_status$sex <- "female"
        regular_status$sexing_method <- "dna"
        status_results <- writeMetadata(regular_status)
        expect_true(status_results)

        # check the status exists and is in the correct session
        filtered_status <- dplyr::filter(status, sex == "female", ring_number == regular_status$ring_number)
        expect_true(dplyr::tally(filtered_status) %>% dplyr::pull(n) == 1)
        status_id <- dplyr::pull(filtered_status, status_id)

        observation <- dplyr::filter(observation, status_id == {{ status_id }})
        expect_true(dplyr::tally(observation) %>% dplyr::pull(n) == 1)
        status_session_id <- dplyr::pull(observation, session_id)

        deployment_date <- dplyr::filter(sessions, session_id == status_session_id) %>%
            dplyr::left_join(deployments, by = dplyr::join_by(deployment_id == deployment_id)) %>%
            dplyr::pull(deployment_date)
        expect_true(deployment_date == test_deployment_data[3, ]$date)
        # check the info has the latest sex
        individual_id <- dplyr::distinct(filtered_status, info_id) %>% dplyr::pull(info_id)
        filtered_info <- dplyr::filter(info, id == individual_id) %>% dplyr::collect()
        expect_true(filtered_info$sex == "female")
    })

    test_that("Non deployment/retrieval statuses can fall outside a session", {
        if (check_db_version() < 45) {
            testthat::skip()
        }
        outside_status <- test_deployment_data[2, ]
        outside_status$logger_model_deployed <- NA
        outside_status$logger_id_deployed <- NA
        outside_status$sex <- "female"
        outside_status$sexing_method <- "dna"
        outside_status$date <- outside_status$date + 15
        status_results <- writeMetadata(outside_status)
        expect_true(status_results)

        # check the status exists and is in the correct session
        filtered_status <- dplyr::filter(status, sex == "female", ring_number == outside_status$ring_number)
        expect_true(dplyr::tally(filtered_status) %>% dplyr::pull(n) == 1)
        status_id <- dplyr::pull(filtered_status, status_id)

        observation <- dplyr::filter(observation, status_id == {{ status_id }})
        expect_true(dplyr::tally(observation) %>% dplyr::pull(n) == 1)
        status_session_id <- dplyr::pull(observation, session_id)

        expect_true(is.na(status_session_id))
        # check the info has the latest sex
        individual_id <- dplyr::distinct(filtered_status, info_id) %>% dplyr::pull(info_id)
        filtered_info <- dplyr::filter(info, id == individual_id) %>% dplyr::collect()
        expect_true(filtered_info$sex == "female")
    })
    test_that("Sampling information is written", {
        if (check_db_version() < 51) {
            testthat::skip()
        }

        blood_values <- dplyr::filter(status, ring_number %in% test_deployment_data$ring_number) %>%
            dplyr::left_join(sampling_events, by = "status_id") %>%
            dplyr::pull(blood_sample)

        expect_true(all(blood_values == "yes, blood was sampled for different reasons - results can/may be accessed by SEATRACK"))
    })

    # Test a combined retrieval/deployment event?

    # Test pos data writing

    test_that("Can write GLS positions", {
        pos_list <- lapply(unique(test_gls_data$session_id)[1:2], function(x) {
            test_gls_data[test_gls_data$session_id == x, ]
        })

        pos_result <- writePositions("GLS", pos_list)
        expect_true(pos_result)
    })
    test_that("Can write GPS-GSM positions", {
        if (check_db_version() < 56) {
            testthat::skip()
        }
        logger_result <- writeLoggerImport(test_gps_gsm_startup_data)
        metadata_result <- writeMetadata(test_gps_gsm_deployment_data)

        DBI::dbExecute(con, "SET search_path TO imports, public")
        test_gps_gsm_data_lower <- test_gps_gsm_data
        names(test_gps_gsm_data_lower) <- tolower(names(test_gps_gsm_data_lower))
        write_result <- dbWriteTable(con,
            "gps_gsm_import",
            test_gps_gsm_data_lower[1, ],
            row.names = FALSE,
            append = TRUE
        )
        expect_true(write_result)

        filtered_pos <- dplyr::filter(
            gps_gsm,
            logger_id %in% test_gps_gsm_deployment_data$logger_id_deployed
        )
        expect_true(dplyr::tally(filtered_pos) %>% pull(n) == nrow(test_gps_gsm_data_lower[1, ]))

        search_pattern <- paste(
            paste0(test_gps_gsm_deployment_data$logger_id_deployed, "_.*"),
            collapse = "|"
        )

        filtered_acc <- acceleration |>
            dplyr::filter(
                sql(paste0("session_id ~ '", search_pattern, "'"))
            )

        expect_true(dplyr::tally(filtered_acc) %>% pull(n) == nrow(test_gps_gsm_data_lower[1, ]))
    })

    test_that("Duplicate GPS-GSM rows not written", {
        if (check_db_version() < 56) {
            testthat::skip()
        }

        DBI::dbExecute(con, "SET search_path TO imports, public")
        test_gps_gsm_data_lower <- test_gps_gsm_data
        names(test_gps_gsm_data_lower) <- tolower(names(test_gps_gsm_data_lower))
        write_result <- dbWriteTable(con,
            "gps_gsm_import",
            test_gps_gsm_data_lower,
            row.names = FALSE,
            append = TRUE
        )

        expect_true(write_result)

        filtered_pos <- dplyr::filter(
            gps_gsm,
            logger_id %in% test_gps_gsm_deployment_data$logger_id_deployed
        )
        expect_true(dplyr::tally(filtered_pos) %>% pull(n) == nrow(test_gps_gsm_data_lower))

        write_result_2 <- dbWriteTable(con,
            "gps_gsm_import",
            test_gps_gsm_data_lower,
            row.names = FALSE,
            append = TRUE
        )

        expect_true(write_result_2) # No exception

        expect_true(dplyr::tally(filtered_pos) %>% pull(n) == nrow(test_gps_gsm_data_lower)) # No extra rows
    })

    test_that("Can write GPS positions", {
        if (check_db_version() < 57) {
            testthat::skip()
        }
        logger_result <- writeLoggerImport(test_gps_startup_data)
        metadata_result <- writeMetadata(test_gps_deployment_data)

        DBI::dbExecute(con, "SET search_path TO imports, public")
        test_gps_data_lower <- test_gps_data
        names(test_gps_data_lower) <- tolower(names(test_gps_data_lower))
        write_result <- dbWriteTable(con,
            "gps_import",
            test_gps_data_lower,
            row.names = FALSE,
            append = TRUE
        )
        expect_true(write_result)

        filtered_pos <- dplyr::filter(
            gps,
            logger_id %in% test_gps_deployment_data$logger_id_deployed
        )
        expect_true(dplyr::tally(filtered_pos) %>% pull(n) == nrow(test_gps_data_lower))
    })

    test_that("Can write GPS immersion data", {
        if (check_db_version() < 57) {
            testthat::skip()
        }

        DBI::dbExecute(con, "SET search_path TO imports, public")
        test_gps_wet_data_lower <- test_gps_wet_data
        names(test_gps_wet_data_lower) <- tolower(names(test_gps_wet_data_lower))
        write_result <- dbWriteTable(con,
            "gps_immersion_import",
            test_gps_wet_data_lower,
            row.names = FALSE,
            append = TRUE
        )
        expect_true(write_result)
        search_pattern <- paste(
            paste0(test_gps_deployment_data$logger_id_deployed, "_.*"),
            collapse = "|"
        )

        filtered_wet <- immersion |>
            dplyr::filter(
                sql(paste0("session_id ~ '", search_pattern, "'"))
            )

        expect_true(dplyr::tally(filtered_wet) %>% pull(n) == nrow(test_gps_wet_data_lower))
    })

    test_that("Can write GPS acceleration data", {
        if (check_db_version() < 57) {
            testthat::skip()
        }

        DBI::dbExecute(con, "SET search_path TO imports, public")
        test_gps_accel_data_lower <- test_gps_accel_data
        names(test_gps_accel_data_lower) <- tolower(names(test_gps_accel_data_lower))
        write_result <- dbWriteTable(con,
            "gps_acc_import",
            test_gps_accel_data_lower,
            row.names = FALSE,
            append = TRUE
        )
        expect_true(write_result)
        search_pattern <- paste(
            paste0(test_gps_deployment_data$logger_id_deployed, "_.*"),
            collapse = "|"
        )

        filtered_acc <- acceleration |>
            dplyr::filter(
                sql(paste0("session_id ~ '", search_pattern, "'"))
            )

        expect_true(dplyr::tally(filtered_acc) %>% pull(n) == nrow(test_gps_accel_data_lower))
    })
})
