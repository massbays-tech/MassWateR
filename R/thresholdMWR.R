#' Master thresholds list for analysis of results data
#' 
#' Master thresholds list for analysis of results data
#' 
#' @format A \code{data.frame} of 39 rows and 6 columns
#' 
#' @details This file includes appropriate threshold values of water quality parameters for marine and freshwater environments based on state standards or typical ranges in Massachusetts.  
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' library(dplyr)
#' 
#' thresholdMWR <- read_excel('inst/extdata/ThresholdMapping.xlsx', na = 'NA') %>% 
#'   rename(
#'     `Simple Parameter` = Simple_Parameter,
#'     uom = UOM
#'   )
#' 
#' save(thresholdMWR, file = 'data/threhsoldMWR.RData', compress = 'xz')
#' }
"thresholdMWR"
