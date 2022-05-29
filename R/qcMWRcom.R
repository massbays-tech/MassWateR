#' Run quality control completeness checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRfrecom}}, applies only if \code{res} or \code{frecom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly.
#' 
#' Note that completeness is only evaluated on parameters in the \code{Parameter} column in the data quality objectives completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.
#' 
#' @return The output shows the completeness checks from the combined files.  Each row applies to a completeness check for a parameter. The \code{datarec} and \code{qualrec} columns show the number of data records and qualified records, respectively. The \code{datarec} column specifically shows only records not for quality control by excluding those as duplicates, blanks, or spikes in the count. The \code{standard} column shows the relevant percentage required for the quality control check from the quality control objectives file, the \code{complete} column shows the calculated completeness taken from the input data, and the \code{met} column shows if the standard was met by comparing if \code{complete} is greater than or equal to \code{standard}.
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
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' qcMWRcom(res = respth, frecom = frecompth)
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
#' qcMWRcom(res = resdat, frecom = frecomdat)
#' 
qcMWRcom <- function(res, frecom, runchk = TRUE, warn = TRUE){
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, frecom = frecom, runchk = runchk)
  resdat <- inp$resdat
  frecomdat <- inp$frecomdat
  
  ##
  # check parameters in frequency completeness can be found in results
  frecomprm <- sort(unique(frecomdat$Parameter))
  resdatprm <- sort(unique(resdat$`Characteristic Name`))
  chk <- frecomprm %in% resdatprm
  if(any(!chk) & warn){
    tochk <- frecomprm[!chk]
    warning('Parameters in quality control objectives for frequency and completeness not found in results data: ', paste(tochk, collapse = ', '))
  }
  
  # parameters for completeness checks
  prms <- frecomprm[chk]

  resall <- NULL
  
  # run completeness checks
  for(prm in prms){
    
    # subset results data
    resdattmp <- resdat %>% 
      dplyr::filter(`Characteristic Name` == prm)
    
    # number of qualified records
    qualrec <- sum(resdattmp$`Result Measure Qualifier` == 'Q', na.rm = TRUE)
    
    # number of data records
    datarec <- sum(resdattmp$`Activity Type` %in% c("Field Msr/Obs", "Sample-Routine"), na.rm = T)
    
    # compile results
    res <- tibble::tibble(
      Parameter = prm, 
      datarec = datarec,
      qualrec = qualrec
    )
    
    resall <- dplyr::bind_rows(resall, res)
    
  }

  # frecomdat long format
  frecomdat <- frecomdat %>% 
    dplyr::select(Parameter, standard = `% Completeness`)

  # combine and create summaries
  out <- resall %>% 
    dplyr::left_join(frecomdat, by = 'Parameter') %>% 
    dplyr::mutate(
      complete = dplyr::case_when(
        !is.na(standard) ~ 100 * (datarec - qualrec) / (datarec),
        T ~ NA_real_
      ),
      met = complete >= standard
    )
  
  return(out)
  
}
