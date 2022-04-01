#' Example file of site locations
#' 
#' Example file of site locations
#' 
#' @format A \code{data.frame} of 58 rows and 5 columns
#' 
#' @details An example of site locations formatted for comparison with data in \code{\link{exresults}} in the QAQC or exploratory analysis workflow
#' 
#' @examples 
#' \dontrun{
#' library(readxl)
#' 
#' exsites <- read_excel('inst/extdata/ExampleSites_final.xlsx')
#' 
#' save(exsites, file = 'data/exsites.RData', compress = 'xz')
#' }
"exsites"