#' View the postable table
#'
#' This is a convenience function that reads from the table "positions.postable".
#' This table contains the primary positions data.
#'
#' @return Data frame.
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#' positions <- getPosdata()
#' }

getPosdata <- function(loadGeometries = T, limit = 1000){
  seatrackR:::checkCon()

  getQuery <- "SELECT * FROM positions.postable"

  if(loadGeometries){
    getQuery <- paste("SELECT *, ST_SetSRID(ST_MakePoint(lon_smooth2, lat_smooth2), 4326) geom
                FROM positions.postable
                WHERE lon_smooth2 is not null
                AND lat_smooth2 is not null
                AND eqfilter3 = 1",
                      "LIMIT",
                      limit)

    out <- sf::st_read_db(con, query = getQuery)
    } else {
      dbGetQuery <- paste(getQuery, "LIMIT", limit)
      out <- DBI::dbGetQuery(con, getQuery)
    }
  return(out)

}


