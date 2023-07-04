#' Read data quality objectives for accuracy from an external file
#'
#' @param accpth character string of path to the data quality objectives file for accuracy
#' @param runchk logical to run data checks with \code{\link{checkMWRacc}}
#' @param warn logical to return warnings to the console (default)
#' 
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{checkMWRacc}}.
#' 
#' @export
#'
#' @examples
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' accdat <- readMWRacc(accpth)
#' head(accdat)
readMWRacc <- function(accpth, runchk = TRUE, warn = TRUE){
  
  # na chr not set as NA because of check for na in value range column
  accdat <- readxl::read_excel(accpth, na = c('NA', ''))
  accdat <- dplyr::mutate(accdat, dplyr::across(-c(`Value Range`), ~ dplyr::na_if(.x, 'na')))
  
  # run checks
  if(runchk)
    accdat <- checkMWRacc(accdat, warn = warn)
  
  # format acc
  out <- formMWRacc(accdat)
  
  return(out)
  
}
