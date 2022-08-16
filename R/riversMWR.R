#' A geometry set of rivers in Massachusetts
#' 
#' A geometry set of rivers in Massachusetts
#' 
#' @format A geometry set of linestring geometries
#' 
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' riversMWR <- st_read('~/Desktop/NHD/NHDArea_noattr.shp') %>% 
#'  st_make_valid() %>% 
#'  st_simplify(dTolerance = 10, preserveTopology = TRUE) %>% 
#'  st_transform(crs = 4326) %>% 
#'  st_geometry()
#' 
#' save(riversMWR, file = 'data/riversMWR.RData', compress = 'xz')
#' }
"riversMWR"
