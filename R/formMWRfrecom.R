#' Format data quality objective frequency and completeness data
#'
#' @param frecomdat input data frame
#'
#' @details This function is used internally within \code{\link{readMWRfrecom}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item Convert Parameter: All parameters are converted to \code{Simple Parameter} in \code{\link{paramsMWR}} as needed
#' }
#' 
#' @return A formatted data frame of the data quality objectives file for frequency and completeness
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
#'       skip = 1, na = c('NA', 'na', ''), 
#'       col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
#'     )) %>% 
#'     rename(`% Completeness` = `...7`)
#'     
#' formMWRfrecom(frecomdat)
formMWRfrecom <- function(frecomdat){
  
  # convert all parameters to simple
  out <- dplyr::mutate(frecomdat, # match any entries in Parameter that are WQX Parameter to Simple Parameter
            `Parameter` = ifelse(
              `Parameter` %in% paramsMWR$`WQX Parameter`,
              paramsMWR$`Simple Parameter`[match(`Parameter`, paramsMWR$`WQX Parameter`)], 
              `Parameter`
            )
          )
  
  return(out)
  
}
