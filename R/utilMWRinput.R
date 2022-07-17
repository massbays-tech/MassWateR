#' Utility function to import data as paths or data frames
#' 
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param sit character string of path to the site metadata file or \code{data.frame} for site metadata returned by \code{\link{readMWRsites}}
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRfrecom}}, applies only if \code{res}, \code{acc}, or \code{frecom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @details The function is used internally by others to import data from paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRacc}}, \code{\link{readMWRfrecom}}, and \code{\link{readMWRsites}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.
#' 
#' Any of the arguments for the data files can be \code{NULL}, used as a convenience for downstream functions that do not require all. 
#'
#' @return A four element list with the imported results, data quality objective files, and site metadata file named \code{"resdat"}, \code{"accdat"}, \code{"frecomdat"}, and \code{"sitdat"}, respectively.
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
#' # site path
#' sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')
#' 
#' inp <- utilMWRinput(res = respth, acc = accpth, frecom = frecompth, sit = sitpth)
#' inp$resdat
#' inp$accdat
#' inp$frecomdat
#' inp$sitdat
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
#' # site data
#' sitdat <- readMWRsites(sitpth)
#' 
#' inp <- utilMWRinput(res = resdat, acc = accdat, frecom = frecomdat, sit = sitdat)
#' inp$resdat
#' inp$accdat
#' inp$frecomdat
#' inp$sitdat
utilMWRinput <- function(res = NULL, acc = NULL, frecom = NULL, sit = NULL, runchk = TRUE, warn = TRUE){
  
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
    
    resdat <- readMWRresults(respth, runchk = runchk, warn = warn)
    
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
  # site data
  
  # data frame
  if(inherits(sit, 'data.frame'))
    sitdat <- sit
  
  # import from path
  if(inherits(sit, 'character')){
    
    sitpth <- sit
    chk <- file.exists(sitpth)
    if(!chk)
      stop('File specified with sit argument not found')
    
    sitdat <- readMWRsites(sitpth, runchk = runchk)
    
  }
  
  if(inherits(sit, 'NULL'))
    sitdat <- NULL
  
  ##
  # output
  
  out <- list(
    resdat = resdat,
    accdat = accdat,
    frecomdat = frecomdat,
    sitdat = sitdat
  )
  
  return(out)
  
}
