#' Read data quality objectives for accuracy from an external file
#'
#' @param accpth character string of path to the data quality objectives file for accuracy
#' @param runchk logical to run data checks with \code{\link{checkMWRacc}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{checkMWRacc}}.
#' 
#' @export
#'
#' @examples
#' accpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' accdat <- readMWRacc(accpth)
#' head(accdat)
readMWRacc <- function(accpth, runchk = TRUE){
  
  accdat <- readxl::read_excel(accpth, na = c('NA', 'na', ''))
  
  # run checks
  if(runchk)
    accdat <- checkMWRacc(accdat)
  
  # format acc
  out <- formMWRacc(accdat)
  
  return(out)
  
}
