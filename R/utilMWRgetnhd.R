#' Query NHD data from an ArcGIS REST service
#' 
#' Query NHD data from an ArcGIS REST service
#' 
#' @param id numeic for the layer ID to query, one of 6 (flowlines), 9 (areas large scale), or 12 (waterbodies large scale)
#' @param bbox list for the bounding box defined with elements xmin, ymin, xmax, ymax in EPSG:4326 coordinates
#' @param dLevel character string for the desired visibiliyt leevel, one of "high", "medium", or "low", see details
#' 
#' @details Function returns NHD spatial features from the ArcGIS REST service at <https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer>.  The function allows querying specific layers (flowlines, areas, waterbodies) within a defined bounding box and SQL filtering.
#' 
#' The visibilityFilter attribute is used to determine the detail level of the features returned. If dLevel is "low", features with visibilityFilter >= 1,000,000 are returned; if "medium", features with visibilityFilter >= 500,000; and if "high", features >= 100,000 are returned. The filter does not apply to areas (layer ID 9).
#' 
#' @return An sf object containing the queried NHD features.
#' @export
#' 
#' @examples
#' # Define bounding box (EPSG:4326)
#' bbox <- list(
#'   xmin = -71.65734,
#'   ymin = 42.26945,
#'   xmax = -71.39113,
#'   ymax = 42.46594
#' )
#' 
#' \dontrun{
#' flowlines <- utilMWRgetnhd(
#'   id = 6,
#'   bbox = bbox,
#'   dLevel = 'low'
#' )
#' 
#' area <- utilMWRgetnhd(
#'   id = 9,
#'   bbox = bbox,
#'   dLevel = 'low'
#' )
#' 
#' waterbody <- utilMWRgetnhd(
#'   id = 12,
#'   bbox = bbox,
#'   dLevel = 'low'
#' )
#' }
utilMWRgetnhd <- function(id, bbox, dLevel){
  
  id <- match.arg(as.character(id), c('6', '9', '12'))  # 6 flowlines, 9 areas (large scale), 12 waterbodies (large scale)

  # transform bbox to EPSG:3857
  coords <- data.frame(
      x = c(bbox$xmin, bbox$xmax),
      y = c(bbox$ymin, bbox$ymax)
    ) %>% 
    sf::st_as_sf(coords = c("x", "y"), crs = 4326) %>% 
    sf::st_transform(crs = 3857) %>% 
    sf::st_coordinates()
    
  # coords as list
  coordsls <- list(
    xmin = coords[1, "X"],
    ymin = coords[1, "Y"],
    xmax = coords[2, "X"],
    ymax = coords[2, "Y"]
  )
  
  # query url
  base_url <- "https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer"
  query_url <- paste0(base_url, "/", id, "/query")

  # geometry
  geometry <- paste0(coordsls$xmin, ",", coordsls$ymin, ",", 
                     coordsls$xmax, ",", coordsls$ymax)
  
  # setup clause, out fields
  clause <- "1=1"
  outfields <- "visibilityFilter"
  if(id == '6')
    clause <- paste0("fcode = 46006 AND visibilityFilter >= ",
                     ifelse(dLevel == 'low', 1000000,
                            ifelse(dLevel == 'medium', 500000, 100000)))
  
  if(id == '12'){
    clause <- "ftype IN (390, 493)"
    outfields <- paste(outfields, 'SHAPE_Area', sep = ',')
  }

  # query parameters
  query_params <- list(
    geometry = geometry,
    geometryType = "esriGeometryEnvelope",
    inSR = "3857",
    spatialRel = "esriSpatialRelIntersects",
    where = clause,
    outFields = outfields,
    returnGeometry = "true",
    outSR = "4326",
    f = "json"
  )
  
  # request
  response <- httr::GET(query_url, query = query_params)
  
  if (httr::status_code(response) != 200) {
    stop(paste("Request failed with status:", httr::status_code(response)))
  }
  
  # parse JSON response
  content <- httr::content(response, as = "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)  # Changed to FALSE
  
  # convert to sf object
  if (length(data$features) == 0) {
    # warning("No features returned from query")
    return(NULL)
  }

  # extract attributes
  attrs <- lapply(data$features, function(f) {
      if (!is.null(f$attributes) && length(f$attributes) > 0) {
        attrs <- f$attributes
        attrs <- lapply(attrs, function(x) if (is.null(x)) NA else x)
        as.data.frame(attrs, stringsAsFactors = FALSE)
      } else {
        data.frame()
      }
    }) %>% 
    dplyr::bind_rows()
  
  # create sf object based on geometry type
  geom_type <- data$geometryType
  
  # for flowlines
  if (geom_type == "esriGeometryPolyline") {
    # Handle polylines (NHDFlowlines)
    geom_list <- lapply(data$features, function(feature) {
      paths <- feature$geometry$paths
      
      coords <- unlist(paths)
      coords <- matrix(coords, ncol = 2, byrow = TRUE)
      sf::st_linestring(coords)
     
    })
    
  }
  
  # for areas, waterbodies
  if (geom_type == "esriGeometryPolygon") {
    geom_list <- lapply(data$features, function(feature) {
      rings <- feature$geometry$rings

      # process rings
      processed_rings <- lapply(rings, function(ring) {
 
        coords <- unlist(ring)
        coords <- matrix(coords, ncol = 2, byrow = TRUE)
        
        # ensure rings are closed
        if (!identical(coords[1,], coords[nrow(coords),])) {
          coords <- rbind(coords, coords[1,])
        }
        
        coords
      })
      
      sf::st_polygon(processed_rings)
 
    })
    
  }
  
  # output as sf
  out <- sf::st_sf(
      attrs,
      geometry = sf::st_sfc(geom_list, crs = 4326)
    ) 

  return(out)

}