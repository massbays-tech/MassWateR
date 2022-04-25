#' Create a formatted table of quality control completeness checks
#'
#' @inheritParams qc_completeness 
#' @param type character string indicating if a summary or percentage table is returned
#' @param pass_col character string for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results showing summary counts if \code{type = 'summary'} or percentage observations if \code{type = 'percent'} for all completeness checks for each parameter.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{read_results}} and \code{\link{read_dqocompleteness}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly.  Also note that completeness is only evaluated on parameters in the \code{Parameter} column in the data quality objectives completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.  This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' A summary table showing the total number of records, the total number of qualified records (those collected for data quality objective checks), and percent completeness (the difference between the two) can be created by setting \code{type = 'summary'}.  The \code{% Completeness} column shows cells as green or red if the required percentage of observations for completeness are present as specified in the data quality objectives file. Note that a warning message is returned for parameters that are found in the data quality objectives file, but are not found in the results data. Completeness checks are done only on parameters that are shared between the two.
#' 
#' A second table showing the percentage of observations in the results file that satisfy the checks (e.g., percent field duplicates, etc.) can be created by setting \code{type = 'percent'}.  As in the previous table, cells are are shown in green or red if the required percentage of observations are present for each check as specified in the data quality objectives file.
#'
#' Inputs for the results and data quality objectives for completeness are processed internally with \code{\link{qc_completeness}} and the same arguments are accepted for this function, in addition to others listed above. 
#' 
#' @export
#'
#' @examples
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' # completeness path
#' dqocompth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
#' 
#' ## 
#' # summary table 
#' 
#' tab_completeness(res = respth, dqocom = dqocompth, type = 'summary')
#' 
#' ## 
#' # percent table 
#' 
#' tab_completeness(res = respth, dqocom = dqocompth, type = 'percent')
#' 
tab_completeness <- function(res, dqocom, runchk = TRUE, warn = TRUE, type = c('summary', 'percent'), pass_col = 'green', fail_col = 'red', digits = 0, suffix = '%'){
  
  type <- match.arg(type)
  
  
  # table theme
  thm <- function(x, ...){
    x <- flextable::colformat_double(x, digits = digits, na_str = '-', suffix = suffix)
    flextable::autofit(x)
  }
  
  # get completeness summary
  res <- qc_completeness(res = res, dqocom = dqocom, runchk = runchk, warn = warn)
  
  # get summary table
  if(type == 'summary'){

    totab <- res %>% 
      dplyr::filter(check %in% '% Completeness') %>% 
      dplyr::select(-standard) %>% 
      dplyr::mutate(met = as.numeric(met)) %>% 
      tidyr::pivot_longer(cols = c('percent', 'met')) %>% 
      tidyr::unite('check', check, name) %>% 
      dplyr::mutate(
        check = gsub('\\_percent', '', check)
      ) %>% 
      tidyr::pivot_wider(names_from = check, values_from = value) %>% 
      mutate(
        count = obs - count, 
        Notes = ''
      ) %>% 
      rename(
        `Number of Data Records` = obs, 
        `Number of Qualified Records` = count
      )
    
    tab <- flextable::flextable(totab, col_keys = grep('\\_met', names(totab), value = T, invert = T)) %>% 
      flextable::bg(i = ~ `% Completeness_met` == 0, j = '% Completeness', bg = fail_col) %>% 
      flextable::bg(i = ~ `% Completeness_met` == 1, j = '% Completeness', bg = pass_col) %>% 
      thm %>% 
      flextable::align(align = 'left', part = 'all') %>% 
      flextable::border_inner() %>% 
      flextable::width(j = 'Notes', width = 3)
    
  }
  
  # get percent table
  if(type == 'percent'){
      
    # format for the table
    totab <- res %>% 
      dplyr::select(Parameter, check, percent, met) %>%
      dplyr::filter(!check %in% '% Completeness') %>% 
      dplyr::mutate(met = as.numeric(met)) %>% 
      tidyr::pivot_longer(cols = c('percent', 'met')) %>% 
      tidyr::unite('check', check, name) %>% 
      dplyr::mutate(
        check = gsub('\\_percent', '', check)
      ) %>% 
      tidyr::pivot_wider(names_from = check, values_from = value)
    
    # table
    tab <- flextable::flextable(totab, col_keys = grep('\\_met', names(totab), value = T, invert = T)) %>% 
      flextable::bg(i = ~ `Field Duplicate_met` == 0, j = 'Field Duplicate', bg = fail_col) %>% 
      flextable::bg(i = ~ `Field Duplicate_met` == 1, j = 'Field Duplicate', bg = pass_col) %>% 
      flextable::bg(i = ~ `Lab Duplicate_met` == 0, j = 'Lab Duplicate', bg = fail_col) %>% 
      flextable::bg(i = ~ `Lab Duplicate_met` == 1, j = 'Lab Duplicate', bg = pass_col) %>% 
      flextable::bg(i = ~ `Field Blank_met` == 0, j = 'Field Blank', bg = fail_col) %>% 
      flextable::bg(i = ~ `Field Blank_met` == 1, j = 'Field Blank', bg = pass_col)%>% 
      flextable::bg(i = ~ `Lab Blank_met` == 0, j = 'Lab Blank', bg  = fail_col) %>% 
      flextable::bg(i = ~ `Lab Blank_met` == 1, j = 'Lab Blank', bg = pass_col) %>% 
      flextable::bg(i = ~ `Spike/Check Accuracy_met` == 0, j = 'Spike/Check Accuracy', bg = fail_col) %>% 
      flextable::bg(i = ~ `Spike/Check Accuracy_met` == 1, j = 'Spike/Check Accuracy', bg = pass_col) %>% 
      thm %>% 
      flextable::align(align = 'center', part = 'all') %>% 
      flextable::align(align = 'left', j = 1, part = 'all') %>% 
      flextable::border_inner()
  
  }
  
  return(tab)
  
}