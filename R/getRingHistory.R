#' Retrieve info on the ring history table
#'
#' Read from the table of the history of ring numbers for birds that have had their rings changed.
#'
#' @param asTibble Return result as tibble? Boolean.
#' @return Lazy query, or optionally a tibble
#' @export
#' @examples
#' \dontrun{
#' getRingHistory()
#' }
#' @concept metadata
getRingHistory <- function(asTibble = FALSE) {
  checkCon()

  res <- dplyr::tbl(con, dbplyr::in_schema("individuals", "ring_history")) %>% select(-id)

  if (asTibble) {
    res <- res %>% dplyr::collect()
  }

  return(res)
}
