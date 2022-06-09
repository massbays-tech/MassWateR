#' Utility function to import data as paths or data frames
#' 
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRfrecom}}, applies only if \code{res}, \code{acc}, or \code{frecom} are file paths
#'
#' @details The function is used internally by others to import data from paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRacc}}, and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.
#' 
#' The data quality objective file arguments for \code{acc} and \code{frecom} can be \code{NULL}, used as a convenience for downstream functions that do not require both. 
#'
#' @return A three element list with the imported results and data quality objective files, named \code{"resdat"}, \code{"accdat"}, and \code{"frecomdat"}, respectively.
#' 
#' @export
#'
#' @examples
#' ##
#' # using file paths
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' inp <- utilMWRinput(res = respth, acc = accpth, frecom = frecompth)
#' inp$resdat
#' inp$accdat
#' inp$frecomdat
#' 
#' ##
#' # using data frames
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # frequency and completeness data
#' frecomdat <- readMWRfrecom(frecompth)
#' 
#' inp <- utilMWRinput(res = resdat, acc = accdat, frecom = frecomdat)
#' inp$resdat
#' inp$accdat
#' inp$frecomdat
utilMWRinput <- function(res = NULL, acc = NULL, frecom = NULL, runchk = TRUE){
  
  ##
  # results input
  
  # data frame
  if(inherits(res, 'data.frame'))
    resdat <- res
  
  # import from path
  if(inherits(res, 'character')){
    
    respth <- res
    chk <- file.exists(respth)
    if(!chk)
      stop('File specified with res argument not found')
    
    resdat <- readMWRresults(respth, runchk = runchk)
    
  }
  
  if(inherits(res, 'NULL'))
    resdat <-  NULL
  
  ##
  # dqo accuracy input
  
  # data frame
  if(inherits(acc, 'data.frame'))
    accdat <- acc
  
  # import from path
  if(inherits(acc, 'character')){
    
    accpth <- acc
    chk <- file.exists(accpth)
    if(!chk)
      stop('File specified with acc argument not found')
    
    accdat <- readMWRacc(accpth, runchk = runchk)
    
  }
  
  if(inherits(acc, 'NULL'))
    accdat <-  NULL
  
  ##
  # dqo frequency and completeness input
  
  # data frame
  if(inherits(frecom, 'data.frame'))
    frecomdat <- frecom
  
  # import from path
  if(inherits(frecom, 'character')){
    
    frecompth <- frecom
    chk <- file.exists(frecompth)
    if(!chk)
      stop('File specified with frecom argument not found')
    
    frecomdat <- readMWRfrecom(frecompth, runchk = runchk)
    
  }
  
  if(inherits(frecom, 'NULL'))
    frecomdat <- NULL

  ##
  # output
  
  out <- list(
    resdat = resdat,
    accdat = accdat,
    frecomdat = frecomdat
  )
  
  return(out)
  
}
