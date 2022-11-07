#' Format WQX metadata input
#'
#' @param wqxdat input data frame for wqx metadata
#'
#' @details This function is used internally within \code{\link{readMWRwqx}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Convert characteristic names: }{All parameters in \code{Characteristic Name} are converted to \code{WQX Paramater} in \code{\link{paramsMWR}} as needed}
#' }
#' 
#' @import dplyr
#' @import tidyr
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')
#' 
#' wqxdat <- suppressWarnings(readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text'))
#'   
#' formMWRwqx(wqxdat)
formMWRwqx <- function(wqxdat){
  
  # convert all characteristic names to wqx
  out <- dplyr::mutate(wqxdat, # match any entries in Characteristic Name that are Simple Parameter to WQX Parameter
                       `WQX Parameter` = dplyr::case_when(
                         Parameter %in% paramsMWR$`Simple Parameter` ~ paramsMWR$`WQX Parameter`[match(Parameter, paramsMWR$`Simple Parameter`)], 
                         T ~ Parameter
                       )
    ) %>% 
    dplyr::select(-Parameter) %>% 
    dplyr::select(`WQX Parameter`, dplyr::everything())
  
  return(out)
  
}
