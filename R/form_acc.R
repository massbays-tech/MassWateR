#' Format data quality objective accuracy data
#'
#' @param accdat input data fram
#'
#' @details This function is used internally within \code{\link{read_acc}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Convert Parameter: }{All parameters are converted to \code{Simple Parameter} in \code{\link{params}} as needed}
#' }
#' 
#' @export
#'
#' @examples
#' accpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' accdat <- readxl::read_excel(accpth, na = c('NA', 'na', '')) 
#' 
#' form_acc(accdat)
form_acc <- function(accdat){
  
  # convert all parameters to simple
  out <- dplyr::mutate(accdat, # match any entries in Parameter that are WQX Parameter to Simple Parameter
                       `Parameter` = dplyr::case_when(
                         `Parameter` %in% params$`WQX Parameter` ~ params$`Simple Parameter`[match(`Parameter`, params$`WQX Parameter`)], 
                         T ~ `Parameter`
                       )
  )
  
  return(out)
  
}
