#' Check data quality objective completeness data
#'
#' @param dqocomdat input data frame
#'
#' @details This function is used internally within \code{\link{read_dqocompleteness}} to run several checks on the input data for completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Parameter, Field Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check Accuracy, % Completeness}
#'  \item{Columns present: }{All columns from the previous check should be present}
#'  \item{Non-numeric values: }{Values entered in columns other than the first should be numeric}
#'  \item{Values outside of 0 - 100: }{Values entered in columns other than the first should not be outside of 0 and 100}
#' }
#' 
#' @return \code{dqocomdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' dqocompth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
#' 
#' dqocomdat <- suppressMessages(readxl::read_excel(dqocompth, 
#'       skip = 1, na = c('na', ''), 
#'       col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
#'     )) %>% 
#'     rename(`% Completeness` = `...7`)
#'     
#' check_dqocompleteness(dqocomdat)
check_dqocompleteness <- function(dqocomdat){
  
  message('Running checks on data quality objectives for completeness...\n')
  
  # globals
  colnms <- c("Parameter", "Field Duplicate", "Lab Duplicate", "Field Blank", 
              "Lab Blank", "Spike/Check Accuracy", "% Completeness")
  
  # check field names
  message('\tChecking column names...')
  nms <- names(dqocomdat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop('Please correct the column names or remove: ', paste(tochk, collapse = ', '))
  }

  # check all fields are present
  message('\tChecking all required columns are present...')
  nms <- names(dqocomdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop('Missing the following columns: ', paste(tochk, collapse = ', '))
  }
  
  # check for any non-numeric columns
  message('\tChecking for non-numeric values...')
  typ <- dqocomdat %>% 
    dplyr::select(-Parameter) %>% 
    lapply(class) %>% 
    unlist
  chk <- typ %in% 'numeric'
  if(any(!chk)){
    tochk <- names(typ)[!chk]
    stop('Non-numeric values found in columns: ', paste(tochk, collapse = ', '))
  }

  # check for values not between 0 and 100
  message('\tChecking for values outside of 0 and 100...')
  typ <- dqocomdat %>% 
    dplyr::select(-Parameter) %>% 
    lapply(range, na.rm = TRUE)
  chk <- lapply(typ, function(x) x < 0 | x > 100) %>%
    lapply(any) %>% 
    unlist
  if(any(chk)){
    tochk <- names(chk)[chk]
    stop('Values less than 0 or greater than 100 found in columns: ', paste(tochk, collapse = ', '))
  }
  
  message('\nAll checks passed!')
  
  return(dqocomdat)
  
}
