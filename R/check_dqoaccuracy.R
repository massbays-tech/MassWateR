#' Check data quality objective accuracy data
#'
#' @param dqoaccdat input data frame
#'
#' @details This function is used internally within \code{\link{read_dqoaccuracy}} to run several checks on the input data for completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Parameter, uom, MDL, UQL, Value Range, Field Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check Accuracy}
#'  \item{Columns present: }{All columns from the previous check should be present}
#'  \item{Non-numeric values in MDL, UQL: }{Values entered in columns MDL and UQL should be numeric}
#'  \item{Unrecognized characters: }{Fields describing accuracy checks should not include symbols or text other than \eqn{<=}, \eqn{\leq}, \eqn{<}, \eqn{>=}, \eqn{\geq}, \eqn{>}, \eqn{\pm}, %, BDL, AQL, log, or all}
#'  \item{Parameter: }{Should match parameter names in the \code{Simple Parameter} or \code{WQX Parameter} columns of the \code{\link{params}} data}
#'  \item{Units: }{No missing entries in units (\code{uom}), except pH which can be blank}
#'  \item{Single unit: }{Each unique \code{Parameter} should have only one type for the units (\code{uom})}
#'  \item{Correct units: }{Each unique \code{Parameter} should have an entry in the units (\code{uom}) that matches one of the acceptable values in the \code{Units of measure} column of the \code{\link{params}} data}
#' }
#'
#' @return \code{dqoaccdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @encoding UTF-8
#'
#' @export
#'
#' @examples
#' dqoaccpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' dqoaccdat <- readxl::read_excel(dqoaccpth, na = c('NA', 'na', '')) 
#'       
#' check_dqoaccuracy(dqoaccdat)
check_dqoaccuracy <- function(dqoaccdat){
  
  message('Running checks on data quality objectives for accuracy...\n')
  
  # globals
  colnms <- c("Parameter", "uom", "MDL", "UQL", "Value Range", "Field Duplicate", 
              "Lab Duplicate", "Field Blank", "Lab Blank", "Spike/Check Accuracy")
  # 00b1 is plus/minus, 2265 is greater than or equal to, 2264 is less than or equal to 
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')
  chntyp <- sort(unique(c(params$`Simple Parameter`, params$`WQX Parameter`)))
  
  # check field names
  msg <- '\tChecking column names...'
  nms <- names(dqoaccdat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check all fields are present
  msg <- '\tChecking all required columns are present...'
  nms <- names(dqoaccdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check for any non-numeric values in MDL, UQL 
  msg <- '\tChecking for non-numeric values in MDL, UQL...'
  typ <- dqoaccdat %>% 
    dplyr::select(MDL, UQL) %>% 
    lapply(class) %>% 
    unlist
  chk <- typ %in% 'numeric'
  if(any(!chk)){
    tochk <- names(typ)[!chk]
    stop(msg, '\n\tNon-numeric values found in columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check for symbols other than <=, <, >=, >, ±, or %
  msg <- '\tChecking for text other than <=, \u2264, <, >=, \u2265, >, \u00b1, %, AQL, BQL, log, or all...'
  typ <- dqoaccdat %>% 
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
  message(paste(msg, 'OK'))
  
  # check parameter names
  msg <- '\tChecking Parameter formats...'
  typ <- dqoaccdat$`Parameter`
  chk <- typ %in% chntyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect Parameter found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check no missing entries in uom, except pH
  msg <- '\tChecking for missing entries for unit (uom)...'
  chk <- dqoaccdat[, c('Parameter', 'uom')]
  chk <- is.na(chk$`uom`) & !chk$`Parameter` %in% 'pH'
  chk <- !chk
  if(any(!chk)){
    rws <- which(!chk)
    stop(msg, '\n\tMissing unit (uom) in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check different units for each parameter
  msg <- '\tChecking if more than one unit (uom) per Parameter...'
  typ <- dqoaccdat[, c('Parameter', 'uom')]
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
  
  # check acceptable units for each parameter
  msg <- '\tChecking acceptable units (uom) for each entry in Parameter...'
  typ <- dqoaccdat[, c('Parameter', 'uom')]
  typ <- unique(typ)
  typ$`uom`[is.na(typ$`uom`) & typ$`Parameter` == 'pH'] <- 'NA'
  tojn <- params[, c('Simple Parameter', 'Units of measure')]
  tojn <- dplyr::rename(tojn, `Parameter` = `Simple Parameter`)
  typ <- dplyr::left_join(typ, tojn, by = 'Parameter')
  chk <- dplyr::rowwise(typ)
  chk <- dplyr::mutate(chk, 
                       fnd = grepl(`uom`, `Units of measure`, fixed = TRUE)
  )
  if(any(!chk$fnd)){
    tochk <- chk[!chk$fnd, c('Parameter', 'uom')]
    tochk <- tidyr::unite(tochk, 'res', sep = ': ')[[1]]
    stop(msg, '\n\tIncorrect units (uom) found for Parameters: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  message('\nAll checks passed!')
  
  return(dqoaccdat)
  
}
