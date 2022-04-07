#' Read water quality monitoring results from an external file
#'
#' @param pth character string of path to the file
#' @param runchk logical to run data checks with \code{\link{check_results}}
#'
#' @return A formatted water quality monitoring results data frame that can be used for downstream analysis
#' 
#' @export
#'
#' @examples
#' pth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' results <- read_results(pth)
#' head(results)
read_results <- function(pth, runchk = TRUE){
  
  dat <- readxl::read_excel(pth, 
    col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
                  'text', 'text', 'text', 'text'))
  
  # run checks
  if(runchk)
    dat <- check_results(dat)
  
  out <- dat
  
  return(out)
  
}