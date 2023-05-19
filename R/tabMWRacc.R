#' Create a formatted table of quality control accuracy checks
#'
#' @inheritParams qcMWRacc 
#' @param type character string indicating \code{individual}, \code{summary} or \code{percent} tabular output, see details
#' @param pass_col character string (as hex code) for the cell color of checks that pass, applies only if \code{type = 'percent'}
#' @param fail_col character string (as hex code) for the cell color of checks that fail, applies only if \code{type = 'percent'} 
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}, applies only if \code{type = "summary"} or \code{type = "percent"}
#' @param caption logical to include a caption from \code{accchk}, only applies if \code{type = "individual"}
#'
#' @return A \code{\link{flextable}} object with formatted results.
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.
#' 
#' Also note that accuracy is only evaluated on parameters that are shared between the results file and data quality objectives file for accuracy.  A warning is returned for parameters that do not match between the files. This warning can be suppressed by setting \code{warn = FALSE}. 
#' 
#' The function can return three types of tables as specified with the \code{type} argument: \code{"individual"}, \code{"summary"}, or \code{"percent"}.  The individual tables are specific to each type of accuracy check for each parameter (e.g., field blanks, lab blanks, etc.).  The summary table summarizes all accuracy checks by the number of checks and how many hit/misses are returned for each across all parameters.  The percent table is similar to the summary table, but showing only percentages with appropriate color-coding for hit/misses. The data quality objectives file for frequency and completeness is required if \code{type = "summary"} or \code{type = "percent"}.   
#'
#'For \code{type = "individual"}, the quality control tables for accuracy are retrieved by specifying the check with the \code{accchk} argument.  The \code{accchk} argument can be used to specify one of the following values to retrieve the relevant tables: \code{"Field Blanks"}, \code{"Lab Blanks"}, \code{"Field Duplicates"}, \code{"Lab Duplicates"}, or \code{"Lab Spikes / Instrument Checks"}.
#' 
#' For \code{type = "summary"}, the function summarizes all accuracy checks by counting the number of quality control checks, number of misses, and percent acceptance for each parameter. All accuracy checks are used and the \code{accchk} argument does not apply.
#'
#' For \code{type = "percent"}, the function returns a similar table as for the summary option, except only the percentage of checks that pass for each parameter are shown in wide format. Cells are color-coded based on the percentage of checks that have passed using the percent thresholds from the \code{% Completeness} column of the data quality objectives file for frequency and completeness. Parameters without an entry for \code{% Completeness} are not color-coded and an appropriate warning is returned. All accuracy checks are used and the \code{accchk} argument does not apply.
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
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' # table as individual
#' tabMWRacc(res = respth, acc = accpth, frecom = frecompth, type = 'individual', 
#'      accchk = 'Field Blanks')
tabMWRacc <- function(res = NULL, acc = NULL, frecom = NULL, fset = NULL, runchk = TRUE, warn = TRUE, accchk = c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes / Instrument Checks'), type = c('individual', 'summary', 'percent'), pass_col = '#57C4AD', fail_col = '#DB4325', suffix = '%', caption = TRUE){

  utilMWRinputcheck(mget(ls()))
  
  type <- match.arg(type)
  
  # table theme
  thm <- function(x, ...){
    x <- flextable::colformat_double(x, na_str = '-')
    flextable::autofit(x)
  }
  
  if(type %in% c('summary', 'percent')){
    accchk <- c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes / Instrument Checks')
  }
  
  # get accuracy summary
  accsum <- qcMWRacc(res = res, acc = acc, frecom = frecom, fset = fset, runchk = runchk, warn = warn, accchk = accchk, suffix = suffix)
  
  if(type == 'individual'){

    if(length(accchk) != 1)
      stop('accchk must have only one entry for type = "individual"')

    totab <- accsum[[1]]
    
    # stop if no data to use for table
    if(is.null(totab)){
      if(warn)
        warning(paste('No data to check for', accchk), call. = FALSE)
      return(NULL)
    }

    totab <- totab %>% 
      dplyr::mutate(Date = as.character(Date)) %>% 
      flextable::as_grouped_data(groups = 'Parameter')
    
    # table
    tab <- flextable::flextable(totab) %>% 
      thm %>% 
      flextable::align(align = 'left', part = 'all') %>% 
      flextable::border_inner()
    
    if(caption)
      tab <- tab %>% 
        flextable::set_caption(names(accsum))

  }
  
  if(type %in% c('summary', 'percent')){

    # check if accsum completely empty
    chk <- lapply(accsum, is.null) %>% 
      unlist()
    if(all(chk))
      stop('No QC records or reference values for parameters with defined DQOs. Cannot create QC tables.', call. = FALSE)

    # get inputs resdat and frecom needed for summary and percent tables
    # warn and runchk applied above, no need here
    inp <- utilMWRinput(res = res, frecom = frecom, fset = fset, warn = F, runchk = F)
    resdat <- inp$resdat
    frecomdat <- inp$frecomdat
    
    # results parameters with Field Msr/Obs, Sample-Routine
    resdatprm <- resdat %>% 
      dplyr::filter(`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine')) %>% 
      dplyr::pull(`Characteristic Name`) %>% 
      unique %>% 
      sort
    
    # format for the tables
    sumtab <- accsum %>%
      tibble::enframe(name = 'Type') %>% 
      tidyr::unnest('value') %>% 
      dplyr::group_by(Type, Parameter) %>% 
      dplyr::summarise(
        `Number of QC Checks` = n(), 
        `Number of Misses` = sum(`Hit/Miss` == 'MISS', na.rm = TRUE)
      ) %>% 
      dplyr::mutate(
        `% Acceptance` = 100 * (`Number of QC Checks` - `Number of Misses`) / `Number of QC Checks`, 
        Type = factor(Type, 
          levels = c("Field Duplicates", "Lab Duplicates", "Field Blanks", "Lab Blanks", "Lab Spikes / Instrument Checks")
        )
      ) %>% 
      dplyr::arrange(Type, Parameter)

    ##
    # create parameter list for all

    # parameters in the summary tab
    sumtabprm <- sumtab %>% 
      dplyr::select(Type, Parameter) %>% 
      dplyr::group_by(Type) %>% 
      tidyr::nest() %>% 
      tibble::deframe() %>% 
      lapply(dplyr::pull)
    
    # get master parameter list to fill all, specific to each check
    fldblkprm <- sumtabprm$`Field Blanks` %>% 
      union(., na.omit(frecomdat[, c('Parameter', 'Field Blank')])$Parameter) %>% 
      sort
    labblkprm <- sumtabprm$`Lab Blanks` %>% 
      union(., na.omit(frecomdat[, c('Parameter', 'Lab Blank')])$Parameter) %>% 
      sort
    flddupprm <- sumtabprm$`Field Duplicates` %>% 
      union(., na.omit(frecomdat[, c('Parameter', 'Field Duplicate')])$Parameter) %>% 
      sort
    labdupprm <- sumtabprm$`Lab Duplicates` %>% 
      union(., na.omit(frecomdat[, c('Parameter', 'Lab Duplicate')])$Parameter) %>% 
      sort
    spkchkprm <- sumtabprm$`Lab Spikes / Instrument Checks` %>% 
      union(., na.omit(frecomdat[, c('Parameter', 'Spike/Check Accuracy')])$Parameter) %>% 
      sort

    # all parameters by check, then filter by those in resdat
    allprm <- list(
        `Field Duplicates` = flddupprm,
        `Lab Duplicates` = labdupprm,
        `Field Blanks` = fldblkprm,
        `Lab Blanks` = labblkprm, 
        `Lab Spikes / Instrument Checks` = spkchkprm
      ) %>% 
      tibble::enframe('Type', 'Parameter') %>% 
      tidyr::unnest('Parameter') %>% 
      dplyr::mutate(
        Type = factor(Type, levels = levels(sumtab$Type))
      ) %>% 
      dplyr::filter(Parameter %in% resdatprm)

    if(type == 'summary'){
      
      ## 
      # summary table, all parameters
      totab <- sumtab %>% 
        dplyr::mutate(
          `% Acceptance` = paste(round(`% Acceptance`, 0), suffix), 
        ) %>% 
        left_join(allprm, ., by = c('Type', 'Parameter')) %>% 
        dplyr::mutate(
          `Number of QC Checks` = ifelse(is.na(`Number of QC Checks`), 0, `Number of QC Checks`),
          `Number of QC Checks` = as.character(`Number of QC Checks`), 
          `Number of Misses` = ifelse(is.na(`Number of Misses`), '-', as.character(`Number of Misses`)),
          `% Acceptance` = ifelse(is.na(`% Acceptance`), '-', as.character(`% Acceptance`))
          ) %>%
        flextable::as_grouped_data(groups = 'Type')
      
      # table
      tab <- flextable::flextable(totab) %>% 
        thm %>% 
        flextable::align(align = 'left', part = 'all') %>% 
        flextable::border_inner()
      
    }

    if(type == 'percent'){

      # table theme
      thm <- function(x, ...){
        x <- flextable::colformat_double(x, na_str = '-', digits = 0, suffix = suffix)
        flextable::autofit(x)
      }
      
      # format frecomdat for comparison
      frecomdat <- frecomdat %>% 
        select(Parameter, `% Completeness`)
    
      # allprm combine lab spikes and instrument checks
      allprm <- allprm %>% 
        dplyr::mutate(
          Type = as.character(Type),
          Type = ifelse(Type %in% c('Lab Spikes / Instrument Checks'), 'Spike/Check Accuracy', Type)
        ) %>% 
        unique
      
      # get lab and ins checks only for total
      spkchksum <- sumtab %>% 
        dplyr::filter(Type %in% "Lab Spikes / Instrument Checks") %>% 
        dplyr::group_by(Parameter) %>% 
        dplyr::summarise(
          `Number of QC Checks` = sum(`Number of QC Checks`), 
          `Number of Misses` = sum(`Number of Misses`)
        ) %>% 
        dplyr::ungroup() %>% 
        dplyr::mutate(
          `% Acceptance` = 100 * (`Number of QC Checks` - `Number of Misses`) / `Number of QC Checks`, 
          Type = 'Spike/Check Accuracy'
        ) %>% 
        dplyr::select(Type, Parameter, percent = `% Acceptance`)
   
      # combine all
      totab <- sumtab %>% 
        dplyr::select(Type, Parameter, percent = `% Acceptance`) %>% 
        dplyr::bind_rows(spkchksum) %>% 
        dplyr::left_join(allprm, ., by = c('Type', 'Parameter')) %>% 
        dplyr::left_join(frecomdat, by = 'Parameter') %>% 
        dplyr::rename(check = Type) 
      
      # warning for entries in table w/o checks
      nocol <- totab %>% 
        filter(is.na(`% Completeness`)) %>% 
        pull(Parameter) %>% 
        unique %>% 
        sort
      chk <- length(nocol) == 0
      if(!chk & warn){
        warning('Parameters in table not found in quality control objectives for frequency and completeness (no color): ', paste(nocol, collapse = ', '), call. = FALSE)
      }
      
      # get unique parameters in results and frecomdat for factor levels
      allprm <- intersect(unique(resdat$`Characteristic Name`), unique(frecomdat$Parameter)) %>% 
        sort()
      
      totab <- totab %>% 
        dplyr::mutate(
          check = factor(
            check, 
            levels = c("Field Duplicates", "Lab Duplicates", "Field Blanks", "Lab Blanks", "Spike/Check Accuracy"), 
            labels = c("Field Duplicate", "Lab Duplicate", "Field Blank", "Lab Blank", "Spike/Check Accuracy")
          ),
          Parameter = factor(Parameter ,levels = allprm),
          percent = as.numeric(gsub(suffix, '', percent)), 
          met = as.numeric(percent > `% Completeness`)
        ) %>% 
        dplyr::select(-`% Completeness`) %>% 
        tidyr::complete(check, Parameter) %>% 
        tidyr::pivot_longer(cols = c('percent', 'met')) %>%
        tidyr::unite('check', check, name) %>%
        dplyr::mutate(
          check = gsub('\\_percent', '', check)
        ) %>%
        tidyr::pivot_wider(names_from = check, values_from = value) %>% 
        dplyr::arrange(Parameter)

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
  }
  
  return(tab)
  
}
