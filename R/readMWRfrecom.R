#' Read data quality objectives for frequency and completeness from an external file
#'
#' @param frecompth character string of path to the data quality objectives file for frequency and completeness
#' @param runchk logical to run data checks with \code{\link{checkMWRfrecom}}
#' @param warn logical to return warnings to the console (default)
#'
#' @return A formatted data frame of data quality objectives for frequency and completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{checkMWRfrecom}}.
#' 
#' @export
#'
#' @examples
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' frecomdat <- readMWRfrecom(frecompth)
#' head(frecomdat)
readMWRfrecom <- function(frecompth, runchk = TRUE, warn = TRUE){
  
  frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
      skip = 1, na = c('NA', 'na', ''), 
      col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
    )) %>% 
    rename(`% Completeness` = `...7`)
  
  # run checks
  if(runchk)
    frecomdat <- checkMWRfrecom(frecomdat, warn = warn)
  
  # format frecom
  out <- formMWRfrecom(frecomdat)
  
  return(out)
  
}
