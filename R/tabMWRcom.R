#' Create a formatted table of quality control completeness checks
#'
#' @inheritParams qcMWRcom 
#' @param pass_col character string for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results showing summary counts for all completeness checks for each parameter.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly.  Also note that completeness is only evaluated on parameters in the \code{Parameter} column in the data quality objectives completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.  This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' A summary table showing the the total number of qualified records (those collected for data quality objective checks), and percent completeness (the difference between the two) is created.  The \code{% Completeness} column shows cells as green or red if the required percentage of observations for completeness are present as specified in the data quality objectives file.
#' 
#' Inputs for the results and data quality objectives for completeness are processed internally with \code{\link{qcMWRcom}} and the same arguments are accepted for this function, in addition to others listed above. 
#' 
#' @export
#'
#' @examples
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' # completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness_final.xlsx', 
#'      package = 'MassWateR')
#' 
#' tabMWRcom(res = respth, frecom = frecompth)
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
