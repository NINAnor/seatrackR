#' sfGmapPlot
#'
#' Plotting function to overlay sf objects on a ggmap
#'
#'
#'


sfGmapPlot <- function(sf,
                       maptype = c("terrain", "terrain-background", "satellite",
                                                 "roadmap", "hybrid", "toner", "watercolor", "terrain-labels", "terrain-lines",
                                                 "toner-2010", "toner-2011", "toner-background", "toner-hybrid",
                                                 "toner-labels", "toner-lines", "toner-lite"),
                       color = "salmon"){

  maptype <- match.arg(maptype)


  ##Function below courtesy of @andyteucher at stackoverflow
  # Define a function to fix the bbox to be in EPSG:3857
  ggmap_bbox <- function(map) {
    if (!inherits(map, "ggmap")) stop("map must be a ggmap object")
    # Extract the bounding box (in lat/lon) from the ggmap to a numeric vector,
    # and set the names to what sf::st_bbox expects:
    map_bbox <- setNames(unlist(attr(map, "bb")),
                         c("ymin", "xmin", "ymax", "xmax"))

    # Coonvert the bbox to an sf polygon, transform it to 3857,
    # and convert back to a bbox (convoluted, but it works)
    bbox_3857 <- st_bbox(st_transform(st_as_sfc(st_bbox(map_bbox, crs = 4326)), 3857))

    # Overwrite the bbox of the ggmap object with the transformed coordinates
    attr(map, "bb")$ll.lat <- bbox_3857["ymin"]
    attr(map, "bb")$ll.lon <- bbox_3857["xmin"]
    attr(map, "bb")$ur.lat <- bbox_3857["ymax"]
    attr(map, "bb")$ur.lon <- bbox_3857["xmax"]
    map
  }

  bbox_4326 <- st_bbox(sf)
  names(bbox_4326) <- c("left", "bottom", "right", "top")

  bg <- get_map(location = bbox_4326)

  bg <- ggmap_bbox(bg)

  ggmap(bg) +
    coord_sf(crs = st_crs(3857)) + # force the ggplot2 map to be in 3857
    geom_sf(data = sf, col = "salmon", inherit.aes = F)




}




#####
#
#
# require(ggplot2)
# require(sf)
#
# norway <- sf::st_read("NorwayMunicipality/Municipalities _N5000_.shp")
#
# ggplot(norway) +
#   geom_sf()
#
#
# require(seatrackR)
# connectSeatrack("jens_astrom", "jensgis")
#
# hornoya <- getPosdata(selectColony = "Hornøya",
#                       loadGeometries = T)
#
# hornoya
#
# sub <- hornoya %>%
#   slice(1:100)
#
#
# ggplot(sub) +
#   geom_sf()
#
# require(ggmap)
#
# bg <- get_map("London", zoom = 3)
# class(bg)
#
# ggmap(bg) +
#   geom_sf(data = hornoya)
#
#
#
# # Define a function to fix the bbox to be in EPSG:3857
# ggmap_bbox <- function(map) {
#   if (!inherits(map, "ggmap")) stop("map must be a ggmap object")
#   # Extract the bounding box (in lat/lon) from the ggmap to a numeric vector,
#   # and set the names to what sf::st_bbox expects:
#   map_bbox <- setNames(unlist(attr(map, "bb")),
#                        c("ymin", "xmin", "ymax", "xmax"))
#
#   # Coonvert the bbox to an sf polygon, transform it to 3857,
#   # and convert back to a bbox (convoluted, but it works)
#   bbox_3857 <- st_bbox(st_transform(st_as_sfc(st_bbox(map_bbox, crs = 4326)), 3857))
#
#   # Overwrite the bbox of the ggmap object with the transformed coordinates
#   attr(map, "bb")$ll.lat <- bbox_3857["ymin"]
#   attr(map, "bb")$ll.lon <- bbox_3857["xmin"]
#   attr(map, "bb")$ur.lat <- bbox_3857["ymax"]
#   attr(map, "bb")$ur.lon <- bbox_3857["xmax"]
#   map
# }
#
# # Use the function:
# map <- ggmap_bbox(bg)
#
# ggmap(bg) +
#   coord_sf(crs = st_crs(3857)) + # force the ggplot2 map to be in 3857
#   geom_sf(data = sub, aes(fill = date_time), inherit.aes = FALSE)
#
# ggmap(bg) +
#   coord_sf(crs = st_crs(3857)) + # force the ggplot2 map to be in 3857
#   geom_sf(data = sub, col = "salmon", inherit.aes = F)
#
#
#
#
#
