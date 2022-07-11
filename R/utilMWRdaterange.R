#' Filter results data by date range
#'
#' @param resdat results data as returned by \code{\link{readMWRresults}}
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD
#'
#' @return \code{resdat} filtered by \code{dtrng}, otherwise \code{resdat} unfiltered if \code{dtrng = NULL}
#' @export
#'
#' @examples
#' # results file path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # filtered results
#' utilMWRdaterange(resdat, dtrng = c('2021-06-01', '2021-06-30'))
utilMWRdaterange <- function(resdat, dtrng = NULL){
  
  out <- resdat
  
  # check date format if provided
  if(!is.null(dtrng)){
    
    if(length(dtrng) != 2)
      stop('Must supply two dates for dtrng')
    
    dtflt <- suppressWarnings(lubridate::ymd(dtrng))
    
    if(anyNA(dtflt)){
      chk <- dtrng[is.na(dtflt)]
      stop('Dates not entered as YYYY-mm-dd: ', paste(chk, collapse = ', '))
    } 
    
    dtflt <- sort(dtflt)
    
    out <- out %>% 
      dplyr::filter(`Activity Start Date` >= dtflt[1] & `Activity Start Date` <= dtflt[2])
  
    if(nrow(out) == 0)
      stop('No data available for date range')
  }
  
  return(out)
  
}