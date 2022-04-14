#' Read data quality objectives for accuracy from an external file
#'
#' @param dqoaccpth character string of path to the data quality objectives file for accuracy
#' @param runchk logical to run data checks with \code{\link{check_dqoaccuracy}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_dqoaccuracy}}.
#' 
#' @export
#'
#' @examples
#' dqoaccpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' dqoaccdat <- read_dqoaccuracy(dqoaccpth)
#' head(dqoaccdat)
read_dqoaccuracy <- function(dqoaccpth, runchk = TRUE){
  
  dqoaccdat <- readxl::read_excel(dqoaccpth, na = c('na', ''))
  
  # run checks
  if(runchk)
    dqoaccdat <- check_dqoaccuracy(dqoaccdat)
  
  out <- dqoaccdat
  
  return(out)
  
}