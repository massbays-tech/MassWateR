#' Example file of data quality objectives for completeness
#' 
#' Example file of data quality objectives for completeness
#' 
#' @format A \code{data.frame} of 21 rows and 10 columns
#' 
#' @details An example of data quality objectives for completeness formatted for comparison with data in \code{\link{exresults}} in the QAQC or exploratory analysis workflow
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' library(dplyr)
#' 
#' exdqocom <- read_excel('inst/extdata/ExampleDQO_final.xlsx', sheet = 'Completeness', skip = 1) %>% 
#'   rename(`% Completeness` = `...7`)
#' 
#' save(exdqocom, file = 'data/exdqocom.RData', compress = 'xz')
#' }
"exdqocom"