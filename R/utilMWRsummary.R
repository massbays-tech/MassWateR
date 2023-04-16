#' Summarize a results data frame by a grouping variable
#'
#' @param dat input data frame
#' @param accdat \code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}
#' @param param character string for the parameter to evaluate as provided in the \code{"Parameter"} column of \code{"accdat"}
#' @param sumfun character indicating one of \code{"auto"} (default), \code{"mean"}, \code{"geomean"}, \code{"median"}, \code{"min"}, or \code{"max"}, see details
#' @param confint logical if user expects a confidence interval to be returned with the summary
#'
#' @return A summarized data frame, a warning will be returned if the confidence interval cannot be estimated and \code{confint = TRUE}
#' 
#' @export
#'
#' @details This function summarizes a results data frame by an existing grouping variable using the function supplied to \code{sumfun}. The mean or geometric mean is used for \code{sumfun = "auto"} based on information in the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are summarized with the geometric mean, otherwise arithmetic. Using \code{"mean"} or \code{"geomean"} for \code{sumfun} will apply the appropriate function regardless of information in the data quality objective file for accuracy.
#' 
#' @examples
#' library(dplyr)
#' 
#' # results data path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # fill BDL, AQL
#' resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = "DO")
#'
#' dat <- resdat %>% 
#'   group_by(`Monitoring Location ID`)
#'  
#' # summarize sites by mean 
#' utilMWRsummary(dat, accdat, param = 'DO', sumfun = 'auto', confint = TRUE)
#' 
#' # summarize sites by minimum
#' utilMWRsummary(dat, accdat, param = 'DO', sumfun = 'min', confint = FALSE)
utilMWRsummary <- function(dat, accdat, param, sumfun = 'auto', confint){
  
  # get appropriate summary function
  sumfun <- utilMWRsumfun(accdat = accdat, param  =param, sumfun = sumfun)

  if(sumfun %in% c('mean', 'geomean')){
    
    if(sumfun == 'mean')
      out <- dat %>% 
        dplyr::summarize(
          lov = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[1], error = function(x) NA),
          hiv = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[2], error = function(x) NA),
          `Result Value` = mean(`Result Value`, na.rm = TRUE), 
          .groups = 'drop'
        )
    
    if(sumfun == 'geomean')
      out <- dat %>% 
        dplyr::summarize(
          lov = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[1], error = function(x) NA),
          hiv = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[2], error = function(x) NA),
          `Result Value` = 10^mean(log10(`Result Value`), na.rm = TRUE), 
          .groups = 'drop'
        )
    
    # check if ci available
    chk <- any(!is.na(out$lov))
    if(!chk & confint)
      warning('Cannot estimate confidence interval for given sample size', call. = FALSE)
    
  }
  
  if(!sumfun %in% c('mean', 'geomean')){
    
    out <- dat %>% 
      dplyr::summarize(
        `Result Value` = eval(parse(text = paste0(sumfun, '(`Result Value`, na.rm = TRUE)'))), 
        .groups = 'drop'
      ) %>% 
      dplyr::mutate(
        lov = NA, 
        hiv = NA
      )
    
    # warning if user expects ci with provided summary function
    if(confint){
      msg <- paste('Cannot estimate confidence interval for summary function', sumfun)
      warning(msg, call. = FALSE)
    }
    
  }
  
  return(out)
  
}