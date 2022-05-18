#' Run quality control frequency checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param warn logical to return warnings to the console (default)
#'
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly.
#' 
#' Note that frequency is only evaluated on parameters in the \code{Parameter} column in the data quality objectives completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.
#' 
#' @return The output shows the frequency checks from the input files.  Each row applies to a frequency check for a parameter. The \code{Parameter} column shows the parameter, the \code{obs} column shows the total records that apply to regular activity types, the \code{check} column shows the relevant activity type for each frequency check, the \code{count} column shows the number of records that apply to a check, the \code{standard} column shows the relevant percentage required for the quality control check from the quality control objectives file, and the \code{met} column shows if the standard was met by comparing if \code{percent} is greater than or equal to \code{standard}.
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
#' qcMWRfre(res = respth, frecom = frecompth)
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
#' qcMWRfre(res = resdat, frecom = frecomdat)
#' 
qcMWRfre <- function(res, frecom, runchk = TRUE, warn = TRUE){
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, frecom = frecom)
  resdat <- inp$resdat
  frecomdat <- inp$frecomdat
  
  ##
  # check parameters in frequency and completeness can be found in results
  frecomprm <- sort(unique(frecomdat$Parameter))
  resdatprm <- sort(unique(resdat$`Characteristic Name`))
  chk <- frecomprm %in% resdatprm
  if(any(!chk) & warn){
    tochk <- frecomprm[!chk]
    warning('Parameters in quality control objectives for frequency and completeness not found in results data: ', paste(tochk, collapse = ', '))
  }
  
  # parameters for frequency checks
  prms <- frecomprm[chk]
  
  resall <- NULL
  
  # run completeness checks
  for(prm in prms){
    
    # subset dqo data
    frecomdattmp <- frecomdat %>% 
      dplyr::filter(Parameter == prm)
    
    # subset results data
    resdattmp <- resdat %>% 
      dplyr::filter(`Characteristic Name` == prm)

    # total obs
    ntot <- resdattmp %>% 
      dplyr::filter(`Activity Type` %in% c('Sample-Routine', 'Field Msr/Obs')) %>% 
      dplyr::filter(is.na(`QC Reference Value`)) %>% 
      nrow()
    
    # field duplicates
    fielddup <- resdattmp %>% 
      dplyr::filter(`Activity Type` %in% c('Sample-Routine', 'Field Msr/Obs')) %>% 
      dplyr::filter(!is.na(`QC Reference Value`)) %>% 
      nrow()
    
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
    
    # compile results
    res <- tibble::tibble(
      Parameter = prm, 
      obs = ntot,
      `Field Duplicate` = fielddup, 
      `Lab Duplicate` = labdup, 
      `Field Blank` = fieldblnk,
      `Lab Blank` = labblnk,
      `Spike/Check Accuracy` = spikes
    )
    
    resall <- dplyr::bind_rows(resall, res)
    
  }
  
  # frecomdat long format
  frecomdat <- frecomdat %>% 
    tidyr::pivot_longer(cols = -dplyr::matches('Parameter'), names_to = 'check', values_to = 'standard')
  
  # summary results long format
  resall <- resall %>% 
    tidyr::pivot_longer(cols = -dplyr::matches('^Parameter$|^obs$'), names_to = 'check', values_to = 'count')

  # combine and create summaries
  out <- resall %>% 
    dplyr::left_join(frecomdat, by = c('Parameter', 'check')) %>% 
    dplyr::mutate(
      percent = dplyr::case_when(
        !is.na(standard) ~ 100 * count / obs,
        T ~ NA_real_
      ),
      met = percent >= standard
    )
  
  return(out)
  
}