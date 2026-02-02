#' Query NHD data from an ArcGIS REST service
#' 
#' Query NHD data from an ArcGIS REST service
#' 
#' @param id numeric for the layer ID to query, one of 6 (flowlines), 9 (areas large scale), or 12 (waterbodies large scale)
#' @param bbox list for the bounding box defined with elements xmin, ymin, xmax, ymax in EPSG:4326 coordinates
#' @param dLevel character string for the desired visibiliyt leevel, one of "high", "medium", or "low", see details
#' 
#' @details Function returns NHD spatial features from the ArcGIS REST service at <https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer>.  The function allows querying specific layers (flowlines, areas, waterbodies) within a defined bounding box and SQL filtering.
#' 
#' The visibilityFilter attribute is used to determine the detail level of the features returned. If dLevel is "low", features with visibilityFilter >= 1,000,000 are returned; if "medium", features with visibilityFilter >= 500,000; and if "high", features >= 100,000 are returned. The filter only applies to flowlines (layer ID 6).
#' 
#' @return An sf object containing the queried NHD features.
#' @export
#' 
#' @examples
#' # Define bounding box (EPSG:4326)
#' bbox <- data.frame(
#'    x = c(-71.65734, -71.39113),
#'    y = c(42.26945, 42.46594)
#'  ) %>% 
#'  sf::st_as_sf(coords = c("x", "y"), crs = 4326) %>%
#'  sf::st_bbox()
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
  geometry <- bbox %>%
    sf::st_transform(crs = 3857) %>%
    as.character() %>%
    paste0(collapse = ',')
    
  # query url
  base_url <- "https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer"
  query_url <- paste0(base_url, "/", id, "/query")
  
  # setup clause, out fields
  clause <- "1=1"
  outfields <- "visibilityFilter"
  if(id == '6')
    clause <- paste0("fcode IN (46006, 55800) AND visibilityFilter >= ",
                     ifelse(dLevel == 'low', 1000000,
                            ifelse(dLevel == 'medium', 500000, 250000)))
  
  if(id == '12'){
    clause <- "ftype IN (390, 493)"
    outfields <- paste(outfields, 'SHAPE_Area', sep = ',')
  }

  # Pagination parameters
  all_features <- list()
  offset <- 0
  record_count <- 1000  # Request 1000 at a time
  
  repeat {
    # query parameters with pagination
    query_params <- list(
      geometry = geometry,
      geometryType = "esriGeometryEnvelope",
      inSR = "3857",
      spatialRel = "esriSpatialRelIntersects",
      where = clause,
      outFields = outfields,
      returnGeometry = "true",
      outSR = "4326",
      resultOffset = offset,
      resultRecordCount = record_count,
      f = "geojson"
    )
    
    # request
    response <- httr::GET(query_url, query = query_params)
    
    if (httr::status_code(response) != 200) {
      stop(paste("Request failed with status:", httr::status_code(response)))
    }
    
    # parse JSON response
    content <- httr::content(response, as = "text", encoding = "UTF-8")
    
    # output as sf
    features <- sf::st_read(content, quiet = TRUE)
    
    # Check if we got any features
    if (nrow(features) == 0) {
      break
    }
    
    all_features[[length(all_features) + 1]] <- features
    # message("Retrieved ", nrow(features), " features (offset: ", offset, ")")
    
    # If we got fewer features than requested, we've reached the end
    if (nrow(features) < record_count) {
      break
    }
    
    # Increment offset for next iteration
    offset <- offset + record_count
    
    # Small delay to be respectful to the API
    Sys.sleep(0.5)
  }
  
  # Combine all features
  if (length(all_features) > 0) {
    out <- do.call(rbind, all_features) %>%
      sf::st_make_valid()
    # message("Total features retrieved: ", nrow(out))
  } else {
    out <- sf::st_sf(geometry = sf::st_sfc(crs = 4326))
    # message("No features found")
  }

  return(out)

}