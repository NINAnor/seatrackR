#' checkSeatrackRVersion
#'
#' Search the github repository to compare the current installed version of the package
#'
#'
#'
#'
#'
#' @export


checkSeatrackRVersion <- function(){

  pkg = "seatrackR"

  installed_version <- tryCatch(packageVersion(gsub(".*/",
                                                    "", pkg)), error = function(e) NA)

  remote_version <- tryCatch({
    url <- "https://raw.githubusercontent.com/NINAnor/seatrackR/master/DESCRIPTION"
    x <- readLines(url, warn = FALSE)
    gsub("(Version: )(.*)", "\\2", grep("Version:", x, value = TRUE))
  }, error = function(e) {
    message("Could not check for latest package version (connection failed).")
    NA
  })

  res <- list(package = pkg, installed_version = installed_version,
              latest_version = remote_version, up_to_date = NA)

  if (!is.na(remote_version) && !is.na(installed_version)) {
  if (is.na(installed_version)) {
    message(paste("##", pkg, "is not installed..."))
  } else {
    if (remote_version > installed_version) {
      msg <- paste("##", pkg, "is out of date, latest version is",
                   remote_version)
      message(msg)
      res$up_to_date <- FALSE
    }
    else if (remote_version == installed_version) {
      message("seatrackR is up-to-date")
      res$up_to_date <- TRUE
    }
  }
  }
  return(res)
}
