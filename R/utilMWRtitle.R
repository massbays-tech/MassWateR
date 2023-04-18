#' Format the title for analyze functions
#'
#' @param param character string of the parameter to plot
#' @param accdat optional \code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}
#' @param sumfun optional character indicating one of \code{"auto"}, \code{"mean"}, \code{"geomean"}, \code{"median"}, \code{"min"}, or \code{"max"}
#' @param site character string of sites to include
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD
#' @param resultatt character string of result attributes to plot
#' @param locgroup character string of location groups to plot from the \code{"Location Group"} column in the site metadata file
#'
#' @return A formatted character string used for the title in analysis plots
#' @export
#' 
#' @details All arguments are optional except \code{param}, appropriate text strings are appended to the \code{param} argument for all other optional arguments indicating the level of filtering used in the plot and data summary if appropriate
#' 
#' @examples
#' # no filters
#' utilMWRtitle(param = 'DO')
#' 
#' # filter by date only
#' utilMWRtitle(param = 'DO', dtrng = c('2021-05-01', '2021-07-31'))
#' 
#' # filter by all
#' utilMWRtitle(param = 'DO', site = 'test', dtrng = c('2021-05-01', '2021-07-31'), 
#'      resultatt = 'test', locgroup = 'test')
#'      
#' # title using summary 
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' accdat <- readMWRacc(accpth, runchk = FALSE)
#' utilMWRtitle(param = 'DO', accdat = accdat, sumfun = 'auto', site = 'test', 
#'      dtrng = c('2021-05-01', '2021-07-31'), resultatt = 'test', locgroup = 'test')
utilMWRtitle <- function(param, accdat = NULL, sumfun = NULL, site = NULL, dtrng = NULL, resultatt = NULL, locgroup = NULL){
  
  out <- param
  
  if(!is.null(sumfun)){
    sumfun <- utilMWRsumfun(accdat = accdat, param = param, sumfun = sumfun)
    sumfun <- ifelse(sumfun == 'geomean', 'geometric mean', sumfun)
    sumfun <- paste0('(', sumfun, ')')
    out <- paste(out, sumfun)
  }
  
  if(!is.null(site))
    site <- 'sites'
    
  if(!is.null(dtrng)){
    dtrng <- format(as.Date(dtrng), '%e %B, %Y')
    dtrng <- gsub('^\\s', '', dtrng)
    dtrng <- paste(dtrng, collapse = ' to ')
    dtrng <- paste0('dates (', dtrng, ')')
  }
  
  if(!is.null(resultatt))
    resultatt <- 'result attributes'
  
  if(!is.null(locgroup))
    locgroup <- 'location groups'

  addtxt <- paste(c(site, dtrng, resultatt, locgroup), collapse  = ', ')
  
  if(nchar(addtxt) > 0)
    out <- paste0(out, ', data filtered by ', addtxt)
  
  return(out)
  
}