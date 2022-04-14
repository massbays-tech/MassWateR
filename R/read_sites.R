#' Read site metadata from an external file
#'
#' @param sitpth character string of path to the site metadata file
#' @param runchk logical to run data checks with \code{\link{check_sites}}
#'
#' @return A formatted data frame of site metadata that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_sites}}.
#' 
#' @export
#'
#' @examples
#' sitpth <- system.file('extdata/ExampleSites_final.xlsx', package = 'MassWateR')
#' 
#' sitdat <- read_sites(sitpth)
#' head(sitdat)
read_sites <- function(sitpth, runchk = TRUE){
  
  sitdat <- readxl::read_excel(sitpth, na = c('na', ''))
  
  # run checks
  if(runchk)
    sitdat <- check_sites(sitdat)
  
  out <- sitdat
  
  return(out)
  
}