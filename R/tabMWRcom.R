#' Create a formatted table of quality control completeness checks
#'
#' @inheritParams qcMWRcom 
#' @param pass_col character string (as hex code) for the cell color of checks that pass
#' @param fail_col character string (as hex code) for the cell color of checks that fail
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#' @param parameterwd numeric indicating width of the parameter column
#' @param noteswd numeric indicating width of notes column
#'
#' @return A \code{\link[flextable]{flextable}} object with formatted results showing summary counts for all completeness checks for each parameter.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRfrecom}}, and \code{\link{readMWRcens}} (optional).  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.  
#' 
#' Also note that completeness is only evaluated on parameters that are shared between the results file and data quality objectives file for frequency and completeness. A warning is returned for parameters that do not match between the files. A similar warning is returned if there are parameters in the censored data, if provided, that are not in the results file and vice versa. These warnings can be suppressed by setting \code{warn = FALSE}. 
#' 
#' A summary table showing the number of data records, number of qualified records, and percent completeness is created.  The \code{% Completeness} column shows cells as green or red if the required percentage of observations for completeness are present as specified in the data quality objectives file.  The \code{Hit/ Miss} column shows similar information but in text format, i.e., \code{MISS} is shown if the quality control standard for completeness is not met.
#' 
#' Inputs for the results and data quality objectives for frequency and completeness are processed internally with \code{\link{qcMWRcom}} and the same arguments are accepted for this function, in addition to others listed above. 
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
#' # censored path
#' censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')
#' 
#' tabMWRcom(res = respth, frecom = frecompth, cens = censpth)
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
#' # censored data
#' censdat <- readMWRcens(censpth)
#' 
#' tabMWRcom(res = resdat, frecom = frecomdat, cens = censdat)
#' 
tabMWRcom <- function(res = NULL, frecom = NULL, cens = NULL, fset = NULL, runchk = TRUE, warn = TRUE, pass_col = '#57C4AD', fail_col = '#DB4325', digits = 0, suffix = '%', parameterwd = 1.15, noteswd = 3){

  utilMWRinputcheck(mget(ls()), 'cens')
  
  # table theme
  thm <- function(x, ...){
    x <- flextable::colformat_double(x, digits = digits, na_str = '-', suffix = suffix) %>% 
      flextable::colformat_int(na_str = '-')
    flextable::autofit(x)
  }
  
  # get completeness summary
  res <- qcMWRcom(res = res, frecom = frecom, cens = cens, fset = fset, runchk = runchk, warn = warn)

  # get summary table
  totab <- res %>% 
    dplyr::mutate(
      met = as.numeric(met),
      `Hit/ Miss` = ifelse(met == 1, '', 'MISS'),
      Notes = ''
    ) %>% 
    dplyr::select(
      Parameter, datarec, qualrec, `Missed and Censored Records`, complete, `Hit/ Miss`, Notes, met
    ) %>% 
    dplyr::rename(
      `Number of Data Records` = datarec, 
      `Number of Qualified Records` = qualrec, 
      `Number of Missed/ Censored Records` = `Missed and Censored Records`,
      `% Completeness` = complete
    )
  
  tab <- flextable::flextable(totab, col_keys = grep('^met$', names(totab), value = T, invert = T)) %>% 
    flextable::bg(i = ~ `met` == 0, j = '% Completeness', bg = fail_col) %>% 
    flextable::bg(i = ~ `met` == 1, j = '% Completeness', bg = pass_col) %>% 
    thm %>% 
    flextable::align(align = 'left', part = 'all') %>% 
    flextable::border_inner() %>% 
    flextable::width(j = 'Parameter', width = parameterwd) %>% 
    flextable::width(j = 'Notes', width = noteswd)
  
  return(tab)
  
}
