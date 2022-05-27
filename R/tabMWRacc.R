#' Create a formatted table of quality control accuracy checks
#'
#' @inheritParams qcMWRacc 
#' @param type character string indicating \code{summary} or \code{percent} tabular output, see datails
#' @param pass_col character string for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly.  Also note that frequency is only evaluated on parameters in the \code{Parameter} column in the data quality objectives frequency and completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.  This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' The quality control tables for accuracy show ........
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
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', 
#'      package = 'MassWateR')
#' 
#' # table as summary
#' tabMWRacc(res = respth, acc = accpth, type = 'summary', accchk = 'Field Blanks')
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
#' tabMWRacc(res = resdat, acc = accdat, type = 'summary', accchk = 'Field Blanks')
#' 
#' # table as percent
#' tabMWRacc(res = resdat, acc = accdat, type = 'percent')
tabMWRacc <- function(res, acc, runchk = TRUE, warn = TRUE, accchk = c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes', 'Instrument Checks (post sampling)'), type = c('summary', 'percent'), pass_col = 'green', fail_col = 'red', digits = 0, suffix = '%'){
  
  type <- match.arg(type)
  
  # get accuracy summary
  res <- qcMWRacc(res = res, acc = acc, runchk = runchk, warn = warn, accchk = accchk)
  
  if(type == 'summary'){
    
    if(length(accchk) != 1)
      stop('accchk must have only one entry for type = "summary"')
    
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
      # flextable::align(align = 'left', j = 1, part = 'all') %>% 
      flextable::border_inner() %>% 
      flextable::set_caption(names(res))

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
