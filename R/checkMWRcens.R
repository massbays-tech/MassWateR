#' Check censored data
#'
#' @param censdat input data frame for results
#' @param warn logical to return warnings to the console (default)
#'
#' @details This function is used internally within \code{\link{readMWRcens}} to run several checks on the input data for completeness and conformance.
#' 
#' The following checks are made: 
#' \itemize{
#'  \item Column name spelling: Should be the following: Parameter, Missed and Censored Records
#'  \item Columns present: All columns from the previous check should be present
#'  \item Non-numeric Missed and Censored Records: All values should be numbers, excluding missing values
#'  \item Negative Missed and Censored Records: All values should be greater than or equal to zero
#'  \item Parameter: Should match parameter names in the \code{Simple Parameter} or \code{WQX Parameter} columns of the \code{\link{paramsMWR}} data (warning only)
#' }
#' 
#' @return \code{censdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. Checks with warnings can be fixed at the discretion of the user before proceeding.
#' 
#' @export
#'
#' @examples
#' censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')
#' 
#' censdat <- suppressWarnings(readxl::read_excel(censpth, na = c('NA', 'na', ''), guess_max = Inf)) 
#'              
#' checkMWRcens(censdat)
checkMWRcens <- function(censdat, warn = TRUE){
  
  message('Running checks on censored data...\n')
  wrn <- 0
  
  # globals
  colnms <- c("Parameter", "Missed and Censored Records")
  chntyp <- sort(unique(c(paramsMWR$`Simple Parameter`, paramsMWR$`WQX Parameter`)))

  # check field names
  msg <- '\tChecking column names...'
  nms <- names(censdat)
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check all fields are present
  msg <- '\tChecking all required columns are present...'
  nms <- names(censdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check for non-numeric censored data
  msg <- '\tChecking for non-numeric values in Missed and Censored Records...'
  typ <- censdat$`Missed and Censored Records`
  chk <- !grepl('[[:alpha:]]', typ, ignore.case = TRUE)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tNon-numeric entries in Missed and Censored Records found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check censored data 0 or more
  msg <- '\tChecking for negative values in Missed and Censored Records...'
  typ <- censdat$`Missed and Censored Records`
  chk <- typ >= 0
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tNegative entries in Missed and Censored Records found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  
  # check parameter names
  msg <- '\tChecking Parameter Name formats...'
  typ <- censdat$`Parameter`
  chk <- typ %in% chntyp
  if(any(!chk)){
    tochk <- unique(typ[!chk])
    if(warn)
      warning(msg, '\n\tParameter not included in approved parameters: ', paste(tochk, collapse = ', '), call. = FALSE)
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
  
  return(censdat)
  
}
