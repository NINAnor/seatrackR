#' Download files from the file archive
#'
#'
#'
#'
#' @return Status messages on the actions taken for each file.
#' @export
#' @examples
#' dontrun{
#' ##To download all files in the file archive.
#' myFiles = listFileArchive()$filesInArchive
#' downloadFiles(files = myFiles, destFolder = "temp")
#' }
#'

downloadFiles <- function(files = NULL, destFolder = NULL, overwrite = F){
  checkCon()

  if(!tibble::is_tibble(files)) files <- tibble::as_tibble(files)

  url <- seatrackR:::.getFtpUrl()



  getFile <- function(x, destFolder = destFolder, overwrite = overwrite){

    if(!is.null(destFolder)){
      filename <- paste0(destFolder, "/", x)

    } else {
      filename <- paste(x)
    }

    if(file.exists(filename) & overwrite == F){
      warning(paste("File", filename, "already exists, use overwrite = True to overwrite"))
      return(paste0("File not downloaded: ", filename))
    } else {
      tmp <- strsplit(url$url, "//")
      getUrl <- paste0(tmp[[1]][1], "//", url$pwd, "@", tmp[[1]][2],"/" , x)
      getHandle <- httr::handle(getUrl)


      mess  <- lapply(getUrl, factory(function(x){
        rawOut <<- httr::with_config(httr::config(ssl_verifypeer = F,
                                               ssl_verifyhost = F,
                                               use_ssl = T),
                                  httr::GET(url = x, handle = getHandle))}))



      bin <- httr::content(rawOut, "raw")
      writeBin(bin, paste0(destFolder, "/", x))

      if(any(grepl("File successfully transferred", mess[[1]]$warn))){
        return(paste0("File downloaded: ", x))
      }

      }

  }

  apply(files, 1, function(x) getFile(x, overwrite = overwrite, destFolder = destFolder))
}





