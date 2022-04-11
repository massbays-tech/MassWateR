#' Read data quality objectives for completeness from an external file
#'
#' @param pth character string of path to the file
#' @param runchk logical to run data checks with \code{\link{check_dqocompleteness}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_dqocompleteness}}.
#' 
#' @export
#'
#' @examples
#' pth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
#' 
#' dqocomplete <- read_dqocompleteness(pth)
#' head(dqocomplete)
read_dqocompleteness <- function(pth, runchk = TRUE){
  
  dat <- suppressMessages(readxl::read_excel(pth, 
      skip = 1, na = c('na', ''), 
      col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
    )) %>% 
    rename(`% Completeness` = `...7`)
  
  # run checks
  if(runchk)
    dat <- check_dqocompleteness(dat)
  
  out <- dat
  
  return(out)
  
}