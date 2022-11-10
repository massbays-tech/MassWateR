#' Check water quality exchange (wqx) metadata input 
#'
#' @param wqxdat input data frame
#' @param warn logical to return warnings to the console (default)
#'
#' @details This function is used internally within \code{\link{readMWRwqx}} to run several checks on the input data for conformance with downstream functions
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Parameter, Sampling Method Context, Method Speciation, Result Sample Fraction, Analytical Method, Analytical Method Context}
#'  \item{Columns present: }{All columns from the previous check should be present}
#'  \item{Unique parameters: }{Values in \code{Parameter} should be unique (no duplicates)}
#'  \item{Parameter: }{Should match parameter names in the \code{Simple Parameter} or \code{WQX Parameter} columns of the \code{\link{paramsMWR}} data (warning only)}
#' }
#' 
#' @return \code{wqxdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. Checks with warnings can be fixed at the discretion of the user before proceeding.
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')
#' 
#' wqxdat <- readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text')
#'     
#' checkMWRwqx(wqxdat)
checkMWRwqx <- function(wqxdat, warn = TRUE){
  
  message('Running checks on WQX metadata...\n')
  wrn <- 0
  
  # globals
  colnms <- c("Parameter", "Sampling Method Context", "Method Speciation", 
              "Result Sample Fraction", "Analytical Method", "Analytical Method Context")
  chntyp <- sort(unique(c(paramsMWR$`Simple Parameter`, paramsMWR$`WQX Parameter`)))

  # check field names
  msg <- '\tChecking column names...'
  nms <- names(wqxdat)
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check all fields are present
  msg <- '\tChecking all required columns are present...'
  nms <- names(wqxdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check unique parameters
  msg <- '\tChecking unique parameters...'
  typ <- wqxdat$Parameter
  chk <- !duplicated(typ)
  if(any(!chk)){
    tochk <- sort(typ[!chk])
    stop(msg, '\n\tDuplicate parameters found in the Parameter column: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check parameters
  msg <- '\tChecking Parameter formats...'
  typ <- wqxdat$Parameter
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
  
  return(wqxdat)
  
}
