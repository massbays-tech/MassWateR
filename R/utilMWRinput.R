#' Utility function to import data as paths or data frames
#' 
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRfrecom}}, applies only if \code{res} or \code{frecom} are file paths
#'
#' @details The function is used internally by others to import data from paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.
#'
#' @return A two element list with the imported results and data quality objectives, named \code{"resdat"} and \code{"frecomdat"}, respectively.
#' 
#' @export
#'
#' @examples
#' ##
#' # using file paths
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness_final.xlsx', 
#'      package = 'MassWateR')
#' 
#' inp <- utilMWRinput(res = respth, frecom = frecompth)
#' inp$resdat
#' inp$frecomdat
#' 
#' ##
#' # using data frames
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # frequency and completeness data
#' frecomdat <- readMWRfrecom(frecompth)
#' 
#' inp <- utilMWRinput(res = respth, frecom = frecompth)
#' inp$resdat
#' inp$frecomdat
utilMWRinput <- function(res, frecom, runchk = TRUE){
  
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

  out <- list(
    resdat = resdat,
    frecomdat = frecomdat
  )
  
  return(out)
  
}