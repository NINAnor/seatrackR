test_that("getLoggerInfo() returns data", {
    skip_if_no_test_db()
    logger_info <- getLoggerInfo()

    expected <- c(
        logger_serial_no = "character",
        logger_id = "integer",
        starttime_gmt = "POSIXct",
        logging_mode = "character",
        producer = "character",
        logger_model = "character",
        production_year = "integer",
        session_id = "character",
        project = "character",
        deployment_date = "Date",
        retrieval_date = "Date",
        retrieval_type = "character",
        started_by = "character",
        started_where = "character",
        days_delayed = "integer",
        programmed_gmt_time = "POSIXct",
        individ_id = "character",
        intended_species = "character",
        intended_location = "character",
        intended_deployer = "character",
        deployment_species = "character",
        colony = "character",
        nest_id = "character",
        nest_longitude = "numeric",
        nest_latitude = "numeric",
        download_type = "character",
        download_date = "Date",
        shutdown_date = "Date",
        downloaded_by = "character",
        decomissioned = "logical",
        field_status = "character"
    )

    if (check_db_version() >= 42) {
        expected <- c(expected,
            retrieval_nest_id = "character",
            retrieval_nest_longitude = "numeric",
            retrieval_nest_latitude = "numeric",
            deployment_type = "character"
        )
    }

    # Check column names and order
    expect_identical(names(logger_info), names(expected))

    # Check column classes
    actual <- vapply(logger_info, function(x) class(x)[1], character(1))
    expect_identical(actual, expected)
})
