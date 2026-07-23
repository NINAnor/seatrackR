set_bounds <- function(map, data, padding = 0.05) {
    if (nrow(data) == 1) {
        leaflet::setView(
            map,
            lng = data$x,
            lat = data$y,
            zoom = 8
        )
    } else if (nrow(data) > 0) {
        leaflet::fitBounds(
            map,
            lng1 = min(data$x, na.rm = TRUE) - padding,
            lat1 = min(data$y, na.rm = TRUE) - padding,
            lng2 = max(data$x, na.rm = TRUE) + padding,
            lat2 = max(data$y, na.rm = TRUE) + padding
        )
    }
}

default_marker_renderer <- function(map, data) {
    leaflet::clearMarkers(map)

    leaflet::addCircleMarkers(
        map,
        lng = data$x,
        lat = data$y,
        radius = 5,
        color = "red",
        fillColor = "red",
        fillOpacity = 1
    )
}

default_line_renderer <- function(map, data) {
    leaflet::clearShapes(map)
    all_identifiers <- unique(data$identifier)
    all_cols <- rainbow(length(all_identifiers))
    for (i in seq_along(all_identifiers)) {
        identifier <- all_identifiers[i]
        data_segment <- data[data$identifier == identifier, ]
        data_segment <- data_segment[order(data_segment$date_time), ]
        leaflet::addPolylines(map,
            lng = data_segment$x,
            lat = data_segment$y,
            opacity = 0.75,
            weight = 2.5,
            color = all_cols[i]
        )
    }
}

heatmap_renderer <- function(map, data) {
    leaflet.extras::clearHeatmap(map)
    leaflet.extras::addHeatmap(
        map,
        lng = data$x,
        lat = data$y,
        intensity = data$value,
        blur = 20,
        radius = 15,
        minOpacity = 0.9
    )
}

default_coord_fn <- function(data) {
    x_candidates <- c(
        "x",
        "lon",
        "lng",
        "longitude"
    )

    y_candidates <- c(
        "y",
        "lat",
        "latitude"
    )

    x_col <- intersect(x_candidates, names(data))[1]
    y_col <- intersect(y_candidates, names(data))[1]

    if (is.na(x_col) || is.na(y_col)) {
        stop(
            "Could not find coordinate columns. Supply coord_fn."
        )
    }

    data.frame(
        data,
        x = x_col,
        y = y_col
    )
}

map_display_ui <- function(id) {
    ns <- NS(id)

    leaflet::leafletOutput(ns("map"))
}

map_display_server <- function(
  id,
  paged,
  coord_fn = default_coord_fn,
  render_fn = default_marker_renderer,
  force_render = NULL
) {
    moduleServer(id, function(input, output, session) {
        output$map <- leaflet::renderLeaflet({
            leaflet::leaflet() %>%
                leaflet::addTiles() %>%
                leaflet::setView(lng = -93.85, lat = 37.45, zoom = 4)
        })

        proxy <- leaflet::leafletProxy(
            "map",
            session,
        )

        render_map <- function(data) {
            if (nrow(data) == 0) {
                return()
            }
            data <- coord_fn(data)
            data <- data[!is.na(data$x) & !is.na(data$y), ]

            if (nrow(data) == 0) {
                return()
            }

            render_fn(
                map = proxy,
                data = data
            )
            set_bounds(proxy, data)
        }

        # Observer to add markers via proxy
        observeEvent(paged$data(), {
            render_map(paged$data())
        })

        observeEvent(force_render(), {
            if (!is.null(force_render()) && force_render()) {
                render_map(paged$data())
                force_render(FALSE)
            }
        })
    })
}
