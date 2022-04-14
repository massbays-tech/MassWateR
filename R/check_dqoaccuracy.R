#' Check data quality objective accuracy data
#'
#' @param dat input data frame
#'
#' @details This function is used internally within \code{\link{read_dqoaccuracy}} to run several checks on the input data for completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Parameter, uom, MDL, UQL, Value Range, Field Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check Accuracy}
#'  \item{Columns present: }{All columns from the previous check should be present}
#'  \item{Non-numeric values in MDL, UQL: }{Values entered in columns MDL and UQL should be numeric}
#'  \item{Unrecognized characters: }{Fields describing accuracy checks should not include symbols or text other than <=, <, >=, >, ±, %, BDL, AQL, log, or all}
#' }
#'
#' @return \code{dat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @encoding UTF-8
#'
#' @export
#'
#' @examples
#' pth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' dat <- readxl::read_excel(pth, na = c('na', '')) 
#'       
#' check_dqoaccuracy(dat)
check_dqoaccuracy <- function(dat){
  
  message('Running checks on data quality objectives for accuracy...\n')
  
  # globals
  colnms <- c("Parameter", "uom", "MDL", "UQL", "Value Range", "Field Duplicate", 
              "Lab Duplicate", "Field Blank", "Lab Blank", "Spike/Check Accuracy")
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '%', 'AQL', 'BDL', 'log', 'all')
  
  # check field names
  message('\tChecking column names...')
  nms <- names(dat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop('Please correct the column names or remove: ', paste(tochk, collapse = ', '))
  }

  # check all fields are present
  message('\tChecking all required columns are present...')
  nms <- names(dat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop('Missing the following columns: ', paste(tochk, collapse = ', '))
  }
  
  # check for any non-numeric values in MDL, UQL 
  message('\tChecking for non-numeric values in MDL, UQL...')
  typ <- dat %>% 
    dplyr::select(MDL, UQL) %>% 
    lapply(class) %>% 
    unlist
  chk <- typ %in% 'numeric'
  if(any(!chk)){
    tochk <- names(typ)[!chk]
    stop('Non-numeric values found in columns: ', paste(tochk, collapse = ', '))
  }

  # check for symbols other than <=, <, >=, >, ±, or %
  message('\tChecking for text other than <=, <, >=, >, \u00b1, %, AQL, BQL, log, or all...')
  typ <- dat %>% 
    dplyr::select(-Parameter, -uom, -MDL, -UQL) %>%
    lapply(function(x) gsub(paste(colsym, collapse = '|'), '', x)) %>% 
    lapply(function(x) tryCatch(as.numeric(x),error=function(e) e, warning=function(w) w)) %>% 
    lapply(inherits, 'warning') %>% 
    unlist
  chk <- !typ
  if(any(!chk)){
    tochk <- names(typ[!chk])
    stop('Unrecognized text in columns: ', paste0(tochk, collapse = ', '))
  }
  
  message('\nAll checks passed!')
  
  return(dat)
  
}
