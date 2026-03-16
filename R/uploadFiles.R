#' Write files to the file archive
#'
#'
#' @param files Character vector of files to write to file archive.
#' @param originFolder Character vector of folder to find files in.
#' @param overwrite Overwrite existing data? Booldean.
#' @param ... optional additional parameters passed on to RCurl::ftpUpload.
#'
#' @return Status messages on the actions taken for each file.
#' @export
#' @examples
#' \dontrun{
#'
#' uploadFiles(files = c("test_file.txt", "test_file2.txt"), originFolder = "temp")
#' }
#' @concept files
uploadFiles <- function(files = NULL,
                        originFolder = NULL,
                        overwrite = FALSE,
                        ...) {
  # Verbose doesn't work

  checkCon()

  current_user <- DBI::dbGetQuery(con, "SELECT current_user")

  current_roles <- DBI::dbGetQuery(con, paste0("select rolname from pg_user
                                                    join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
                                                    join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
                                                    where
                                                    pg_user.usename = '", current_user, "'"))
  current_roles <- current_roles[, 1]


  if (!("admin" %in% current_roles || "seatrack_writer" %in% current_roles)) {
    stop("Connected user needs to be part of seatrack_writer or admin group")
  }

  fileArchive <- listFileArchive()
  if (overwrite == FALSE) {
    to_upload <- files[!basename(files) %in% fileArchive$filesInArchive$filename]
    print(paste(length(files) - length(to_upload), "files already exist in the file archive and will not be uploaded, use overwrite = TRUE to overwrite"))
  } else {
    to_upload <- files
  }
  print(paste(length(to_upload), "files to upload"))
  if (length(to_upload) == 0) {
    return(invisible())
  }
  url <- .getFtpUrl()

  for (x in to_upload) {
    result <- writeFile(x = x, url = url, originFolder = originFolder)
    if (result == TRUE) {
      print(paste("Successfully uploaded file: ", x))
    } else {
      print(paste("Failed to upload file: ", x))
    }
  }
  return(invisible())
}


writeFile <- function(x,
                      url,
                      originFolder = originFolder,
                      ...) {
  if (!is.null(originFolder)) {
    filename <- file.path(originFolder, x)
  } else {
    filename <- paste(x)
  }

  if (!file.exists(filename)) {
    warning(paste("Cannot find file: ", filename))
    return(FALSE)
  }

  tmp <- strsplit(url$url, "//")
  getUrl <- paste0(tmp[[1]][1], "//", url$pwd, "@", tmp[[1]][2], "/", basename(x))

  getHandle <- httr::handle(getUrl)
  filePkg <- httr::upload_file(filename)

  mess <- lapply(getUrl, factory(function(x) {
    RCurl::ftpUpload(
      what = filename,
      to = getUrl,
      asText = FALSE,
      use.ssl = TRUE,
      ssl.verifypeer = FALSE,
      sslversion = 6L
    )
  }))

  if (any(grepl("OK", attr(mess[[1]][[1]], "names")))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
