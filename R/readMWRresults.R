#' Read water quality monitoring results from an external file
#'
#' @param respth character string of path to the results file
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}}
#' @param tzone character string for time zone, passed to \code{\link{formMWRresults}}
#'
#' @return A formatted water quality monitoring results data frame that can be used for downstream analysis
#' 
#' @details Date are imported with \code{\link[readxl]{read_excel}}, checked with \code{\link{checkMWRresults}}, and formatted with \code{\link{formMWRresults}}.
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' resdat <- readMWRresults(respth)
#' head(resdat)
readMWRresults <- function(respth, runchk = TRUE, tzone = 'America/Jamaica'){
  
  resdat <- readxl::read_excel(respth, na = c('NA', 'na', ''), 
    col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
                  'text', 'text', 'text', 'text'))
  
  # run checks
  if(runchk)
    resdat <- checkMWRresults(resdat)
  
  # format results
  out <- formMWRresults(resdat, tzone)
  
  return(out)
  
}
