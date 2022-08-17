#' Format the title for analyze functions
#'
#' @param param character string of the parameter to plot
#' @param site character string of sites to include
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD
#' @param resultatt character string of result attributes to plot
#' @param locgroup character string of location groups to plot from the \code{"Location Group"} column in the site metadata file
#'
#' @return A formatted character used for the title in analysis plots
#' @export
#' 
#' @details All arguments are optional except \code{param}, appropriate text strings are appended to the \code{param} argument for all other optional arguments indicating the level of filtering used in the plot
#' 
#' @examples
#' # no filters
#' utilMWRtitle(param = 'DO')
#' 
#' # filter by date only
#' utilMWRtitle(param = 'DO', dtrng = 'test')
#' 
#' # filter by all
#' utilMWRtitle(param = 'DO', site = 'test', dtrng = 'test', 
#'      resultatt = 'test', locgroup = 'test')
utilMWRtitle <- function(param, site = NULL, dtrng = NULL, resultatt = NULL, locgroup = NULL){
  
  out <- param
  
  if(!is.null(site))
    site <- 'sites'
    
  if(!is.null(dtrng))
    dtrng <- 'dates'
  
  if(!is.null(resultatt))
    resultatt <- 'result attributes'
  
  if(!is.null(locgroup))
    locgroup <- 'location groups'

  addtxt <- paste(c(site, dtrng, resultatt, locgroup), collapse  = ', ')
  
  if(nchar(addtxt) > 0)
    out <- paste0(out, ', data filtered by ', addtxt)

  return(out)
  
}