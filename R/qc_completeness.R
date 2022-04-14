#' Run quality control completeness checks for water quality monitoring results
#'
#' @param res character string of path to eresults file or \code{data.frame} for results returned by \code{\link{read_results}}
#' @param dqocom character string of path to the data quality objectives file for completeness or \code{data.frame} returned by \code{\link{read_dqocompleteness}}
#' @param runchk  logical to run data checks with \code{\link{check_results}} and \code{\link{check_dqocompleteness}}, applies only if \code{res} or \code{dqocom} are file paths
#'
#' @details The function can be used with inputs as file paths to the relevant files or as data frames returned by \code{\link{read_results}} and \code{\link{read_dqocompleteness}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default).
#' 
#' @return A summarized \code{data.frame} of completeness results for quality control
#' @export
#'
#' @examples
#' ##
#' # using file paths
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' # completeness path
#' dqocompth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
#' 
#' qc_completeness(res = respth, dqocom = dqocompth)
#' 
#' ##
#' # using data frames
#' 
#' # results data
#' resdat <- read_results(respth)
#' 
#' # completeness data
#' dqocomdat <- read_dqocompleteness(dqocompth)
#' 
#' qc_completeness(res = resdat, dqocom = dqocomdat)
#' 
qc_completeness <- function(res, dqocom, runchk = TRUE){
  
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
    
    resdat <- read_results(respth, runchk = runchk)
    
  }
  
  ##
  # dqo completeness input
  
  # data frame
  if(inherits(dqocom, 'data.frame'))
    dqocomdatdat <- dqocom
  
  # import from path
  if(inherits(dqocom, 'character')){
    
    dqocompth <- dqocom
    chk <- file.exists(dqocompth)
    if(!chk)
      stop('File specified with dqocom argument not found')
    
    dqocomdat <- read_dqocompleteness(dqocompth, runchk = runchk)
    
  }
  
  # check parameters in completeness can be found in results
  
  return()
  
}