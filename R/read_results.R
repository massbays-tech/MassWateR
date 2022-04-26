#' Read water quality monitoring results from an external file
#'
#' @param respth character string of path to the results file
#' @param runchk logical to run data checks with \code{\link{check_results}}
#' @param tzone character string for time zone, passed to \code{\link{form_results}}
#'
#' @return A formatted water quality monitoring results data frame that can be used for downstream analysis
#' 
#' @details Date are imported with \code{\link[readxl]{read_excel}}, checked with \code{\link{check_results}}, and formatted with \code{\link{form_results}}.
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' resdat <- read_results(respth)
#' head(resdat)
read_results <- function(respth, runchk = TRUE, tzone = 'America/Jamaica'){
  
  resdat <- readxl::read_excel(respth, na = c('NA', 'na', ''), 
    col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
                  'text', 'text', 'text', 'text'))
  
  # run checks
  if(runchk)
    resdat <- check_results(resdat)
  
  # format results
  out <- form_results(resdat, tzone)
  
  return(out)
  
}