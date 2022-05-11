#' Format data quality objective completeness data
#'
#' @param dqocomdat input data fram
#'
#' @details This function is used internally within \code{\link{read_dqocompleteness}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Convert Parameter: }{All parameters are converted to \code{Simple Parameter} in \code{\link{params}} as needed}
#' }
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' dqocompth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
#' 
#' dqocomdat <- suppressMessages(readxl::read_excel(dqocompth, 
#'       skip = 1, na = c('NA', 'na', ''), 
#'       col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
#'     )) %>% 
#'     rename(`% Completeness` = `...7`)
#'     
#' form_dqocompleteness(dqocomdat)
form_dqocompleteness <- function(dqocomdat){
  
  # convert all parameters to simple
  out <- dplyr::mutate(dqocomdat, # match any entries in Parameter that are WQX Parameter to Simple Parameter
            `Parameter` = dplyr::case_when(
              `Parameter` %in% params$`WQX Parameter` ~ params$`Simple Parameter`[match(`Parameter`, params$`WQX Parameter`)], 
              T ~ `Parameter`
            )
          )
  
  return(out)
  
}