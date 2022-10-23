#' Filter results data to surface measurements
#'
#' @param resdat results data as returned by \code{\link{readMWRresults}}
#'
#' @return \code{resdat} filtered by \code{Activity Depth/Height Measure} less than or equal to 1 meter or 3.3 feet or \code{Activity Relative Depth Name} as \code{"Surface"}
#' @export
#'
#' @details This function is used internally for all analysis functions
#' 
#' @examples
#' # results file path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#'
#' # filter surface data
#' utilMWRfiltersurface(resdat)
utilMWRfiltersurface <- function(resdat){
  
  out <- resdat %>%
    dplyr::filter(!`Activity Relative Depth Name` %in% c('Bottom', 'MidWater'))
  
  chkft <- as.numeric(out$`Activity Depth/Height Measure`) > 3.3 & out$`Activity Depth/Height Unit` == 'ft' & (is.na(out$`Activity Relative Depth Name`) | out$`Activity Relative Depth Name` != 'Surface')
  chkm <- as.numeric(out$`Activity Depth/Height Measure`) > 1 & out$`Activity Depth/Height Unit` == 'm' & (is.na(out$`Activity Relative Depth Name`) | out$`Activity Relative Depth Name` != 'Surface')

  out <- out[!chkft & !chkm, ]
 
  return(out)
  
}