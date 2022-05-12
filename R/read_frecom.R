#' Read data quality objectives for completeness from an external file
#'
#' @param frecompth character string of path to the data quality objectives file for completeness
#' @param runchk logical to run data checks with \code{\link{check_frecom}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_frecom}}.
#' 
#' @export
#'
#' @examples
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness_final.xlsx', 
#'      package = 'MassWateR')
#' 
#' frecomdat <- read_frecom(frecompth)
#' head(frecomdat)
read_frecom <- function(frecompth, runchk = TRUE){
  
  frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
      skip = 1, na = c('NA', 'na', ''), 
      col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
    )) %>% 
    rename(`% Completeness` = `...7`)
  
  # run checks
  if(runchk)
    frecomdat <- check_frecom(frecomdat)
  
  # format frecom
  out <- form_frecom(frecomdat)
  
  return(out)
  
}
