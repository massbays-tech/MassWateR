#' Create a formatted table of quality control frequency checks
#'
#' @inheritParams qcMWRcom 
#' @param type character string indicating \code{summary} or \code{percent} tabular output, see datails
#' @param pass_col character string for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly.  Also note that frequency is only evaluated on parameters in the \code{Parameter} column in the data quality objectives frequency and completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.  This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' The quality control tables for frequency show the number of records that apply to a given check (e.g., Lab Blank, Field Blank, etc.) relative to the number of "regular" data records (e.g., field samples or measures) for each parameter.  A summary of all frequency checks for each parameter is provided if \code{type = "summary"} or a color-coded table showing similar information as percentages for each parameter is provided if \code{type = "percent"}. 
#' 
#' Inputs for the results and data quality objectives for frequency and completeness are processed internally with \code{\link{qcMWRcom}} and the same arguments are accepted for this function, in addition to others listed above. 
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
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness_final.xlsx', 
#'      package = 'MassWateR')
#' 
#' # table as summary
#' tabMWRfre(res = respth, frecom = frecompth, type = 'summary')
#' 
#' # table as percent
#' tabMWRfre(res = respth, frecom = frecompth, type = 'percent')
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
#' # table as summary
#' tabMWRfre(res = resdat, frecom = frecomdat, type = 'summary')
#' 
#' # table as percent
#' tabMWRfre(res = resdat, frecom = frecomdat, type = 'percent')
tabMWRfre <- function(res, frecom, runchk = TRUE, warn = TRUE, type = c('summary', 'percent'), pass_col = 'green', fail_col = 'red', digits = 0, suffix = '%'){
  
  type <- match.arg(type)
  
  # get frequency summary
  res <- qcMWRfre(res = res, frecom = frecom, runchk = runchk, warn = warn)

  if(type == 'summary'){

    # table theme
    thm <- function(x, ...){
      x <- flextable::colformat_double(x, digits = digits, suffix = suffix)
      flextable::autofit(x)
    }
    
    # levels to use
    levs <- c('Field Duplicate', 'Lab Duplicate', 'Field Blank', 'Lab Blank', 'Lab Spike', 'Instrument Check')
    
    # format for the table
    totab <- res %>% 
      dplyr::filter(!check %in% 'Spike/Check Accuracy') %>% 
      dplyr::select(
        Type = check, 
        Parameter, 
        `Number of Data Records` = obs, 
        `Number of Dups/Blanks/Spikes` = count, 
        `Frequency %` = percent, 
        `Hit/Miss` = met
        ) %>% 
      dplyr::mutate(
        Type = factor(Type, levels = levs, labels = paste0(levs, 's')), 
        `Hit/Miss` = dplyr::case_when(
          !`Hit/Miss` ~ 'MISS', 
          T ~ ''
        )
      ) %>% 
      dplyr::arrange(Type, Parameter) %>% 
      dplyr::filter(!is.na(`Frequency %`)) %>% 
      flextable::as_grouped_data(groups = 'Type')

    # table
    tab <- flextable::flextable(totab) %>% 
      thm %>% 
      flextable::align(align = 'left', part = 'all') %>% 
      # flextable::align(align = 'left', j = 1, part = 'all') %>% 
      flextable::border_inner()
    
  }
  
  if(type == 'percent'){
    
    # table theme
    thm <- function(x, ...){
      x <- flextable::colformat_double(x, digits = digits, na_str = '-', suffix = suffix)
      flextable::autofit(x)
    }
    
    # format for the table
    totab <- res %>% 
      dplyr::filter(!check %in% c('Lab Spike', 'Instrument Check')) %>% 
      dplyr::select(Parameter, check, percent, met) %>%
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
