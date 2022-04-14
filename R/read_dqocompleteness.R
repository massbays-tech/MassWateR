#' Read data quality objectives for completeness from an external file
#'
#' @param dqocompth character string of path to the data quality objectives file for completeness
#' @param runchk logical to run data checks with \code{\link{check_dqocompleteness}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_dqocompleteness}}.
#' 
#' @export
#'
#' @examples
#' dqocompth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
#' 
#' dqocomdat <- read_dqocompleteness(dqocompth)
#' head(dqocomdat)
read_dqocompleteness <- function(dqocompth, runchk = TRUE){
  
  dqocomdat <- suppressMessages(readxl::read_excel(dqocompth, 
      skip = 1, na = c('na', ''), 
      col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
    )) %>% 
    rename(`% Completeness` = `...7`)
  
  # run checks
  if(runchk)
    dqocomdat <- check_dqocompleteness(dqocomdat)
  
  out <- dqocomdat
  
  return(out)
  
}