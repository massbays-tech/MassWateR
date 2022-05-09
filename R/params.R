#' Master parameter list and units for Characteristic Name column in results data
#' 
#' Master parameter list and units for Characteristic Name column in results data
#' 
#' @format A \code{data.frame} of 39 rows and 5 columns
#' 
#' @details This information is used to verify the correct format of input results data in \code{\link{form_results}}.  A column showing the corresponding WQX names is also included.
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' library(dplyr)
#' 
#' params <- read_excel('inst/extdata/Parameter.Mapping.xlsx') %>% 
#'   rename(Note = `...5`)
#' 
#' save(params, file = 'data/params.RData', compress = 'xz')
#' }
"params"