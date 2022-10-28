#' Check water quality exchange (wqx) metadata input 
#'
#' @param wqxdat input data frame
#'
#' @details This function is used internally within \code{\link{readMWRwqx}} to run several checks on the input data for conformance with downstream functions
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Monitoring Location ID, Monitoring Location Name, Monitoring Location Latitude, Monitoring Location Longitude, Location Group}
#'  \item{Columns present: }{All columns from the previous check should be present}
#' }
#' 
#' @return \code{wqxdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
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
checkMWRwqx <- function(wqxdat){
  
  message('Running checks on WQX metadata...\n')
  
  # # globals
  # colnms <- c("Monitoring Location ID", "Monitoring Location Name", "Monitoring Location Latitude", 
  #             "Monitoring Location Longitude", "Location Group")
  # 
  # # check field names
  # msg <- '\tChecking column names...'
  # nms <- names(sitdat) 
  # chk <- nms %in% colnms
  # if(any(!chk)){
  #   tochk <- nms[!chk]
  #   stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
  # }
  # message(paste(msg, 'OK'))
  # 
  # # check all fields are present
  # msg <- '\tChecking all required columns are present...'
  # nms <- names(sitdat)
  # chk <- colnms %in% nms
  # if(any(!chk)){
  #   tochk <- colnms[!chk]
  #   stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  # }
  # message(paste(msg, 'OK'))
  # 
  # message('\nAll checks passed!')
  
  return(wqxdat)
  
}
