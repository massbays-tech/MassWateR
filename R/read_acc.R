#' Read data quality objectives for accuracy from an external file
#'
#' @param accpth character string of path to the data quality objectives file for accuracy
#' @param runchk logical to run data checks with \code{\link{check_acc}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_acc}}.
#' 
#' @export
#'
#' @examples
#' accpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' accdat <- read_acc(accpth)
#' head(accdat)
read_acc <- function(accpth, runchk = TRUE){
  
  accdat <- readxl::read_excel(accpth, na = c('NA', 'na', ''))
  
  # run checks
  if(runchk)
    accdat <- check_acc(accdat)
  
  # format acc
  out <- form_acc(accdat)
  
  return(out)
  
}
