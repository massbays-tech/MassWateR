#' Master parameter list and units for Characteristic Name column in results data
#' 
#' Master parameter list and units for Characteristic Name column in results data
#' 
#' @format A \code{data.frame}
#' 
#' @details This information is used to verify the correct format of input data and for formatting output data for upload to WQX.  A column showing the corresponding WQX names is also included.
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' library(dplyr)
#' 
#' paramsMWR <- read_excel('inst/extdata/ParameterMapping.xlsx')
#' 
#' save(paramsMWR, file = 'data/paramsMWR.RData', compress = 'xz')
#' }
"paramsMWR"
