#' Format data quality objective completeness data
#'
#' @param frecomdat input data fram
#'
#' @details This function is used internally within \code{\link{read_frecom}} to format the input data for downstream analysis.  The formatting includes:
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
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness_final.xlsx', 
#'      package = 'MassWateR')
#' 
#' frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
#'       skip = 1, na = c('NA', 'na', ''), 
#'       col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
#'     )) %>% 
#'     rename(`% Completeness` = `...7`)
#'     
#' form_frecom(frecomdat)
form_frecom <- function(frecomdat){
  
  # convert all parameters to simple
  out <- dplyr::mutate(frecomdat, # match any entries in Parameter that are WQX Parameter to Simple Parameter
            `Parameter` = dplyr::case_when(
              `Parameter` %in% params$`WQX Parameter` ~ params$`Simple Parameter`[match(`Parameter`, params$`WQX Parameter`)], 
              T ~ `Parameter`
            )
          )
  
  return(out)
  
}
