#' Summarize a results data frame for means and confidence intervals
#'
#' @param dat input data frame
#' @param logscl logical indicating if summaries are log10-scale or not
#'
#' @return A summarized data frame
#' @export
#'
#' @details This function is used internally for the analysis functions
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
#' #' # accuracy path
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
#' utilMWRconfint(dat, logscl = FALSE)
#' utilMWRconfint(dat, logscl = TRUE)
utilMWRconfint <- function(dat, logscl){
  
  if(!logscl)
    out <- dat %>% 
      dplyr::summarize(
        lov = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[1], error = function(x) NA),
        hiv = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[2], error = function(x) NA),
        `Result Value` = mean(`Result Value`, na.rm = TRUE), 
        .groups = 'drop'
      )
  
  if(logscl)
    out <- dat %>% 
      dplyr::summarize(
        lov = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[1], error = function(x) NA),
        hiv = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[2], error = function(x) NA),
        `Result Value` = 10^mean(log10(`Result Value`), na.rm = TRUE), 
        .groups = 'drop'
      )
  
  return(out)
  
}