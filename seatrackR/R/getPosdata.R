#' View the postable table
#'
#' This is a convenience function that reads from the table "positions.postable".
#' This table contains the primary positions data.
#'
#' @param selectSpecies Character string. Option to limit selection to one or a set of species.Default is NULL, indicating all species.
#' @param selectColony Character string. Option to limit selection to one or a set of colonies. Default is NULL.
#' @param selectDataResponsible Character string. Option to limit selection to one or a set of names of data responsible persons. Note that this
#' must conform to the name nomenclature used in the postable. Default is NULL
#' @param selectRingnumber Character string. Option to limit selection to one or a set of ring numbers. Default is NULL.
#' @param loadGeometries True, False. Should geometries be loaded from the columns lon_smooth2 and lat_smooth2.
#' If True, the returned object is a simple features object. Default = True.
#' @param limit Integer. Limit the number of rows returned to this number. Default = 1000.
#' @return Tibble of postable records. In the case of loadGeometries = T (default), also of class sf (simple feature) with geometries based on lat lon.
#' @import dplyr
#' @export
#' @examples
#' dontrun{
#' connectSeatrack(Username = "testreader", Password = "testreader")
#'
#' positions <- getPosdata(selectColony = "Kongsfjorden",
#'                 selectDataResponsible = "B_Moe",
#'                 selectSpecies = "Little auk",
#'                 limit = F,
#'                 loadGeometries = F)
#'
#' positions
#'
#' # get data with geometries (default)
#' positions2 <- getPosdata(limit = 500)
#'
#' positions2
#'
#' #make a simple plot
#' plot(positions2["logger_model"], pch = 16)
#'
#' }



getPosdata <- function(selectSpecies= NULL,
                       selectColony = NULL,
                       selectDataResponsible = NULL,
                       selectRingnumber = NULL,
                       selectYear = NULL,
                       loadGeometries = T,
                       limit = 1000){

  checkCon()

  postable <- tbl(con, dbplyr::in_schema("positions", "postable"))

  res <- postable %>% filter(!is.na(lon_smooth2) &
                              !is.na(lat_smooth2) &
                              eqfilter3 == 1)

  if(!is.null(selectSpecies)){
    res <- res %>% filter(species %in% selectSpecies)
  }

  if(!is.null(selectColony)){
    res <- res %>% filter(colony %in% selectColony)
  }

  if(!is.null(selectDataResponsible)){
    res <- res %>% filter(data_responsible %in% selectDataResponsible)
  }

  if(!is.null(selectRingnumber)){
    res <- res %>% filter(ring_number %in% selectRingnumber)
  }

  if(!is.null(selectYear)){
    res <- res %>% filter(year_tracked %in% selectYear)
  }

  if(!limit == F){
    res <- res %>% head(limit)
  }

  res <- res  %>% as_tibble()

  if(loadGeometries == T){
    res <- res %>% sf::st_as_sf(coords = c("lon_smooth2", "lat_smooth2"), crs = 4326)
  }

return(res)

}
