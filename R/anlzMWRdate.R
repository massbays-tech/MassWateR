#' Analyze trends by date in results file
#' 
#' Analyze trends by date in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform to entries in the \code{"Simple Parameter"} column of \code{\link{paramsMWR}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param group character indicating whether the results are grouped by site (default) or combined across all sites
#' @param thresh character indicating if relevant freshwater or marine threshold lines are included, one of \code{"fresh"}, \code{"marine"}, or \code{"none"}
#' @param threshcol character indicating color of threshold lines if available
#' @param site character string of sites to include, default all
#' @param resultatt character string of result attributes to plot, default all
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, optional
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRfrecom}}, applies only if \code{res}, \code{acc}, or \code{frecom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified.
#' 
#' @details Results are shown for the selected parameter as continuous line plots over time. Specifying \code{group = "site"} plot a separate line for each site.  Specifying \code{group = "all"} will average results across sites for each date.
#'
#' Threshold lines applicable to marine or freshwater environments can be included in the plot by using the \code{thresh} argument.  These thresholds are specific to each parameter and can be found in the \code{\link{thresholdMWR}} file.  Threshold lines are plotted only for those parameters with entries in \code{\link{thresholdMWR}} and only if the value in \code{`Result Unit`} matches those in \code{\link{thresholdMWR}}. The threshold lines can be suppressed by setting \code{thresh = 'none'}. 
#'  
#' The y-axis scaling as arithmetic (linear) or logarithmic can be set with the \code{yscl} argument.  If \code{yscl = "auto"} (default), the scaling is  determined automatically from the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are plotted on log10-scale, otherwise arithmetic. Setting \code{yscl = "linear"} or \code{yscl = "log"} will set the axis as linear or log10-scale, respectively, regardless of the information in the data quality objective file for accuracy. 
#' 
#' Any entries in \code{resdat} in the \code{"Result Value"} column as \code{"BDL"} or \code{"AQL"} are replaced with appropriate values in the \code{"Quantitation Limit"} column, if present, otherwise the \code{"MDL"} or \code{"UQL"} columns from the data quality objectives file for accuracy are used.  Values as \code{"BDL"} use one half of the appropriate limit.
#' 
#' @export
#'
#' @examples
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
#' # all sites
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'site')
#' 
#' # combined sites
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'all')
#' 
#' # all sites, May to July only
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'site', 
#'      dtrng = c('2021-05-01', '2021-07-31'))
#' 
anlzMWRdate <- function(res, param, acc, group = c('site', 'all'), thresh = c('fresh', 'marine', 'none'), threshcol = 'tan', site = NULL, resultatt = NULL, dtrng = NULL, yscl = c('auto', 'log', 'linear'), runchk = TRUE, warn = TRUE){
  
  group <- match.arg(group)

  # inputs
  inp <- utilMWRinput(res = res, acc = acc, runchk = runchk, warn = warn)
  
  # results data
  resdat <- inp$resdat 
  
  # accuracy data
  accdat <- inp$accdat
  
  # fill BDL, AQL
  resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = param, site = site, resultatt = resultatt, warn = warn)
  
  # filter if needed
  resdat <- utilMWRdaterange(resdat = resdat, dtrng = dtrng)
  
  # get thresholds
  threshln <- utilMWRthresh(resdat = resdat, param = param, thresh = thresh, warn = warn)
  
  # get y axis scaling
  logscl <- utilMWRyscale(accdat = accdat, param = param, yscl = yscl)

  ##
  # plot prep
  
  thm <- ggplot2::theme_minimal() + 
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(), 
      panel.grid.minor.x = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank(), 
      axis.text.x = ggplot2::element_text(angle = 45, size = 8, hjust = 1), 
      legend.position = 'top'
    )
  
  toplo <- resdat %>% 
    dplyr::mutate(
      `Activity Start Date` = lubridate::ymd(`Activity Start Date`)
    )
  
  ylab <- unique(toplo$`Result Unit`)
  
  # by site
  if(group == 'site'){

    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`)) +
      ggplot2::geom_line() + 
      ggplot2::geom_point()
    
  }
  
  # combine all sites
  if(group == 'all'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Activity Start Date`) 
    
    if(!logscl)
      toplo <- toplo %>% 
        dplyr::summarize(
          lov = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[1], error = function(x) NA),
          hiv = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[2], error = function(x) NA),
          `Result Value` = mean(`Result Value`, na.rm = TRUE), 
          .groups = 'drop'
        )
    
    if(logscl)
      toplo <- toplo %>% 
        dplyr::summarize(
          lov = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[1], error = function(x) NA),
          hiv = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[2], error = function(x) NA),
          `Result Value` = 10^mean(log10(`Result Value`), na.rm = TRUE), 
          .groups = 'drop'
        )
    
    p <-  ggplot2::ggplot(toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`)) +
      ggplot2::geom_line() + 
      ggplot2::geom_point() + 
      ggplot2::geom_errorbar(ggplot2::aes(ymin = lov, ymax = hiv), width = 1)
    
  }
  
  # add threshold lines
  if(!is.null(threshln)){
    
    threshln <- na.omit(threshln)
    
    p <- p + 
      ggplot2::geom_hline(data = threshln, ggplot2::aes(yintercept  = thresh, color = label, size = label)) + 
      ggplot2::scale_color_manual(values = rep(threshcol, nrow(threshln))) +
      ggplot2::scale_size_manual(values = threshln$size)
    
  }
  
  if(logscl)
    p <- p + ggplot2::scale_y_log10()
  
  p <- p +  
    thm +
    ggplot2::labs(
      y = ylab, 
      title = param, 
      color = NULL,
      size = NULL, 
      alpha = NULL,
      x = NULL
    )
  
  return(p)
  
}
