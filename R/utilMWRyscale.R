#' Get logical value for y axis scaling
#'
#' @param accdat \code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}
#' @param param character string to first filter results by a parameter in \code{"Characteristic Name"}
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#'
#' @return A logical value indicating \code{TRUE} for log10-scale, \code{FALSE} for arithmetic (linear)
#' @export
#'
#' @examples
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # log auto
#' utilMWRyscale(accdat, param = 'E.coli')
#' 
#' # linear force
#' utilMWRyscale(accdat, param = 'E.coli', yscl = 'linear')
#' 
#' # linear auto
#' utilMWRyscale(accdat, param = 'DO')
#' 
#' # log force
#' utilMWRyscale(accdat, param = 'DO', yscl = 'log')
utilMWRyscale <- function(accdat, param, yscl = c('auto', 'log', 'linear')){
  
  yscl <- match.arg(yscl)
  
  # get scaling from accuracy data
  logscl <- accdat %>% 
    dplyr::filter(Parameter %in% param) %>% 
    unlist %>% 
    grepl('log', .) %>% 
    any

  # final log scale logical
  out <- ifelse(yscl == 'linear', FALSE, 
      ifelse(yscl == 'log', TRUE,
        ifelse(yscl == 'auto', logscl, 
          NA_integer_
        )
      )
    )
  
  return(out)
  
}