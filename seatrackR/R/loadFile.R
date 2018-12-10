#' Load a single file from the file archive into R
#'
#'
#'
#'
#' @return Status messages on the actions taken for each file.
#' @export
#' @examples
#' dontrun{
#' ##To download all files in the file storage
#' myFiles = listFileArchive()$filesInArchive
#' loadedFile <- loadFile(filename = myFiles[1,])
#' }
#'

loadFile <- function(filename = NULL){
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


      out <- readr::read_csv(httr::content(rawOut, "raw"))

      return(out)


}





