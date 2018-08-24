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


uploadFiles <- function(files = NULL,
                        originFolder = NULL,
                        overwrite = F,
                        verbose = F){
  checkCon()

  current_user <- DBI::dbGetQuery(con, "SELECT current_user")

  current_roles <- DBI::dbGetQuery(con, paste0("select rolname from pg_user
                                                    join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
                                                    join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
                                                    where
                                                    pg_user.usename = '", current_user, "'"))
  current_roles <- current_roles[,1]


     if(!("admin" %in% current_roles || "seatrack_writer" %in% current_roles)) stop("Connected user needs to be part of seatrack_writer or admin group")

  if(!tibble::is_tibble(files)) files <- tibble::as_tibble(files)

  fileArchive <- listFileArchive()

  if(any(files$value %in% fileArchive$filesInArchive$filename) & overwrite == F){
    stop(paste("At least one file already exists in the file archive, use overwrite = True to overwrite"))
  } else {


  url <- .getFtpUrl()

  writeFile <- function(x,
                        url,
                        originFolder = originFolder,
                        verbose = verbose){

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
    dest <- paste0(tmp[[1]][1], "//", url$pwd, "@", tmp[[1]][2],"/" , x)

    a <- RCurl::ftpUpload(what = filename,
                          to = dest,
                          ftpsslauth = T,
                          ftp.ssl = T,
                          ssl.verifypeer = F,
                          ssl.verifyhost = F,
                          verbose = verbose)

    if(a == 0){
      return(paste0("File uploaded: ", filename))
    } else
    return(a)
  }

  apply(files, 1, function(x) writeFile(x = x, url = url, originFolder = originFolder))

  }

}


