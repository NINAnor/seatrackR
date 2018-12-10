#' Load a single file from the file archive into R
#'
#' We load the file using read_csv from the readr package, and parameters
#'
#' @param filename character, matching a filename in the archive
#' @param ... further parameters to readr::read_csv function
#' @return Status messages on the actions taken for each file.
#' @export
#' @examples
#' dontrun{
#' ##To download all files in the file storage
#' myFiles = listFileArchive()$filesInArchive
#' loadedFile <- loadFile(filename = myFiles[1,])
#'
#' #Some files starts funny, this might help:
#' loadedFile2 <- loadFile(filename = myFiles[1,],
#'                        skip = 1,
#'                        col_names = F)
#' }
#'

loadFile <- function(filename = NULL, ...){
  checkCon()

  if(length(filename) != 1){
    stop("Need a single filename to load.")
    }

    url <- seatrackR:::.getFtpUrl()

    tmp <- strsplit(url$url, "//")
    getUrl <- paste0(tmp[[1]][1], "//", url$pwd, "@", tmp[[1]][2],"/" , filename)
    getHandle <- httr::handle(getUrl)


    suppressWarnings(rawOut <- httr::with_config(httr::config(ssl_verifypeer = F,
                                             ssl_verifyhost = F,
                                               use_ssl = T),
                                  httr::GET(url = getUrl, handle = getHandle)))


    out <- readr::read_csv(httr::content(rawOut, "raw"), ...)

      return(out)


}





