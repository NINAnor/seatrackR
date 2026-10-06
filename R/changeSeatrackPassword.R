#' changeSeatrackPassword
#'
#' Changes the password for a user in the SEATRACK database. Since the passwords for the file archive are fetched from the database,
#' this also affects the file archive.
#'
#'
#' @param password A string representing the new password. If NULL, the user will be prompted to enter a new password.
#' @param save_credentials Boolean. If TRUE, credentials will be saved to .Renviron for future use. Default is TRUE.
#'
#' @return Null
#' @export
#' @examples
#' \dontrun{
#' changeSeatrackPassword("newPassword")
#' }
#'
#' @concept general_db
changeSeatrackPassword <- function(password = NULL, save_credentials = TRUE) {
  checkCon()

  if (is.null(password)) {
    password <- getPass::getPass(msg = "Enter new password:", noblank = TRUE)
  }
  if (is.null(password)) {
    print("Password will not be changed")
    return()
  }

  current_user <- DBI::dbGetQuery(con, "SELECT current_user")

  alterQuery <- paste0("ALTER USER ", current_user, " WITH PASSWORD '", password, "';")

  mess <- DBI::dbExecute(con, alterQuery)

  disconnectSeatrack()

  if (save_credentials) {
    set_credentials_renviron(current_user, password)

    connectSeatrack()

    print("Password succesfully changed, you have been reconnected.")
  } else {
    print("Password succesfully changed, you have been disconnected.")
  }

}
