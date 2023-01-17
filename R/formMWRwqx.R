#' Format WQX metadata input
#'
#' @param wqxdat input data frame for wqx metadata
#'
#' @details This function is used internally within \code{\link{readMWRwqx}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Convert characteristic names: }{All parameters in \code{Characteristic Name} are converted to \code{Simple Parameter} in \code{\link{paramsMWR}} as needed}
#' }
#' 
#' @import dplyr
#' @import tidyr
#' 
#' @return A formatted data frame of the WQX metadata file
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
  
  # convert all characteristic names to simple
  out <- dplyr::mutate(wqxdat,
                       Parameter = dplyr::case_when(
                         Parameter %in% paramsMWR$`WQX Parameter` ~ paramsMWR$`Simple Parameter`[match(Parameter, paramsMWR$`WQX Parameter`)], 
                         T ~ Parameter
                       )
    )
  
  return(out)
  
}
