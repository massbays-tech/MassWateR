#' A geometry set of streams in Massachusetts
#' 
#' A geometry set of streams in Massachusetts
#' 
#' @format A geometry set of linestring geometries
#' 
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' streamsMWR <- st_read('~/Desktop/NHD/NHDFlowline_fcode_46006_vis_101k_noattr.shp') %>% 
#'  st_zm() %>% 
#'  st_simplify(dTolerance = 10, preserveTopology = TRUE) %>% 
#'  st_geometry()
#' 
#' save(streamsMWR, file = 'data/streamsMWR.RData', compress = 'xz')
#' }
"streamsMWR"
