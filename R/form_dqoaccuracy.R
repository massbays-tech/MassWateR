#' Format data quality objective accuracy data
#'
#' @param dqoaccdat input data fram
#'
#' @details This function is used internally within \code{\link{read_dqoaccuracy}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Convert Parameter: }{All parameters are converted to \code{Simple Parameter} in \code{\link{params}} as needed}
#' }
#' 
#' @export
#'
#' @examples
#' dqoaccpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' dqoaccdat <- readxl::read_excel(dqoaccpth, na = c('NA', 'na', '')) 
#' 
#' form_dqoaccuracy(dqoaccdat)
form_dqoaccuracy <- function(dqoaccdat){
  
  # convert all parameters to simple
  out <- dplyr::mutate(dqoaccdat, # match any entries in Parameter that are WQX Parameter to Simple Parameter
                       `Parameter` = dplyr::case_when(
                         `Parameter` %in% params$`WQX Parameter` ~ params$`Simple Parameter`[match(`Parameter`, params$`WQX Parameter`)], 
                         T ~ `Parameter`
                       )
  )
  
  return(out)
  
}