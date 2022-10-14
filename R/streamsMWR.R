#' A simple features object of streams in Massachusetts
#' 
#' A simple features object of streams in Massachusetts
#' 
#' @format A simple features object of linestring geometries with one attribute called \code{dLevel} specifying the level of detail.
#' 
#' @details All geometries are simplified using a tolerance of ten meters. 
#"
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' streamsMWR <- st_read('~/Desktop/NHD/NHDFlowline_fcode_46006_vis_101k_noattr.shp') %>% 
#'  st_zm() %>% 
#'  st_simplify(dTolerance = 10, preserveTopology = TRUE) %>% 
#'  # st_transform(crs = 4326) %>% 
#'  select(dLevel)
#' 
#' save(streamsMWR, file = 'data/streamsMWR.RData', compress = 'xz')
#' }
"streamsMWR"
