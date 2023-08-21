#' Check data quality objective accuracy data
#'
#' @param accdat input data frame
#' @param warn logical to return warnings to the console (default)
#'
#' @details This function is used internally within \code{\link{readMWRacc}} to run several checks on the input data for completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Parameter, uom, MDL, UQL, Value Range, Field Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check Accuracy}
#'  \item{Columns present: }{All columns from the previous check should be present}
#'  \item{Column types: }{All columns should be characters/text, except for MDL and UQL}
#'  \item{\code{Value Range} column na check: }{The character string \code{"na"} should not be in the \code{Value Range} column, \code{"all"} should be used if the entire range applies}
#'  \item{Unrecognized characters: }{Fields describing accuracy checks should not include symbols or text other than \eqn{<=}, \eqn{\leq}, \eqn{<}, \eqn{>=}, \eqn{\geq}, \eqn{>}, \eqn{\pm}, \code{"\%"}, \code{"BDL"}, \code{"AQL"}, \code{"log"}, or \code{"all"}}
#'  \item{Number of rows per parameter in \code{Value Range}: }{Should not exceed two}
#'  \item{Overlap in \code{Value Range} column: }{Entries in \code{Value Range} should not overlap for a parameter}
#'  \item{Gap in \code{Value Range} column: }{Entries in \code{Value Range} should not include a gap for a parameter, warning only}
#'  \item{Parameter: }{Should match parameter names in the \code{Simple Parameter} or \code{WQX Parameter} columns of the \code{\link{paramsMWR}} data}
#'  \item{Units: }{No missing entries in units (\code{uom}), except pH which can be blank}
#'  \item{Single unit: }{Each unique \code{Parameter} should have only one type for the units (\code{uom})}
#'  \item{Correct units: }{Each unique \code{Parameter} should have an entry in the units (\code{uom}) that matches one of the acceptable values in the \code{Units of measure} column of the \code{\link{paramsMWR}} data}
#'  \item{Empty columns: }{Columns with all missing or NA values will return a warning}
#' }
#'
#' @return \code{accdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @encoding UTF-8
#'
#' @export
#'
#' @examples
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # accuracy data with no checks
#' accdat <- readxl::read_excel(accpth, na = c('NA', ''), col_types = 'text')
#' accdat <- dplyr::mutate(accdat, dplyr::across(-c(`Value Range`), ~ dplyr::na_if(.x, 'na'))) 
#'       
#' checkMWRacc(accdat)
checkMWRacc <- function(accdat, warn = TRUE){

  message('Running checks on data quality objectives for accuracy...\n')
  wrn <- 0
  
  # globals
  colnms <- c("Parameter", "uom", "MDL", "UQL", "Value Range", "Field Duplicate", 
              "Lab Duplicate", "Field Blank", "Lab Blank", "Spike/Check Accuracy")
  coltyp <- c("character", "character", "numeric", "numeric", "character", "character", "character", 
               "character", "character", "character")
  # 00b1 is plus/minus, 2265 is greater than or equal to, 2264 is less than or equal to 
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')
  chntyp <- sort(unique(c(paramsMWR$`Simple Parameter`, paramsMWR$`WQX Parameter`)))
  
  # check field names
  msg <- '\tChecking column names...'
  nms <- names(accdat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check all fields are present
  msg <- '\tChecking all required columns are present...'
  nms <- names(accdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # checking column types
  msg <- '\tChecking column types...'
  numcol <- names(accdat) %in% c('MDL', 'UQL') # should be the only numeric columns
  typnum <- accdat[, numcol]
  typchr <- accdat[, !numcol]
  chknum <- sapply(typnum, function(x) {
    if(all(is.na(x))) return(TRUE)
    numc <- suppressWarnings(as.numeric(na.omit(x)))
    !any(is.na(numc))
  })
  chkchr <- sapply(typchr, function(x) {
    if(all(is.na(x))) return(TRUE)
    all(!grepl('^(?=.)([+-]?([0-9]*)(\\.([0-9]+))?)$', na.omit(x), perl = TRUE))
  })
  chk <- c(chknum, chkchr)[names(accdat)]
  if(any(!chk)){
    tochk <- names(chk[!chk])
    totyp <- coltyp[!chk]
    tochk <- paste(tochk, paste('should be', totyp), sep = '-')
    stop(msg, '\n\tIncorrect column type found in columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check for na in value column
  msg <- '\tChecking no "na" in Value Range...'
  typ <- accdat$`Value Range`
  chk <- !typ %in% 'na'
  if(any(!chk)){
    rws <- which(!chk)
    stop(msg, '\n\tReplace "na" in Value Range with "all" for row(s): ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check for symbols other than <=, <, >=, >, ±, or %
  msg <- '\tChecking for text other than <=, \u2264, <, >=, \u2265, >, \u00b1, %, AQL, BQL, log, or all...'
  typ <- accdat %>% 
    dplyr::select(-Parameter, -uom, -MDL, -UQL) %>%
    lapply(function(x) gsub(paste(colsym, collapse = '|'), '', x)) %>% 
    lapply(function(x) tryCatch(as.numeric(x),error=function(e) e, warning=function(w) w)) %>% 
    lapply(inherits, 'warning') %>% 
    unlist
  chk <- !typ
  if(any(!chk)){
    tochk <- names(typ[!chk])
    stop(msg, '\n\tUnrecognized text in columns: ', paste0(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'), domain = NA)

  # Number of rows per parameter
  msg <- '\tChecking number of rows per parameter...'
  chk <- table(accdat$Parameter)
  chk <- chk <= 2
  if(any(!chk)){
    tochk <- names(chk)[!chk]
    stop(msg, '\n\tMore than two rows: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check overlap in value range
  msg <- '\tChecking overlaps in Value Range...'
  typ <- utilMWRvaluerange(accdat)
  chk <- !typ %in% 'overlap'
  if(any(!chk)){
    nms <- names(typ)[!chk]
    stop(msg, '\n\tOverlap in value range: ', paste(nms, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check gap in value range
  msg <- '\tChecking gaps in Value Range...'
  typ <- utilMWRvaluerange(accdat)
  chk <- !typ %in% 'gap'
  if(any(!chk)){
    nms <- names(typ)[!chk]
    if(warn)
      warning(msg, '\n\tGap in value range: ', paste(nms, collapse = ', '), call. = FALSE)
    wrn <- wrn + 1
    message(paste(msg, 'WARNING'))
  } else {
    message(paste(msg, 'OK'))
  }
  
  # check parameter names
  msg <- '\tChecking Parameter formats...'
  typ <- accdat$`Parameter`
  chk <- typ %in% chntyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect Parameter found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check no missing entries in uom, except pH
  msg <- '\tChecking for missing entries for unit (uom)...'
  chk <- accdat[, c('Parameter', 'uom')]
  chk <- is.na(chk$`uom`) & !chk$`Parameter` %in% 'pH'
  chk <- !chk
  if(any(!chk)){
    rws <- which(!chk)
    stop(msg, '\n\tMissing unit (uom) in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check different units for each parameter
  msg <- '\tChecking if more than one unit (uom) per Parameter...'
  typ <- accdat[, c('Parameter', 'uom')]
  typ <- unique(typ)
  chk <- !duplicated(typ$`Parameter`)
  if(any(!chk)){
    tochk <- typ[!chk, 'Parameter', drop = TRUE]
    tochk <- typ[typ$`Parameter` %in% tochk, ]
    tochk <- dplyr::group_by(tochk, `Parameter`)
    tochk <- tidyr::nest(tochk)
    tochk$data <- lapply(tochk$data, function(x) paste(x[[1]], collapse = ', '))
    tochk <- tidyr::unnest(tochk, cols = 'data')
    tochk <- tidyr::unite(tochk, 'res', sep = ': ')[[1]]
    stop(msg, '\n\tMore than one unit (uom) found for Parameter: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # convert all Parameters to simple so that units can be verified

  # check acceptable units for each parameter, must check all parameter names simple or wqx in paramsMWR
  msg <- '\tChecking acceptable units (uom) for each entry in Parameter...'
  typ <- accdat[, c('Parameter', 'uom')]
  typ <- unique(typ)
  typ$`uom`[(is.na(typ$`uom`) | typ$`uom` == 's.u.') & typ$`Parameter` == 'pH'] <- 'blank'
  tojn <- paramsMWR[, c('Simple Parameter', 'Units of measure')]
  tojn <- dplyr::rename(tojn, `Parameter` = `Simple Parameter`)
  typ <- dplyr::left_join(typ, tojn, by = 'Parameter')
  tojn <- paramsMWR[, c('WQX Parameter', 'Units of measure')] # repeat for wqx parameter names
  tojn <- dplyr::rename(tojn, `Parameter` = `WQX Parameter`)
  typ <- dplyr::left_join(typ, tojn, by = 'Parameter')
  typ <- dplyr::rowwise(typ)
  typ <- dplyr::mutate(typ, 
    `Units of measure` = na.omit(unique(c(`Units of measure.x`, `Units of measure.y`)))
  )
  chk <- dplyr::mutate(typ, 
    fnd = grepl(`uom`, `Units of measure`, fixed = TRUE)
  )
  if(any(!chk$fnd)){
    tochk <- chk[!chk$fnd, c('Parameter', 'uom')]
    tochk <- tidyr::unite(tochk, 'res', sep = ': ')[[1]]
    stop(msg, '\n\tIncorrect units (uom) found for Parameters: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check empty columns
  msg <- '\tChecking empty columns...'
  chk <- accdat %>% 
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
  
  return(accdat)
  
}
