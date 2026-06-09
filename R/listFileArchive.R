#' Retrieve info on the status of files in the file archive
#'
#' This function checks which files are stored in the file archive, which files that are missing from the archive
#' (listed in the database but not present in the file archive), and which files are in the archive but not listed in the database (should be zero).
#'
#'
#'
#' @return A list.
#' @export
#' @examples
#' \dontrun{
#' listFileArchive()
#' }
#' #' @seealso \code{\link{getFileArchive}} for a function that summarizes info on the files that should be in the file archive (connected to loggers that have been shut down).
#' @concept files
listFileArchive <- function() {
  checkCon()

  ## Get files in archive, using curl instead of RCurl
  url <- .getFtpUrl()
  tmp <- strsplit(url$url, "//")
  dest <- paste0(tmp[[1]][1], "//", url$pwd, "@", tmp[[1]][2])

  list_files <- curl::new_handle()

  curl::handle_setopt(list_files,
    ftp_use_epsv = TRUE,
    dirlistonly = FALSE,
    use_ssl = FALSE,
    ssl_verifyhost = FALSE,
    ssl_verifypeer = FALSE,
    sslversion = 6L
  )

  con <- curl::curl(url = dest, "r", handle = list_files)

  curl_output <- readLines(con)
  close(con)

  size_date_and_name <- sub("^[[:alnum:][:punct:][:blank:]]{43}", "", curl_output)

  filesInStorage <- do.call(
    rbind.data.frame,
    lapply(
      stringr::str_match_all(size_date_and_name, "^([[:space:][:digit:]]+)[[:space:]]+(.+?[[:space:]].+?[[:space:]].+)[[:space:]]+(.*)$"),
      function(x) {
        date_string <- trimws(x[3])
        has_time <- grepl(":", date_string)
        if (has_time) {
          date_format <- "%b %e %H:%M"
        } else {
          date_format <- "%b %e  %Y"
        }
        date_object <- as.POSIXct(date_string, format = date_format)
        data.frame(
          size = trimws(x[2]),
          date = date_format,
          filename = trimws(x[4]),
          stringsAsFactors = FALSE
        )
      }
    )
  )

  filesInStorage <- filesInStorage[order(filesInStorage$date), ]
  filesInStorage <- as_tibble(filesInStorage)

  filesInDatabase <- getFileArchiveSummary()

  filesNotInStorage <- filesInDatabase %>%
    filter(!(filename %in% filesInStorage$filename)) %>%
    select(filename)

  filesNotInDatabase <- filesInStorage %>%
    filter(!(filename %in% filesInDatabase$filename))

  out <- list("filesInArchive" = filesInStorage, "filesNotInArchive" = filesNotInStorage, "filesNotInDatabase" = filesNotInDatabase)

  return(out)
}
