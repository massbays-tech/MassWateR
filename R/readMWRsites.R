#' Read site metadata from an external file
#'
#' @param sitpth character string of path to the site metadata file
#' @param runchk logical to run data checks with \code{\link{checkMWRsites}}
#'
#' @return A formatted data frame of site metadata that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{checkMWRsites}}.
#' 
#' @export
#'
#' @examples
#' sitpth <- system.file('extdata/ExampleSites_final.xlsx', package = 'MassWateR')
#' 
#' sitdat <- readMWRsites(sitpth)
#' head(sitdat)
readMWRsites <- function(sitpth, runchk = TRUE){
  
  sitdat <- readxl::read_excel(sitpth, na = c('NA', 'na', ''))
  
  # run checks
  if(runchk)
    sitdat <- checkMWRsites(sitdat)
  
  out <- sitdat
  
  return(out)
  
}
