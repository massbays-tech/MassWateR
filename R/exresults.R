#' Example file of water quality results
#' 
#' Example file of water quality results 
#' 
#' @format A \code{data.frame} of 2584 rows and 14 columns
#' 
#' @details An example of water quality data formatted for input in the QAQC or exploratory analysis workflow
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' 
#' exresults <- read_excel('inst/extdata/ExampleResults_final.xlsx', 
#'   col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text',
#'     'text', 'text', 'text', 'text')
#'   )
#' 
#' save(exresults, file = 'data/exresults.RData', compress = 'xz')
#' }
"exresults"