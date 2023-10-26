#' Check data quality objective frequency and completeness data
#'
#' @param frecomdat input data frame
#' @param warn logical to return warnings to the console (default)
#'
#' @details This function is used internally within \code{\link{readMWRfrecom}} to run several checks on the input data for frequency and completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item Column name spelling: Should be the following: Parameter, Field Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check Accuracy, % Completeness
#'  \item Columns present: All columns from the previous check should be present
#'  \item Non-numeric values: Values entered in columns other than the first should be numeric
#'  \item Values outside of 0 - 100: Values entered in columns other than the first should not be outside of 0 and 100
#'  \item Parameter: Should match parameter names in the \code{Simple Parameter} or \code{WQX Parameter} columns of the \code{\link{paramsMWR}} data
#'  \item Empty columns: Columns with all missing or NA values will return a warning
#' }
#' 
#' @return \code{frecomdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
#'       skip = 1, na = c('NA', 'na', ''), 
#'       col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
#'     )) %>% 
#'     rename(`% Completeness` = `...7`)
#'     
#' checkMWRfrecom(frecomdat)
checkMWRfrecom <- function(frecomdat, warn = TRUE){
  
  message('Running checks on data quality objectives for frequency and completeness...\n')
  wrn <- 0
  
  # globals
  colnms <- c("Parameter", "Field Duplicate", "Lab Duplicate", "Field Blank", 
              "Lab Blank", "Spike/Check Accuracy", "% Completeness")
  chntyp <- sort(unique(c(paramsMWR$`Simple Parameter`, paramsMWR$`WQX Parameter`)))
  
  # check field names
  msg <- '\tChecking column names...'
  nms <- names(frecomdat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
    
  }
  message(paste(msg, 'OK'))

  # check all fields are present
  msg <- '\tChecking all required columns are present...'
  nms <- names(frecomdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check for any non-numeric columns
  msg <- '\tChecking for non-numeric values...'
  typ <- frecomdat %>% 
    dplyr::select(-Parameter) %>% 
    lapply(class) %>% 
    unlist
  typ <- typ[typ != 'logical']
  chk <- typ %in% 'numeric'
  if(any(!chk)){
    tochk <- names(typ)[!chk]
    stop(msg, '\n\tNon-numeric values found in columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check for values not between 0 and 100
  msg <- '\tChecking for values outside of 0 and 100...'
  typ <- frecomdat %>% 
    dplyr::select(-Parameter) %>% 
    lapply(function(x){ 
      if(all(is.na(x)))
        c(NA, NA)
      else
        range(x, na.rm = T)
      }
    )
  chk <- lapply(typ, function(x) x < 0 | x > 100) %>%
    lapply(any) %>% 
    unlist
  if(any(chk, na.rm = T)){
    tochk <- names(chk)[chk]
    stop(msg, '\n\tValues less than 0 or greater than 100 found in columns: ', paste(tochk, collapse = ', ', call. = FALSE))
  }
  message(paste(msg, 'OK'))
  
  # check parameter names
  msg <- '\tChecking Parameter formats...'
  typ <- frecomdat$`Parameter`
  chk <- typ %in% chntyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect Parameter found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check empty columns
  msg <- '\tChecking empty columns...'
  chk <- frecomdat %>% 
    lapply(function(x) ifelse(all(is.na(x)), F, T)) %>% 
    unlist
  if(any(!chk)){
    nms <- names(chk)[which(!chk)]
    if(warn)
      warning(msg, '\n\tEmpty columns found: ', paste(nms, collapse = ', '), call. = FALSE)
    wrn <- wrn + 1
    message(paste(msg, 'WARNING'))
  } else {
    message(paste(msg, 'OK'))
  }

  # final out message
  outmsg <- '\nAll checks passed'
  if(wrn > 0)
    outmsg <- paste0(outmsg, ' (', wrn, ' WARNING(s))')
  outmsg <- paste0(outmsg, '!')
  message(outmsg)
  
  return(frecomdat)
  
}
