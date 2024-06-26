#' Run quality control completeness checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRfrecom}}, applies only if \code{res} or \code{frecom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.
#' 
#' Note that frequency is only evaluated on parameters in the \code{Parameter} column in the data quality objectives frequency and completeness file.  A warning is returned if there are parameters in \code{Parameter} in the frequency and completeness file that are not in \code{Characteristic Name} in the results file. 
#' 
#' Similarly, parameters in the results file in the \code{Characteristic Name} column that are not found in the data quality objectives frequency and completeness file are not evaluated.  A warning is returned if there are parameters in \code{Characteristic Name} in the results file that are not in \code{Parameter} in the frequency and completeness file.
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
qcMWRcom <- function(res = NULL, frecom = NULL, fset = NULL, runchk = TRUE, warn = TRUE){
  
  utilMWRinputcheck(mget(ls()))
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, frecom = frecom, fset = fset, runchk = runchk, warn = warn)
  resdat <- inp$resdat
  frecomdat <- inp$frecomdat
  
  ##
  # check parameter matches between results and completeness
  frecomprm <- sort(unique(frecomdat$Parameter))
  resdatprm <- sort(unique(resdat$`Characteristic Name`))
  
  # check parameters in completeness can be found in results  
  chk <- frecomprm %in% resdatprm
  if(any(!chk) & warn){
    tochk <- frecomprm[!chk]
    warning('Parameters in quality control objectives for frequency and completeness not found in results data: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  
  # check parameters in results can be found in completeness
  chk <- resdatprm %in% frecomprm
  if(any(!chk) & warn){
    tochk <- resdatprm[!chk]
    warning('Parameters in results not found in quality control objectives for frequency and completeness: ', paste(tochk, collapse = ', '), call. = FALSE)
  }

  # parameters for completeness checks
  prms <- intersect(resdatprm, frecomprm)

  resall <- NULL
  
  # run completeness checks
  for(prm in prms){
    
    # subset results data
    resdattmp <- resdat %>% 
      dplyr::filter(`Characteristic Name` == prm)

    # number of qualified records
    qualrec <- sum(!is.na(resdattmp$`Result Measure Qualifier`), na.rm = TRUE)
    
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
      complete = ifelse(
        !is.na(standard), 100 * (datarec - qualrec) / (datarec),
        NA_real_
      ),
      met = complete >= standard
    )
  
  return(out)
  
}
