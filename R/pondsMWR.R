#' A simple features object of ponds in Massachusetts
#' 
#' A simple features object of ponds in Massachusetts
#' 
#' @format A simple features object
#' 
#' @details All geometries are simplified using a tolerance of ten meters. 
#' 
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' pondsMWR <- st_read('~/Desktop/NHD/NHDWaterbody_ftype_390-493_vis_101k_noattr.shp') %>% 
#'  st_make_valid() %>% 
#'  st_simplify(dTolerance = 10, preserveTopology = TRUE) %>% 
#'  select(dLevel)
#' 
#' save(pondsMWR, file = 'data/pondsMWR.RData', compress = 'xz')
#' }
"pondsMWR"
