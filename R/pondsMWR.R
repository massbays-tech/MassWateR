#' A geometry set of ponds in Massachusetts
#' 
#' A geometry set of ponds in Massachusetts
#' 
#' @format A geometry set
#' 
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' pondsMWR <- st_read('~/Desktop/NHD/NHDWaterbody_ftype_390_vis_101k_noattr.shp') %>% 
#'  st_make_valid() %>% 
#'  st_simplify(dTolerance = 10, preserveTopology = TRUE) %>% 
#'  st_geometry()
#' 
#' save(pondsMWR, file = 'data/pondsMWR.RData', compress = 'xz')
#' }
"pondsMWR"
