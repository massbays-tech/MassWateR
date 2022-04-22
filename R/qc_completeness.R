#' Run quality control completeness checks for water quality monitoring results
#'
#' @param res character string of path to eresults file or \code{data.frame} for results returned by \code{\link{read_results}}
#' @param dqocom character string of path to the data quality objectives file for completeness or \code{data.frame} returned by \code{\link{read_dqocompleteness}}
#' @param runchk  logical to run data checks with \code{\link{check_results}} and \code{\link{check_dqocompleteness}}, applies only if \code{res} or \code{dqocom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{read_results}} and \code{\link{read_dqocompleteness}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly.
#' 
#' Note that completeness is only evaluated on parameters in the \code{Parameter} column in the data quality objectives completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.
#' 
#' @return A summarized \code{data.frame} of completeness results for quality control in long format.  Each row applies to a specific completeness check for a parameter. The total observations (\code{obs}) for each parameter are also shown, which is repeated for a parameter across the rows to calculate percentages.  The \code{check} column shows the relevant activity type that is assessed for completeness, the \code{count} columns shows the number of observations that apply to the check, the \code{standard} shows the relevant percentage required for quality control check from the quality control objectives file, the \code{percent} column shows the calculated percent taken from the input data, and the \code{met} column shows if the standard was met by comparing if \code{percent} is greater than or equal to \code{standard}.
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
qc_completeness <- function(res, dqocom, runchk = TRUE, warn = TRUE){
  
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
    dqocomdat <- dqocom
  
  # import from path
  if(inherits(dqocom, 'character')){
    
    dqocompth <- dqocom
    chk <- file.exists(dqocompth)
    if(!chk)
      stop('File specified with dqocom argument not found')
    
    dqocomdat <- read_dqocompleteness(dqocompth, runchk = runchk)
    
  }
  
  ##
  # check parameters in completeness can be found in results
  dqocomprm <- sort(unique(dqocomdat$Parameter))
  resdatprm <- sort(unique(resdat$`Characteristic Name`))
  chk <- dqocomprm %in% resdatprm
  if(any(!chk) & warn){
    tochk <- dqocomprm[!chk]
    warning('Parameters in quality control objectives for completeness not found in results data: ', paste(tochk, collapse = ', '))
  }
  
  # parameters for completeness checks
  prms <- dqocomprm[chk]
  
  resall <- NULL
  
  # run completeness checks
  for(prm in prms){
    
    # subset dqo data
    dqocomdattmp <- dqocomdat %>% 
      dplyr::filter(Parameter == prm)
    
    # subset results data
    resdattmp <- resdat %>% 
      dplyr::filter(`Characteristic Name` == prm)
   
    # total obs
    ntot <- nrow(resdattmp)
    
    # field duplicates
    acts <- c('Quality Control Sample-Field Replicate', 'Quality Control Field Replicate Msr/Obs')
    fielddup <- sum(resdattmp$`Activity Type` %in% acts)
      
    # lab duplicates
    acts <- 'Quality Control Sample-Lab Duplicate'
    labdup <- sum(resdattmp$`Activity Type` %in% acts)
      
    # field blank
    acts <- 'Quality Control Sample-Field Blank'
    fieldblnk <- sum(resdattmp$`Activity Type` %in% acts)
      
    # lab blank
    acts <- 'Quality Control Sample-Lab Blank'
    labblnk <- sum(resdattmp$`Activity Type` %in% acts)
    
    # spikes/checks
    acts <- 'Quality Control Sample-Lab Spike'
    spikes <- sum(resdattmp$`Activity Type` %in% acts)
    
    # completeness
    complt <- ntot - (fielddup + labdup + fieldblnk + labblnk + spikes)
    
    # compile results
    res <- tibble::tibble(
      Parameter = prm, 
      obs = ntot,
      `Field Duplicate` = fielddup, 
      `Lab Duplicate` = labdup, 
      `Field Blank` = fieldblnk,
      `Lab Blank` = labblnk,
      `Spike/Check Accuracy` = spikes,
      `% Completeness` = complt
    )
    
    resall <- dplyr::bind_rows(resall, res)
    
  }

  # dqocomdat long format
  dqocomdat <- dqocomdat %>% 
    tidyr::pivot_longer(cols = -dplyr::matches('Parameter'), names_to = 'check', values_to = 'standard')
  
  # summary results long format
  resall <- resall %>% 
    tidyr::pivot_longer(cols = -dplyr::matches('^Parameter$|^obs$'), names_to = 'check', values_to = 'count')
  
  # combine and create summaries
  out <- resall %>% 
    dplyr::full_join(dqocomdat, by = c('Parameter', 'check')) %>% 
    dplyr::mutate(
      percent = 100 * count / obs,
      met = percent >= standard
    )
  
  return(out)
  
}