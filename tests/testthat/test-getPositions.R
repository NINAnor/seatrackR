test_that("getPostions() returns data", {

  skip_if_no_test_db()
  pos_data <- getPositions(limit = 10)

expected <- c(
    id = "character",
    date_time = "POSIXct",
    logger_id = "integer",
    logger_model = "character",
    year_tracked = "character",
    session_id = "character",
    individ_id = "character",
    deployment_date = "Date",
    retrieval_date = "Date",
    ring_number = "character",
    country_code = "character",
    species = "character",
    colony = "character",
    lon_raw = "numeric",
    lat_raw = "numeric",
    lon = "numeric",
    lat = "numeric",
    eqfilter = "logical",
    sex = "character",
    age_deployment = "character",
    col_lon = "numeric",
    col_lat = "numeric",
    tfirst = "POSIXct",
    tsecond = "POSIXct",
    twl_type = "integer",
    sun = "numeric",
    light_threshold = "integer",
    analyzer = "character",
    data_responsible = "character",
    data_version = "integer",
    last_updated = "Date",
    updated_by = "character",
    date_time_downloaded = "POSIXct"
  )

  # Check column names and order
  expect_identical(names(pos_data), names(expected))

  # Check column classes
  actual <- vapply(pos_data, function(x) class(x)[1], character(1))
  expect_identical(actual, expected)

})

# Should also check that the various filters work