
test_that("writeMetdata can write data", {
    skip_if_no_test_db()
    set.seed(123)

    test_startup_data <- data.frame(
    logger_serial_no = paste0("testLogger",c(1:5)),
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

        
    })

    
    logger_result <- writeLoggerImport(test_startup_data)
    expect_true(logger_result)
    metadata_result <- writeMetadata(test_deployment_data)
    expect_true(metadata_result)

})