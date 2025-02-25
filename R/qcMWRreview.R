#' Create the quality control review report
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param cens character string of path to the censored data file or \code{data.frame} returned by \code{\link{readMWRcens}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, and \code{cens}, overrides the other arguments
#' @param output_dir character string of the output directory for the rendered file
#' @param output_file optional character string for the file name
#' @param rawdata logical to include quality control accuracy summaries for raw data, e.g., field blanks, etc.
#' @param savesheet logical indicating if a spreadsheet of the tables in the report is also saved (default \code{FALSE})
#' @param dqofontsize numeric for font size in the data quality objective tables in the first page of the review
#' @param tabfontsize numeric for font size in the review tables
#' @param padding numeric for row padding for table output
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRfrecom}}, applies only if \code{res}, \code{acc}, or \code{frecom} are file paths
#' @param warn logical indicating if warnings from the table functions are included in the file output
#'
#' @return A compiled review report named \code{qcreview.docx} (or name passed to \code{output_file}) will be saved in the directory specified by \code{output_dir}
#' 
#' @export
#'
#' @details 
#' 
#' The function compiles a review report as a Word document for all quality control checks included in the MassWateR package.  The report shows several tables, including the data quality objectives files for accuracy, frequency, and completeness, summary results for all accuracy checks, summary results for all frequency checks, summary results for all completeness checks, and individual results for all accuracy checks.  The report uses the individual table functions (which can be used separately) to return the results, which include \code{\link{tabMWRacc}}, \code{\link{tabMWRfre}}, and \code{\link{tabMWRcom}}.  The help files for each of these functions can be consulted for a more detailed explanation of the quality control checks. 
#' 
#' The workflow for using this function is to import the required data (results, data quality objective, and censored files) and to fix any errors noted on import prior to creating the review report.  Additional warnings that may be of interest as returned by the individual table functions can be returned in the console by setting \code{warn = TRUE}.  
#' 
#' Optional arguments that can be changed as needed include specifying the file name with \code{output_file}, suppressing the raw data summaries at the end of the report with \code{rawdata = FALSE}, and changing the table font sizes (\code{dqofontsize} for the data quality objectives on the first page, \code{tabfontsize} for the remainder).  Set \code{savesheet = TRUE} to also save a spreadsheet of the tables in the report.
#' 
#' The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRacc}}, \code{\link{readMWRfrecom}}, and \code{\link{readMWRcens}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.
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
#' \donttest{
#' # create report
#' qcMWRreview(res = resdat, acc = accdat, frecom = frecomdat, cens = censdat, output_dir = tempdir())
#' }
qcMWRreview <- function(res = NULL, acc = NULL, frecom = NULL, cens = NULL, fset = NULL, output_dir, output_file = NULL, savesheet = FALSE, rawdata = TRUE, dqofontsize = 7.5, tabfontsize = 9, padding = 0, warn = TRUE, runchk = TRUE) {

  utilMWRinputcheck(mget(ls()))

  # rmd template
  qcreview <- system.file('rmd', 'qcreview.Rmd', package = 'MassWateR')
  
  # get input 
  inp <- utilMWRinput(res = res, acc = acc, frecom = frecom, cens = cens, fset = fset, runchk = runchk, warn = warn)
  resdat <- inp$resdat
  accdat <- inp$accdat
  frecomdat <- inp$frecomdat
  censdat <- inp$censdat
  
  # date for report
  resdatdt <- range(resdat$`Activity Start Date`)
  resdatdt <- paste(lubridate::month(resdatdt), lubridate::day(resdatdt), lubridate::year(resdatdt), sep = '/') %>% 
    paste(collapse = ' to ')
  
  # dqo summary table theme
  thmsum <- function(x, wd, fontname){
    if(!is.null(x))
      flextable::width(x, width = wd / flextable::ncol_keys(x)) %>% 
        flextable::font(fontname = fontname, part = 'all')
  }
  
  # table width and font for flextable in rmd
  wd <- 6.5
  fontname <- 'Calibri (Body)'
  
  flextable::set_flextable_defaults(font.size = tabfontsize, padding = padding)

  # warnings only needed for tabaccsum and tabcom, the rest are duplicates
  
  # frequency table percent
  tabfreper <- tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent', warn = F) %>% 
    thmsum(wd = wd, fontname = fontname)

  # frequency summary table
  tabfresum <- tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary', warn = F) %>% 
    thmsum(wd = wd, fontname = fontname)
  
  # accuracy table percent
  tabaccper <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent', warn = F) %>% 
    thmsum(wd = wd, fontname = fontname)
  
  # accuracy table summary
  tabaccsum <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary', warn = warn) %>% 
    thmsum(wd = wd, fontname = fontname)
    
  # completeness table
  tabcom <- tabMWRcom(res = resdat, frecom = frecomdat, cens = censdat, warn = warn, parameterwd = 1.15, noteswd = 2) %>% 
    flextable::width(width = (wd - 3.15) / (flextable::ncol_keys(.) - 2), j = 2:(flextable::ncol_keys(.) - 1)) %>%
    flextable::font(fontname = fontname, part = 'all')

  # warning for empty dqo columns
  if(warn){
    
    # frecom
    chk <- frecomdat %>% 
      dplyr::select(-Parameter) %>% 
      lapply(function(x) ifelse(all(is.na(x)), F, T)) %>% 
      unlist
    if(any(!chk)){
      nms <- names(chk)[which(!chk)]
      warning('No data quality obectives in frequency and completeness file for ', paste(nms, collapse = ', '), call. = FALSE)
    }
      
    # acc  
    chk <- accdat %>% 
      dplyr::select(-Parameter, -uom, -MDL, -UQL, -`Value Range`) %>% 
      lapply(function(x) ifelse(all(is.na(x)), F, T)) %>% 
      unlist
    if(any(!chk)){
      nms <- names(chk)[which(!chk)]
      warning('No data quality obectives in accuracy file for ', paste(nms, collapse = ', '), call. = FALSE)
    }
    
  }

  # individual accuracy checks for raw data
  indflddup <- NULL
  indlabdup <- NULL
  indfldblk <- NULL
  indlabblk <- NULL
  indlabins <- NULL
  if(rawdata){
    accind <- list(
      indflddup = 'Field Duplicates', 
      indlabdup = 'Lab Duplicates', 
      indfldblk = 'Field Blanks', 
      indlabblk = 'Lab Blanks', 
      indlabins = 'Lab Spikes / Instrument Checks'
    )
    for(i in seq_along(accind)){
      
      accchk <- accind[[i]]
      accnms <- names(accind)[i]
      tab <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', accchk = accchk, warn = F, caption = FALSE) %>% 
        thmsum(wd = wd, fontname = fontname)
      
      assign(accnms, tab)
    
    }
    
  }

  suppressMessages(rmarkdown::render(
    input = qcreview,
    output_dir = output_dir, 
    output_file = output_file, 
    params = list(
      resdatdt = resdatdt,
      accdat = accdat, 
      frecomdat = frecomdat,
      wd = wd, 
      fontname = fontname,
      rawdata = rawdata,
      warn = warn,
      dqofontsize = dqofontsize, 
      tabfontsize = tabfontsize,
      padding = padding,
      tabfreper = tabfreper,
      tabfresum = tabfresum,
      tabaccper = tabaccper,
      tabaccsum = tabaccsum, 
      tabcom = tabcom,
      indflddup = indflddup,
      indlabdup = indlabdup,
      indfldblk = indfldblk,
      indlabblk = indlabblk,
      indlabins = indlabins
    ), 
    quiet = TRUE
  ))

  if(is.null(output_file))
    output_file <- gsub('\\.Rmd$', '.docx', basename(qcreview))
  
  output_file <- paste0(tools::file_path_sans_ext(output_file), '.docx')
  file_loc <- list.files(path = output_dir, pattern = paste0('^', output_file), full.names = TRUE)
  msg <- paste("Report created successfully! File located at", file_loc)
  message(msg)

  # save spreadhseed
  if(savesheet){

    ##
    # save output
    output_file <- gsub('\\.docx', '.xlsx', output_file)

    out <- list(
      `Frequency DQO` = frecomdat, 
      `Accuracy DQO` = accdat,
      `Frequency Checks Percent` = tabfreper$body$dataset,
      `Frequency Checks` = tabfresum$body$dataset,
      `Accuracy Checks Percent` = tabaccper$body$dataset,
      `Accuracy Checks` = tabaccsum$body$dataset,
      `Completeness` = tabcom$body$dataset
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
          `Field Duplicates` = indflddup$body$dataset,
          `Lab Duplicates` = indlabdup$body$dataset,
          `Field Blanks` = indfldblk$body$dataset,
          `Lab Blanks` = indlabblk$body$dataset,
          `Lab Spikes - Instrument Checks` = indlabins$body$dataset
        )
      )
    
    # save
    output_file <- paste0(tools::file_path_sans_ext(output_file), '.xlsx')
    writexl::write_xlsx(out, path = file.path(output_dir, output_file))
    file_loc <- list.files(path = output_dir, pattern = paste0('^', output_file), full.names = TRUE)
    
    msg <- paste("Spreadsheet created successfully! File located at", file_loc)
    message(msg)
    
  }
  
}
