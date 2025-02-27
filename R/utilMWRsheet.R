#' Format a list of QC tables for spreadsheet export
#'
#' @param datin list of input QC tables
#' @param rawdata logical to include quality control accuracy summaries for raw data, e.g., field blanks, etc.
#'
#' @details
#' The function is used internally with \code{\link{qcMWRreview}} to format data quality objective and quality control tables for export into an Excel spreadsheet.  These changes are specific to the spreadsheet format and may not reflect the formatting in the Word document produced by \code{\link{qcMWRreview}}.
#' 
#' The \code{datin} list is expected to contain the following elements:
#' \itemize{
#' \item `frecomdat` Data Quality Objectives for frequency and completeness data frame as returned by \code{\link{readMWRfrecom}}
#' \item `accdat` Data Quality Objectives for accuracy data frame as returned by \code{\link{readMWRacc}}
#' \item `tabfreper` Frequency checks percent table, created with \code{\link{tabMWRfre}}
#' \item `tabfresum` Frequency checks summary table, created with \code{\link{tabMWRfre}}
#' \item `tabaccper` Accuracy checks percent table, created with \code{\link{tabMWRacc}}
#' \item `tabaccsum` Accuracy checks summary table, created with \code{\link{tabMWRacc}}
#' \item `tabcom` Completeness table, created with \code{\link{tabMWRcom}}
#' \item `indflddup` Individual accuracy checks table for field duplicates, created with \code{\link{tabMWRacc}}, can be \code{NULL}
#' \item `indlabdup` Individual accuracy checks table for lab duplicates, created with \code{\link{tabMWRacc}}, can be \code{NULL}
#' \item `indfldblk` Individual accuracy checks table for field blanks, created with \code{\link{tabMWRacc}}, can be \code{NULL}
#' \item `indlabblk` Individual accuracy checks table for lab blanks, created with \code{\link{tabMWRacc}}, can be \code{NULL}
#' \item `indlabins` Individual accuracy checks table for lab spikes and instrument checks, created with \code{\link{tabMWRacc}}, can be \code{NULL}
#' }
#' 
#' @returns A list similar to the input with formatting applied
#' @export
#'
#' @examples
#' # results data path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # dqo accuracy data path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' # dqo completeness data path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR')
#' 
#' # censored data path
#' censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')
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
#' # censored data
#' censdat <- readMWRcens(censpth)
#' 
#' # frequency table percent
#' tabfreper <- tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent', 
#'   warn = F) 
#' 
#' # frequency summary table
#' tabfresum <- tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary', 
#'   warn = F)
#' 
#' # accuracy table percent
#' tabaccper <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent', 
#'   warn = F)
#' 
#' # accuracy table summary
#' tabaccsum <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary', 
#'   warn = F)
#'   
#' # completeness table
#' tabcom <- tabMWRcom(res = resdat, frecom = frecomdat, cens = censdat, warn = F, 
#'   parameterwd = 1.15, noteswd = 2)
#'
#' # individual accuracy checks for raw data
#' indflddup <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
#'   accchk = 'Field Duplicates', warn = F, caption = FALSE)
#' indlabdup <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
#'   accchk = 'Lab Duplicates', warn = F, caption = FALSE)
#' indfldblk <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
#'   accchk = 'Field Blanks', warn = F, caption = FALSE)
#' indlabblk <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
#'   accchk = 'Lab Blanks', warn = F, caption = FALSE)
#' indlabins <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
#'   accchk = 'Lab Spikes / Instrument Checks', warn = F, caption = FALSE)
#' 
#' # input  
#' datin <- list(
#'   frecomdat = frecomdat, 
#'   accdat = accdat,
#'   tabfreper = tabfreper,
#'   tabfresum = tabfresum,
#'   tabaccper = tabaccper,
#'   tabaccsum = tabaccsum,
#'   tabcom = tabcom,
#'   indflddup = indflddup,
#'   indlabdup = indlabdup,
#'   indfldblk = indfldblk,
#'   indlabblk = indlabblk,
#'   indlabins = indlabins
#' )
#' 
#' utilMWRsheet(datin)
utilMWRsheet <- function(datin, rawdata = TRUE){
  
  out <- list(
    `Frequency DQO` = datin$frecomdat, 
    `Accuracy DQO` = datin$accdat,
    `Frequency Checks Percent` = datin$tabfreper$body$dataset,
    `Frequency Checks` = datin$tabfresum$body$dataset,
    `Accuracy Checks Percent` = datin$tabaccper$body$dataset,
    `Accuracy Checks` = datin$tabaccsum$body$dataset,
    `Completeness` = datin$tabcom$body$dataset
  )

  # remove met columns
  out$`Frequency Checks Percent` <- out$`Frequency Checks Percent`[, !grepl('\\_met$', names(out$`Frequency Checks Percent`))]
  out$`Accuracy Checks Percent` <- out$`Accuracy Checks Percent`[, !grepl('\\_met$', names(out$`Accuracy Checks Percent`))]
  out$`Completeness` <- out$`Completeness`[, !grepl('^met$', names(out$`Completeness`))]
  
  # format accuracy checks as numeric
  out$`Accuracy Checks` <- out$`Accuracy Checks` %>% 
    dplyr::mutate(dplyr::across(c(`Number of QC Checks`, `Number of Misses`, `% Acceptance`), ~ gsub('\\%$|^\\-$', '', .x))) %>%
    dplyr::mutate(dplyr::across(c(`Number of QC Checks`, `Number of Misses`, `% Acceptance`), as.numeric))
  
  # arrange DQO tables as alphabetical
  out$`Frequency DQO` <- dplyr::arrange(out$`Frequency DQO`, Parameter, .locale = 'en')
  out$`Accuracy DQO` <- dplyr::arrange(out$`Accuracy DQO`, Parameter, .locale = 'en')
  
  # percents with zero decimals
  out$`Frequency Checks Percent` <- dplyr::mutate(out$`Frequency Checks Percent`, dplyr::across(dplyr::where(is.numeric), round, 0))
  out$`Accuracy Checks Percent` <- dplyr::mutate(out$`Accuracy Checks Percent`, dplyr::across(dplyr::where(is.numeric), round, 0))  
  out$`Frequency Checks`$`Frequency %` <- round(out$`Frequency Checks`$`Frequency %`, 0)
  out$`Completeness`$`% Completeness` <- round(out$`Completeness`$`% Completeness`, 0)
  
  if(rawdata)
    out <- c(out, 
             list(
               `Field Duplicates` = datin$indflddup$body$dataset,
               `Lab Duplicates` = datin$indlabdup$body$dataset,
               `Field Blanks` = datin$indfldblk$body$dataset,
               `Lab Blanks` = datin$indlabblk$body$dataset,
               `Lab Spikes - Instrument Checks` = datin$indlabins$body$dataset
             )
    )
  
  return(out)
  
}