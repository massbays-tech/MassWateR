#' Create a formatted table of quality control completeness checks
#'
#' @inheritParams qcMWRcom 
#' @param pass_col character string for the cell color of checks that pass
#' @param fail_col character string for the cell color of checks that fail
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results showing summary counts for all completeness checks for each parameter.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly.  Also note that completeness is only evaluated on parameters that are shared between the results file and data quality objectives file for frequency and completeness. A warning is returned for parameters that do not match between the files. This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' A summary table showing the number of data records, number of qualified records, and percent completeness is created.  The \code{% Completeness} column shows cells as green or red if the required percentage of observations for completeness are present as specified in the data quality objectives file.  The \code{Hit/Miss} column shows similar information but in text format, i.e., \code{MISS} is shown if the quality control standard for completeness is not met.
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
#' tabMWRcom(res = respth, frecom = frecompth)
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
#' tabMWRcom(res = resdat, frecom = frecomdat)
#' 
tabMWRcom <- function(res, frecom, runchk = TRUE, warn = TRUE, pass_col = 'green', fail_col = 'red', digits = 0, suffix = '%'){

  # table theme
  thm <- function(x, ...){
    x <- flextable::colformat_double(x, digits = digits, na_str = '-', suffix = suffix)
    flextable::autofit(x)
  }
  
  # get completeness summary
  res <- qcMWRcom(res = res, frecom = frecom, runchk = runchk, warn = warn)

  # get summary table
  totab <- res %>% 
    dplyr::select(-standard) %>% 
    dplyr::mutate(
      met = as.numeric(met),
      `Hit/Miss` = ifelse(met == 1, '', 'MISS'),
      `Number of Censored Records` = '',
      Notes = ''
    ) %>% 
    dplyr::rename(
      `Number of Data Records` = datarec, 
      `Number of Qualified Records` = qualrec, 
      `% Completeness` = complete
    )
  
  tab <- flextable::flextable(totab, col_keys = grep('^met$', names(totab), value = T, invert = T)) %>% 
    flextable::bg(i = ~ `met` == 0, j = '% Completeness', bg = fail_col) %>% 
    flextable::bg(i = ~ `met` == 1, j = '% Completeness', bg = pass_col) %>% 
    thm %>% 
    flextable::align(align = 'left', part = 'all') %>% 
    flextable::border_inner() %>% 
    flextable::width(j = 'Notes', width = 3)
  
  return(tab)
  
}
