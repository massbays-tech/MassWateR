#' Analyze outliers in results file
#' 
#' Analyze outliers in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform entries in the \code{"Simple Parameter"} of \code{\link{paramsMWR}}
#' @param type character indicating whether the summaries are grouped by month (default) or site
#' @param threshold logical indicating if threshold lines are applied to the plot from \code{\link{thresholdMWR}}, if available
#' @param outliertxt logical indicating if outliers are returned to the console after plotting
#'
#' @return
#' @export
#'
#' @examples
#' NULL
anlzMWRoutlier <- function(res, param, type = c('month', 'site'), threshold = FALSE, outliertxt = FALSE){
  
  NULL
}