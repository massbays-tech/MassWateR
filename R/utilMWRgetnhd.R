#' Query NHD data from an ArcGIS REST service
#' 
#' Query NHD data from an ArcGIS REST service
#' 
#' @param id numeric for the layer ID to query, one of 6 (flowlines), 9 (areas large scale), or 12 (waterbodies large scale)
#' @param bbox list for the bounding box defined with elements xmin, ymin, xmax, ymax in EPSG:4326 coordinates
#' @param dLevel character string for the desired visibiliyt leevel, one of "high", "medium", or "low", see details
#' @param quiet logical, if FALSE progress messages are printed to the console
#' 
#' @details Function returns NHD spatial features from the ArcGIS REST service at <https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer>.  The function allows querying specific layers (flowlines, areas, waterbodies) within a defined bounding box and SQL filtering.
#' 
#' The \code{dLevel} argument defines the level of detail in the retrieved data.  For \code{id = 6}, the visibilityFilter attribute is used to determine the detail level. If dLevel is "low", features with visibilityFilter >= 1,000,000 are returned; if "medium", features with visibilityFilter >= 500,000; and if "high", features >= 100,000 are returned. For \code{id = 12}, the SHAPE_Area attribute is used. If dLevel is "low", features with SHAPE_Area >= 300,000 are returned; if "medium", features with SHAPE_Area >= 85,000; and if "high", features with SHAPE_Area >= 10,000 are returned.  No additional filtering based on detail level is applied if \code{id = 9}.
#' 
#' @return An sf object containing the queried NHD features.
#' @export
#' 
#' @examples
#' # Define bounding box (EPSG:4326)
#' bbox <- data.frame(
#'    x = c(-71.65734, -71.39113),
#'    y = c(42.26945, 42.46594)
#'  )
#' bbox <- sf::st_as_sf(bbox, coords = c("x", "y"), crs = 4326)
#' bbox <- sf::st_bbox(bbox)
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
utilMWRgetnhd <- function(id, bbox, dLevel, quiet = TRUE){
  
  id <- match.arg(as.character(id), c('6', '9', '12'))  # 6 flowlines, 9 areas (large scale), 12 waterbodies (large scale)

  if(!quiet){
    idswitch <- switch(id,
                      '6' = 'streams/flowlines',
                      '9' = 'rivers/areas',
                      '12' = 'ponds/waterbodies')
    strtmsg <- paste0("Querying NHD layer ID ", idswitch,
                        " with detail level '", dLevel, "'...")
    message(strtmsg)
  }

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
    clause <- paste0("ftype IN (390, 493) AND SHAPE_Area >= ",
                     ifelse(dLevel == 'low', 300000,
                            ifelse(dLevel == 'medium', 85000, 10000)))
    outfields <- paste(outfields, 'SHAPE_Area', sep = ',')
  }

  # Pagination parameters
  all_features <- list()
  offset <- 0
  record_count <- 2000  # Request 2000 at a time (API max)
  
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
      stop(paste("\tRequest failed with status:", httr::status_code(response)))
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
    if(!quiet)
      message("\tRetrieved ", nrow(features), " features (offset: ", offset, ")")
    
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
    if(!quiet)
      message("\tTotal features retrieved: ", nrow(out))
  } else {
    out <- sf::st_sf(geometry = sf::st_sfc(crs = 4326))
    if(!quiet)
      message("\tNo features found")
  }

  return(out)

}