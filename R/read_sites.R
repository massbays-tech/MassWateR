#' Read site metadata from an external file
#'
#' @param pth character string of path to the file
#' @param runchk logical to run data checks with \code{\link{check_sites}}
#'
#' @return A formatted data frame of site metadata that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_sites}}.
#' 
#' @export
#'
#' @examples
#' pth <- system.file('extdata/ExampleSites_final.xlsx', package = 'MassWateR')
#' 
#' sites <- read_sites(pth)
#' head(sites)
read_sites <- function(pth, runchk = TRUE){
  
  dat <- readxl::read_excel(pth, na = c('na', ''))
  
  # run checks
  if(runchk)
    dat <- check_sites(dat)
  
  out <- dat
  
  return(out)
  
}