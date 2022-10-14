#' A simple features object of rivers in Massachusetts
#' 
#' A simple features object of rivers in Massachusetts
#' 
#' @format A simple features object of linestring geometries with one attribute called \code{dLevel} specifying the level of detail.
#' 
#' @details All geometries are simplified using a tolerance of ten meters. 
#' 
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' riversMWR <- st_read('~/Desktop/NHD/NHDArea_noattr.shp') %>% 
#'  st_make_valid() %>% 
#'  st_simplify(dTolerance = 10, preserveTopology = TRUE) %>% 
#'  # st_transform(crs = 4326) %>% 
#'  select(dLevel)
#' 
#' save(riversMWR, file = 'data/riversMWR.RData', compress = 'xz')
#' }
"riversMWR"
