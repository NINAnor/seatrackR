test_that("getIndividInfo() returns data", {
    skip_if_no_test_db()
    individ_info <- getIndividInfo()

    expected <- c(
        session_id = "character",
        colony = "character",
        year_tracked = "character",
        individ_id = "character",
        ring_number = "character",
        country_code = "character",
        color_ring = "character",
        species = "character",
        subspecies = "character",
        morph = "character",
        status_age = "character",
        status_sex = "character",
        status_sexing_method = "character",
        status_date = "Date",
        weight = "numeric",
        skull = "numeric",
        tarsus = "numeric",
        wing = "numeric",
        breeding_stage = "character",
        eggs = "integer",
        chicks = "integer",
        hatching_success = "logical",
        breeding_success = "logical",
        breeding_success_criterion = "character",
        data_responsible = "character",
        back_on_nest = "logical",
        comment = "character",
        latest_sex = "character",
        latest_sexing_method = "character",
        latest_age = "character",
        latest_info_date = "Date",
        logger_id = "integer",
        logger_mount_method = "character",
        nest_id = "character",
        nest_latitude = "numeric",
        nest_longitude = "numeric",
        eventType = "character"
    )

    if (check_db_version() >= 46) {
        expected["logger_id"] <- "character"
    }

    # Check column names and order
    expect_identical(names(individ_info), names(expected))

    # Check column classes
    actual <- vapply(individ_info, function(x) class(x)[1], character(1))
    expect_identical(actual, expected)
})
