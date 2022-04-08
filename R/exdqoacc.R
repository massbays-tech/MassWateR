#' Example file of data quality objectives for accuracy
#' 
#' Example file of data quality objectives for accuracy
#' 
#' @format A \code{data.frame} of 21 rows and 10 columns
#' 
#' @details An example of data quality objectives for accuracy formatted for comparison with data in \code{\link{exresults}} in the QAQC or exploratory analysis workflow
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' 
#' exdqoacc <- read_excel('inst/extdata/ExampleDQOAccuracy_final.xlsx', sheet = 'Accuracy')
#' 
#' save(exdqoacc, file = 'data/exdqoacc.RData', compress = 'xz')
#' }
"exdqoacc"