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
#' dontrun{
#' listFileArchive()
#' }
#' @seealso \code{\link{getFileArchive}} for a function that summarizes info on the files that should be in the file archive (connected to loggers that have been shut down). )


listFileArchive <- function(){
  checkCon()

  filesInStorage <- RCurl::getURL(url = .getFtpUrl()$url, userpwd = .getFtpUrl()$pwd,
                      ftp.use.epsv = FALSE,
                      dirlistonly = TRUE,
                      crlf = T)

  filesInStorage <- strsplit(filesInStorage, "\r*\n")[[1]] %>% as_tibble
  names(filesInStorage) <- "filename"

  filesInDatabase <- getFileArchive()

  filesNotInStorage <- filesInDatabase %>%
    filter(!(filename %in% filesInStorage$filename)) %>%
    select(filename)

  filesNotInDatabase <- filesInStorage %>%
    filter(!(. %in% filesInDatabase$filename))

  out <- list("filesInStorage" = filesInStorage, "filesNotInStorage" = filesNotInStorage, "filesNotInDatabase" = filesNotInDatabase)

  return(out)
}


#fileStatus <- listFileArchive()





