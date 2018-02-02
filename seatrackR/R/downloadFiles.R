#' Download files from the file archive
#'
#'
#'
#'
#' @return Status messages on the actions taken for each file.
#' @export
#' @examples
#' dontrun{
#' ##To download all files in the file storage
#' myFiles = listFileArchive()$filesInStorage
#' downloadFiles(files = myFiles, destFolder = "temp")
#' }
#'


downloadFiles <- function(files = NULL, destFolder = NULL, overwrite = F){
  checkCon()

  if(!tibble::is_tibble(files)) files <- tibble::as_tibble(files)

  url <- .getFtpUrl()

  getFile <- function(x, url, destFolder = destFolder, ...){

    if(!is.null(destFolder)){
      filename <- paste0(destFolder, "/", x)
    } else {
      filename <- paste(x)
    }

    if(file.exists(filename) & overwrite == F){
      warning(paste("File", filename, "already exists, use overwrite = True to overwrite"))
      return(paste0("File not downloaded: ", filename))
    } else {

    f <- RCurl::CFILE(filename, mode="wb")

    a <- RCurl::curlPerform(url = paste0(url$url, x), curl = RCurl::getCurlHandle(userpwd = url$pwd), writedata = f@ref)
    RCurl::close(f)

    if(a == 0){
      return(paste0("File downloaded: ", filename))
    } else
    return(a)
  }

  }

  apply(files, 1, function(x) getFile(x = x, url = url, destFolder = destFolder, overwrite = T))
}

