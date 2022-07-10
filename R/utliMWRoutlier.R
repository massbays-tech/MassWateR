#' Identify outliers in a numeric vector
#'
#' @param x numeric vector of any length 
#' @param logscl logical to indicate if vector should be log10-transformed first
#'
#' @return A logical vector equal in length to \code{x} indicating \code{TRUE} for outliers or \code{FALSE} for within normal range
#' @export
#'
#' @details Outliers are identified as 1.5 times the interquartile range
#' 
#' @examples
#' x <- rnorm(20)
#' utilMWRoutlier(x, logscl = FALSE)
utilMWRoutlier <- function(x, logscl){
  
  if(logscl)
    x <- log10(x)
  
  out <- x < quantile(x, 0.25, na.rm = TRUE) - 1.5 * IQR(x, na.rm = T) | x > quantile(x, 0.75, na.rm = TRUE) + 1.5 * IQR(x, na.rm = T)
  return(out)
  
}