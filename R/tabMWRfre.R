#' Create a formatted table of quality control frequency checks
#'
#' @inheritParams qcMWRcom 
#' @param type character string indicating \code{summary} or \code{percent} tabular output, see datails
#' @param pass_col character string (as hex code) for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string (as hex code) for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#'
#' @return A \code{\link{flextable}} object with formatted results.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRacc}}, and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}. 
#' 
#' Also note that completeness is only evaluated on parameters that are shared between the results file and data quality objectives file for frequency and completeness.  A warning is returned for parameters that do not match between the files. This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' The quality control tables for frequency show the number of records that apply to a given check (e.g., Lab Blank, Field Blank, etc.) relative to the number of "regular" data records (e.g., field samples or measures) for each parameter.  A summary of all frequency checks for each parameter is provided if \code{type = "summary"} or a color-coded table showing similar information as percentages for each parameter is provided if \code{type = "percent"}. 
#' 
#' Inputs for the results and data quality objectives for accuracy and frequency and completeness are processed internally with \code{\link{qcMWRcom}} and the same arguments are accepted for this function, in addition to others listed above. 
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
#' # dqo accuracy data path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' # table as summary
#' tabMWRfre(res = respth, acc = accpth, frecom = frecompth, type = 'summary')
#' 
#' # table as percent
#' tabMWRfre(res = respth, acc = accpth, frecom = frecompth, type = 'percent')
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
#' # frequency and completeness data
#' frecomdat <- readMWRfrecom(frecompth)
#' 
#' # table as summary
#' tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary')
#' 
#' # table as percent
#' tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent')
tabMWRfre <- function(res = NULL, acc = NULL, frecom = NULL, fset = NULL, runchk = TRUE, warn = TRUE, type = c('summary', 'percent'), pass_col = '#57C4AD', fail_col = '#DB4325', digits = 0, suffix = '%'){
  
  utilMWRinputcheck(mget(ls()))
  
  type <- match.arg(type)
  
  # get frequency summary
  res <- qcMWRfre(res = res, acc = acc, frecom = frecom, fset = fset, runchk = runchk, warn = warn)

  if(type == 'summary'){

    # table theme
    thm <- function(x, ...){
      x <- flextable::colformat_double(x, digits = digits, suffix = suffix)
      flextable::autofit(x)
    }

    # levels to use
    levs <- c('Field Duplicate', 'Lab Duplicate', 'Field Blank', 'Lab Blank', 'Spike/Check Accuracy')
    labs <- c('Field Duplicates', 'Lab Duplicates', 'Field Blanks', 'Lab Blanks', 'Lab Spikes / Instrument Checks')
    
    # format for the table
    totab <- res %>% 
      dplyr::select(
        Type = check, 
        Parameter, 
        `Number of Data Records` = obs, 
        `Number of Dups/Blanks/Spikes` = count, 
        `Frequency %` = percent, 
        `Hit/Miss` = met
        ) %>% 
      dplyr::mutate(
        Type = factor(Type, levels = levs, labels = labs), 
        `Hit/Miss` = ifelse(
          !`Hit/Miss`, 'MISS', 
          ''
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
