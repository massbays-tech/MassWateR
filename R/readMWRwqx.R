#' Read water quality exchange (wqx) metadata input from an external file
#'
#' @param wqxpth character string of path to the wqx metadata file
#' @param runchk logical to run data checks with \code{\link{checkMWRwqx}}
#' @param warn logical to return warnings to the console (default)
#'
#' @return A formatted data frame that can be used for downstream analysis
#' 
#' @details Date are imported with \code{\link[readxl]{read_excel}}, checked with \code{\link{checkMWRwqx}}.
#' 
#' @export
#'
#' @examples
#' wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')
#' 
#' wqxdat <- readMWRwqx(wqxpth)
#' head(wqxdat)
readMWRwqx <- function(wqxpth, runchk = TRUE, warn = TRUE){
  
  wqxdat <- suppressWarnings(readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text'))
  
  # run checks
  if(runchk)
    wqxdat <- checkMWRwqx(wqxdat, warn = warn)
  
  # format results
  out <- formMWRwqx(wqxdat)
  
  return(out)
  
}