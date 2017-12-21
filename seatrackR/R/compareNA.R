#' Compare values while taking account of NAs
#'
#' Taken from the R-cookbook
#'
#' @param v1 Values to check.
#' @param v2 Values to check against.
#' @return Vector of logical values



compareNA <- function(v1,v2) {
  # This function returns TRUE wherever elements are the same, including NA's,
  # and false everywhere else.
  same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}
