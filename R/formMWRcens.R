#' Format censored data
#'
#' @param censdat input data frame
#'
#' @details This function is used internally within \code{\link{readMWRcens}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item Convert Parameter: All parameters are converted to \code{Simple Parameter} in \code{\link{paramsMWR}} as needed, 
#'   \item Convert Missed and Censored Records: All values are converted to numeric
#' }
#' 
#' @return A formatted data frame of the censored data
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' censpth <- system.file('extdata/ExampleCensored.xlsx', 
#'      package = 'MassWateR')
#' 
#' censdat <- suppressMessages(readxl::read_excel(censpth, 
#'       skip = 1, na = c('NA', 'na', '')
#'     )) 
#'     
#' formMWRcens(censdat)
formMWRcens <- function(censdat){
  
  # convert all parameters to simple
  out <- dplyr::mutate(censdat, # match any entries in Parameter that are WQX Parameter to Simple Parameter
                       `Parameter` = ifelse(
                         `Parameter` %in% paramsMWR$`WQX Parameter`,
                         paramsMWR$`Simple Parameter`[match(`Parameter`, paramsMWR$`WQX Parameter`)], 
                         `Parameter`
                       ),
                       `Missed and Censored Records` = as.numeric(`Missed and Censored Records`)
  )
  
  return(out)
  
}
