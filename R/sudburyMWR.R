#' A simple features object of the Sudbury River watershed
#' 
#' A simple features object of the Sudbury River watershed
#' 
#' @format A simple features object of linestring geometries
#"
#' @examples 
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' 
#' sudburyMWR <- st_read('~/Desktop/Sudbury_watershed_singleboundary/Sudbury_watershed_singleboundary.shp') %>% 
#'  st_zm()
#' 
#' save(sudburyMWR, file = 'data/subdburyMWR.RData', compress = 'xz')
#' }
"sudburyMWR"