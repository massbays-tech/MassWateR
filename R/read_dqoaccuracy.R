#' Read data quality objectives for accuracy from an external file
#'
#' @param pth character string of path to the file
#' @param runchk logical to run data checks with \code{\link{check_dqoaccuracy}}
#'
#' @return A formatted data frame of data quality objectives for completeness that can be used for downstream analysis
#' 
#' @details Data are imported with \code{\link[readxl]{read_excel}} and checked with \code{\link{check_dqoaccuracy}}.
#' 
#' @export
#'
#' @examples
#' pth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' dqoaccuracy <- read_dqoaccuracy(pth)
#' head(dqoaccuracy)
read_dqoaccuracy <- function(pth, runchk = TRUE){
  
  dat <- readxl::read_excel(pth, na = c('na', ''))
  
  # run checks
  if(runchk)
    dat <- check_dqoaccuracy(dat)
  
  out <- dat
  
  return(out)
  
}