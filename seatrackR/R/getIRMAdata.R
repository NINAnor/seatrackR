#' Get IRMA position data
#'
#' Retreives data from the positions.irma table (materialized view), with subsetting options.
#'
#' @param sessionId Optional character vector of sessionID(s) to get data on.
#' @param individId Optional character vector of individID(s) to get data on.
#' @param loadGeometries Load the results as an sf-object? Default FALSE.
#' @param loadImportDate Include data on last updated and updated_by?
#' @param asTibble Load as tibble. Default TRUE.
#' @param limit Optionally limit the number of returned rows. Useful for tests.
#'
#' @return A tibble or sf-object with the IRMA position data
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' some_data <- getIRMAdata(limit = 100)
#'
#' }
#'

getIRMAdata <- function(sessionId = NULL,
                        individId = NULL,
                        loadGeometries = F,
                        loadImportDate = T,
                        asTibble = T,
                        limit = F){




  seatrackR:::checkCon()


  if(!limit == F & !is.numeric(limit)){
    stop("limit must be FALSE or a numeric value")
  }

  irma <- tbl(con, dbplyr::in_schema("positions", "irma"))
  res <- irma


  if(!is.null(sessionId)){
    res <- res %>% filter(session_id %in% sessionId)
  }

  if(!is.null(individId)){
    res <- res %>% filter(individ_id %in% individId)
  }

  if(!limit == F){
    res <- res %>% head(limit)
  }

  if(asTibble){
    res <- res %>% dplyr::collect()

    #Force timezone on date_time to UTC
    res <- res %>%
      mutate(date_time = lubridate::force_tz(date_time,
                                             tzone = "UTC"))
  }

  if(loadGeometries == T){

    res <- res %>%
      dplyr::collect() %>%
      sf::st_as_sf(coords = c("lon", "lat"),
                   crs = 4326,
                   remove = F)
  }

  return(res)

}
