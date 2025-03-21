#' Read censored data from an external file
#'
#' @param censpth character string of path to the censored file
#' @param runchk logical to run data checks with \code{\link{checkMWRcens}}
#' @param warn logical to return warnings to the console (default)
#'
#' @return A formatted censored data frame that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}}, checked with \code{\link{checkMWRcens}}, and formatted with \code{\link{formMWRcens}}.  The input file includes rows for each parameter and two columns indicating the parameter name and number of missed or censored records for that parameter.  The data are used to complete the number of missed and censored records column for the completeness table created with \code{\link{tabMWRcom}} and is an optional input.  The parameters in this file must match those in the data quality objectives file for frequency and completeness.
#' 
#' @export
#'
#' @examples
#' censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')
#' 
#' censdat <- readMWRcens(censpth)
#' head(censdat)
readMWRcens <- function(censpth, runchk = TRUE, warn = TRUE){
  
  censdat <- suppressWarnings(readxl::read_excel(censpth, na = c('NA', 'na', ''), guess_max = Inf))
  
  # run checks
  if(runchk)
    censdat <- checkMWRcens(censdat, warn = warn)
  
  # format results
  out <- formMWRcens(censdat)
  
  return(out)
  
}
