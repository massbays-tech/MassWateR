#' Analyze site trends in results file
#' 
#' Analyze site trends in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform to entries in the \code{"Simple Parameter"} column of \code{\link{paramsMWR}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param type character indicating \code{"box"} for boxplots or \code{"bar"} for barplots, see details
#' @param thresh character indicating if relevant freshwater or marine threshold lines are included, one of \code{"fresh"}, \code{"marine"}, or \code{"none"}
#' @param threshcol character indicating color of threshold lines if available
#' @param site character string of sites to include, default all
#' @param resultatt character string of result attributes to plot, default all
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, optional
#' @param jitter logical indicating if points are jittered over the boxplots, only applies if \code{type = "boxplot"}
#' @param fill numeric indicating fill color for boxplots or barplots
#' @param alpha numeric from 0 to 1 indicating transparency of fill color
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRfrecom}}, applies only if \code{res}, \code{acc}, or \code{frecom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified.
#' 
#' @details Summaries of a parameter for each site are shown as boxplots if \code{type = "box"} or as barplots if \code{type = "bar"}.  For the latter, points can be jittered over the boxplots by setting \code{jitter = TRUE}.  For the former, 95% confidence intervals are also shown. 
#'
#' Threshold lines applicable to marine or freshwater environments can be included in the plot by using the \code{thresh} argument.  These thresholds are specific to each parameter and can be found in the \code{\link{thresholdMWR}} file.  Threshold lines are plotted only for those parameters with entries in \code{\link{thresholdMWR}} and only if the value in \code{`Result Unit`} matches those in \code{\link{thresholdMWR}}. The threshold lines can be suppressed by setting \code{thresh = 'none'}. 
#'  
#' The y-axis scaling as arithmetic (linear) or logarithmic can be set with the \code{yscl} argument.  If \code{yscl = "auto"} (default), the scaling is  determined automatically from the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are plotted on log10-scale, otherwise arithmetic. Setting \code{yscl = "linear"} or \code{yscl = "log"} will set the axis as linear or log10-scale, respectively, regardless of the information in the data quality objective file for accuracy. The means and confidence intervals will vary between arithmetic and log-scaling if \code{type = "bar"}.
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
#' # site trends, boxplot
#' anlzMWRsite(res = resdat, param = 'DO', acc = accdat, type = 'box')
#' 
#' # site trends, barplot
#' anlzMWRsite(res = resdat, param = 'DO', acc = accdat, type = 'bar')
#' 
#' # site trends, May to July only
#' anlzMWRsite(res = resdat, param = 'DO', acc = accdat, type = 'box',
#'      dtrng = c('2021-05-01', '2021-07-31'))
anlzMWRsite <- function(res, param, acc, type = c('box', 'bar'), thresh = c('fresh', 'marine', 'none'), threshcol = 'tan', site = NULL, resultatt = NULL, dtrng = NULL, jitter = FALSE, fill = 'lightgreen', alpha = 0.8, yscl = c('auto', 'log', 'linear'), runchk = TRUE, warn = TRUE){
  
  type <- match.arg(type)
  
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
  
  toplo <- resdat
  
  ylab <- unique(toplo$`Result Unit`)
  

  # boxplot
  if(type == 'box'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Monitoring Location ID`) %>% 
      dplyr::mutate(
        outlier = utilMWRoutlier(`Result Value`, logscl = logscl)
      ) %>% 
      dplyr::ungroup()
    
    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = `Monitoring Location ID`, y = `Result Value`)) +
      ggplot2::geom_boxplot(outlier.size = 1, fill = fill, alpha = alpha)
    
  }
  
  # barplot
  if(type == 'bar'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Monitoring Location ID`)
    
    if(!logscl)
      toplo <- toplo %>% 
        dplyr::summarize(
          meanval = mean(`Result Value`, na.rm = T), 
          lov = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[1], error = function(x) NA),
          hiv = tryCatch(t.test(`Result Value`, na.rm = T)$conf.int[2], error = function(x) NA), 
          .groups = 'drop'
        ) 
    
    if(logscl)
      toplo <- toplo %>% 
        dplyr::summarize(
          meanval = 10^mean(log10(`Result Value`), na.rm = T), 
          lov = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[1], error = function(x) NA),
          hiv = tryCatch(10^t.test(log10(`Result Value`), na.rm = T)$conf.int[2], error = function(x) NA), 
          .groups = 'drop'
        ) 
    
    p <-  ggplot2::ggplot(toplo, ggplot2::aes(x = `Monitoring Location ID`, y = meanval)) +
      ggplot2::geom_bar(fill = fill, stat = 'identity', alpha = alpha) + 
      ggplot2::geom_errorbar(ggplot2::aes(ymin = lov, ymax = hiv), width = 0.2)
    
  }
  
  # jitter if box
  if(jitter & type == 'box'){
    
    jitplo <- toplo %>% 
      dplyr::filter(!outlier)
    
    p <- p + 
      ggplot2::geom_point(data = jitplo, position = ggplot2::position_dodge2(width = 0.7), alpha = 0.5, size = 1)
    
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
