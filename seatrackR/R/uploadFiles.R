#' Write files to the file archive
#'
#'
#'
#' @return Status messages on the actions taken for each file.
#' @export
#' @examples
#' dontrun{
#'
#' uploadFiles(files = c("test_file.txt", "test_file2.txt"), originFolder = "temp")
#' }
#'


uploadFiles <- function(files = NULL, originFolder = NULL, overwrite = F){
  checkCon()

  if(!tibble::is_tibble(files)) files <- tibble::as_tibble(files)

  fileArchive <- listFileArchive()

  if(any(files$value %in% fileArchive$filesInStorage$filename) & overwrite == F){
    stop(paste("At least one file already exists in the file storage, use overwrite = True to overwrite"))
  } else {


  url <- .getFtpUrl(write = T)

  writeFile <- function(x, url, originFolder = originFolder){

    if(!is.null(originFolder)){
      filename <- paste0(originFolder, "/", x)
    } else {
      filename <- paste(x)
    }

    if(!file.exists(filename)){
      warning(paste("Cannot find file: ", filename ))
      return(paste0("File not uploaded: ", filename))
    }
    tmp <- strsplit(url$url, "//")
    dest <- paste0(tmp[[1]][1], "//", url$pwd, "@", tmp[[1]][2], x)

    a <- RCurl::ftpUpload(what = filename, to = dest)

    if(a == 0){
      return(paste0("File uploaded: ", filename))
    } else
    return(a)
  }

  apply(files, 1, function(x) writeFile(x = x, url = url, originFolder = originFolder))

  }

}


