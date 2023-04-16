#' Verify summary function
#'
#' @param accdat \code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}
#' @param param character string for the parameter to evaluate as provided in the \code{"Parameter"} column of \code{"accdat"}
#' @param sumfun character indicating one of \code{"auto"} (default), \code{"mean"}, \code{"geomean"}, \code{"median"}, \code{"min"}, or \code{"max"}, see details
#'
#' @details This function verifies appropriate summary functions are passed from \code{sumfun}. The mean or geometric mean output is used for \code{sumfun = "auto"} based on information in the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are summarized with the geometric mean, otherwise arithmetic. Using \code{"mean"} or \code{"geomean"} for \code{sumfun} will apply the appropriate function regardless of information in the data quality objective file for accuracy.
#' 
#' @return Character indicating the appropriate summary function based on the value passed to \code{sumfun}.
#' @export
#'
#' @examples
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # geomean auto
#' utilMWRsumfun(accdat, param = 'E.coli')
#' 
#' # mean force
#' utilMWRsumfun(accdat, param = 'E.coli', sumfun = 'mean')
#' 
#' # mean auto
#' utilMWRsumfun(accdat, param = 'DO')
#' 
#' # geomean force
#' utilMWRsumfun(accdat, param = 'DO', sumfun = 'geomean')
utilMWRsumfun <- function(accdat, param, sumfun = 'auto'){
  
  # convert log, linear to geomean, mean for value from yscl
  sumfun <- ifelse(sumfun == 'linear', 'mean', ifelse(sumfun == 'log', 'geomean', sumfun))
  
  # very correct inputs
  sumfun <- match.arg(sumfun, c('auto', 'mean', 'geomean', 'median', 'min', 'max'))
  
  if(sumfun == 'auto'){
    
    # get scaling from accuracy data
    logscl <- accdat %>% 
      dplyr::filter(Parameter %in% param) %>% 
      unlist %>% 
      grepl('log', .) %>% 
      any
    
    sumfun <- ifelse(logscl, 'geomean', 'mean')
    
  }
  
  out <- sumfun
  
  return(out)
  
}
