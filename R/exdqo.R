#' Example file of data quality objectives
#' 
#' Example file of data quality objectives
#' 
#' @format A \code{data.frame} of 21 rows and 10 columns
#' 
#' @details An example of data quality objectives formatted for comparison with data in \code{\link{exresults}} in the QAQC or exploratory analysis workflow
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' 
#' exdqo <- read_excel('inst/extdata/ExampleDQO_final.xlsx')
#' 
#' save(exdqo, file = 'data/exdqo.RData', compress = 'xz')
#' }
"exdqo"