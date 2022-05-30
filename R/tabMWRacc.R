#' Create a formatted table of quality control accuracy checks
#'
#' @inheritParams qcMWRacc 
#' @param type character string indicating \code{individual}, \code{summary} or \code{percent} tabular output, see details
#' @param pass_col character string for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. Also note that accuracy is only evaluated on parameters that are shared between the results file and data quality objectives file for accuracy.  A warning is returned for parameters that do not match between the files. This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' The function can return three types of tables as specified with the \code{type} argument: \code{"individual"}, \code{"summary"}, or \code{"percent"}.  The individual tables are specific to each type of accuracy check for each parameter (e.g., field blanks, lab blanks, etc.).  The summary table summarizes all accuracy checks by the number of checks and how many hit/misses are returned for each across all parameters.  The percent table is similar to the summary table, but showing only percentages with appropriate color-coding for hit/misses.   
#'
#'For \code{type = "individual"}, the quality control tables for accuracy are retrieved by specifying the check with the \code{accchk} argument.  The \code{accchk} argument can be used to specify one of the following values to retrieve the relevant tables: \code{"Field Blanks"}, \code{"Lab Blanks"}, \code{"Field Duplicates"}, \code{"Lab Duplicates"}, \code{"Lab Spikes"}, or \code{"Instrument Checks (post sampling)"}.
#' 
#' For \code{type = "summary"}, the function summarizes all accuracy checks by counting the number of quality control checks, number of misses, and percent acceptance for each parameter. The \code{accchk} argument can be used for one to any of all accuracy checks, defaulting to all if left blank.
#'
#' For \code{type = "percent"}, the function... The \code{accchk} argument can be used for one to any of all accuracy checks, defaulting to all if left blank.
#' 
#' Inputs for the results and data quality objectives for accuracy are processed internally with \code{\link{qcMWRacc}} and the same arguments are accepted for this function, in addition to others listed above. 
#' 
#' @export
#'
#' @examples
#'
#' ##
#' # using file paths
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # table as summary
#' tabMWRacc(res = respth, acc = accpth, type = 'individual', accchk = 'Field Blanks')
#' 
#' # table as summary
#' tabMWRacc(res = respth, acc = accpth, type = 'summary')
#' 
#' # table as percent
#' tabMWRacc(res = respth, acc = accpth, type = 'percent')
#' 
#' ##
#' # using data frames
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # table as summary
#' tabMWRacc(res = resdat, acc = accdat, type = 'individual', accchk = 'Field Blanks')
#'
#' # table as percent
#' tabMWRacc(res = resdat, acc = accdat, type = 'summary')
#' 
#' # table as percent
#' tabMWRacc(res = resdat, acc = accdat, type = 'percent')
tabMWRacc <- function(res, acc, runchk = TRUE, warn = TRUE, accchk = c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes', 'Instrument Checks (post sampling)'), type = c('individual', 'summary', 'percent'), pass_col = 'green', fail_col = 'red', digits = 0, suffix = '%'){
  
  type <- match.arg(type)
  
  # get accuracy summary
  res <- qcMWRacc(res = res, acc = acc, runchk = runchk, warn = warn, accchk = accchk)
  
  if(type == 'individual'){
    
    if(length(accchk) != 1)
      stop('accchk must have only one entry for type = "individual"')
    
    # table theme
    thm <- function(x, ...){
      x <- flextable::colformat_double(x, digits = digits, suffix = suffix)
      flextable::autofit(x)
    }

    totab <- res[[1]]
    
    # stop if no data to use for table
    if(is.null(totab))
      stop(paste('No data to check for', accchk))
    
    totab <- totab %>% 
      dplyr::mutate(Date = as.character(Date)) %>% 
      flextable::as_grouped_data(groups = 'Parameter')
    
    # table
    tab <- flextable::flextable(totab) %>% 
      thm %>% 
      flextable::align(align = 'left', part = 'all') %>% 
      flextable::border_inner() %>% 
      flextable::set_caption(names(res))

  }
  
  if(type == 'summary'){
    
    # table theme
    thm <- function(x, ...){
      x <- flextable::colformat_double(x, digits = digits, na_str = '-', suffix = suffix)
      flextable::autofit(x)
    }

    # format for the table
    totab <- res %>%
      tibble::enframe(name = 'Type') %>% 
      tidyr::unnest('value') %>% 
      dplyr::group_by(Type, Parameter) %>% 
      dplyr::summarise(
        `Number of QC Checks` = n(), 
        `Number of Misses` = sum(`Hit/Miss` == 'MISS', na.rm = TRUE)
      ) %>% 
      dplyr::mutate(
        `% Acceptance` = 100 * (`Number of QC Checks` - `Number of Misses`) / `Number of QC Checks`, 
        `% Acceptance` = paste(round(`% Acceptance`, 0), '%'), 
        Type = factor(Type, levels = accchk)
      ) %>% 
      dplyr::arrange(Type) %>% 
      flextable::as_grouped_data(groups = 'Type')

    # table
    tab <- flextable::flextable(totab) %>% 
      thm %>% 
      flextable::align(align = 'left', part = 'all') %>% 
      flextable::border_inner()

  }
  
  if(type == 'percent'){
    
    tab <- NULL
    # # table theme
    # thm <- function(x, ...){
    #   x <- flextable::colformat_double(x, digits = digits, na_str = '-', suffix = suffix)
    #   flextable::autofit(x)
    # }
    # 
    # # format for the table
    # totab <- res %>% 
    #   dplyr::filter(!check %in% c('Lab Spike', 'Instrument Check')) %>% 
    #   dplyr::select(Parameter, check, percent, met) %>%
    #   dplyr::mutate(met = as.numeric(met)) %>% 
    #   tidyr::pivot_longer(cols = c('percent', 'met')) %>% 
    #   tidyr::unite('check', check, name) %>% 
    #   dplyr::mutate(
    #     check = gsub('\\_percent', '', check)
    #   ) %>% 
    #   tidyr::pivot_wider(names_from = check, values_from = value)
    # 
    # # table
    # tab <- flextable::flextable(totab, col_keys = grep('\\_met', names(totab), value = T, invert = T)) %>% 
    #   flextable::bg(i = ~ `Field Duplicate_met` == 0, j = 'Field Duplicate', bg = fail_col) %>% 
    #   flextable::bg(i = ~ `Field Duplicate_met` == 1, j = 'Field Duplicate', bg = pass_col) %>% 
    #   flextable::bg(i = ~ `Lab Duplicate_met` == 0, j = 'Lab Duplicate', bg = fail_col) %>% 
    #   flextable::bg(i = ~ `Lab Duplicate_met` == 1, j = 'Lab Duplicate', bg = pass_col) %>% 
    #   flextable::bg(i = ~ `Field Blank_met` == 0, j = 'Field Blank', bg = fail_col) %>% 
    #   flextable::bg(i = ~ `Field Blank_met` == 1, j = 'Field Blank', bg = pass_col)%>% 
    #   flextable::bg(i = ~ `Lab Blank_met` == 0, j = 'Lab Blank', bg  = fail_col) %>% 
    #   flextable::bg(i = ~ `Lab Blank_met` == 1, j = 'Lab Blank', bg = pass_col) %>% 
    #   flextable::bg(i = ~ `Spike/Check Accuracy_met` == 0, j = 'Spike/Check Accuracy', bg = fail_col) %>% 
    #   flextable::bg(i = ~ `Spike/Check Accuracy_met` == 1, j = 'Spike/Check Accuracy', bg = pass_col) %>% 
    #   thm %>% 
    #   flextable::align(align = 'center', part = 'all') %>% 
    #   flextable::align(align = 'left', j = 1, part = 'all') %>% 
    #   flextable::border_inner()
    # 
  }
  
  return(tab)
  
}
