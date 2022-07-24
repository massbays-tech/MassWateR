#' Analyze trends by date in results file
#' 
#' Analyze trends by date in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform to entries in the \code{"Simple Parameter"} column of \code{\link{paramsMWR}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param sit optional character string of path to the site metadata file or \code{data.frame} of site metadata returned by \code{\link{readMWRsites}}, required if \code{locgroup} is not \code{NULL} 
#' @param thresh character indicating if relevant freshwater or marine threshold lines are included, one of \code{"fresh"}, \code{"marine"}, or \code{"none"}
#' @param group character indicating whether the results are grouped by site (default), combined across location groups, or combined across sites, see details
#' @param threshcol character indicating color of threshold lines if available
#' @param site character string of sites to include, default all
#' @param resultatt character string of result attributes to plot, default all
#' @param locgroup character string of location groups to plot from the \code{"Location Group"} column in the site metadata file, optional and only if \code{sit} is not \code{NULL}
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, default all
#' @param ptsize numeric indicating size of the points
#' @param repel logical indicating if overlapping site labels are offset
#' @param labsize numeric indicating font size for the site labels, only if \code{group = "site"}
#' @param confint logical indicating if confidence intervals are shown, only applies if \code{type = "bar"}
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}} or \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified.
#' 
#' @details Results are shown for the selected parameter as continuous line plots over time. Specifying \code{group = "site"} plot a separate line for each site.  Specifying \code{group = "location"} will average results across sites in the `locgroup` argument.  The site metadata file must be passed to the \code{`sit`} argument to use this option.  Specifying \code{group = "all"} will average results across sites for each date.
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
#' # site data path
#' sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')
#' 
#' # site data
#' sitdat <- readMWRsites(sitpth)
#' 
#' # select sites
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'site', thresh = 'fresh',
#'      site = c("ABT-026", "ABT-077"))
#' 
#' # combined sites
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'all', thresh = 'fresh',
#'      site = c("ABT-026", "ABT-077"))
#' 
#' # sites by location group, requires sitdat
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, sit = sitdat, group = 'site', 
#'      thresh = 'fresh', locgroup = 'Concord')
#'      
#' # sites by location group averaged by group, requires sitdat
#' anlzMWRdate(res = resdat, param = 'DO', acc = accdat, sit = sitdat, group = 'location', 
#'      thresh = 'fresh', locgroup = c('Lower Assabet', 'Upper Assabet'))
anlzMWRdate <- function(res, param, acc, sit = NULL, thresh, group = c('site', 'location', 'all'), threshcol = 'tan', site = NULL, resultatt = NULL, locgroup = NULL, dtrng = NULL, ptsize = 2, repel = TRUE, labsize = 3, confint = FALSE, yscl = c('auto', 'log', 'linear'), runchk = TRUE, warn = TRUE){
  
  group <- match.arg(group)

  # inputs
  inp <- utilMWRinput(res = res, acc = acc, sit = sit, runchk = runchk, warn = warn)
  
  # results data
  resdat <- inp$resdat 
  
  # accuracy data
  accdat <- inp$accdat
  
  sitdat <- inp$sitdat
  
  # filter
  resdat <- utilMWRfilter(resdat = resdat, sitdat = sitdat, param = param, dtrng = dtrng, site = site, resultatt = resultatt, locgroup = locgroup)
  
  # fill BDL, AQL
  resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = param, warn = warn)
  
  # get thresholds
  threshln <- utilMWRthresh(resdat = resdat, param = param, thresh = thresh)
  
  # get y axis scaling
  logscl <- utilMWRyscale(accdat = accdat, param = param, yscl = yscl)

  ##
  # plot prep
  
  thm <- ggplot2::theme_minimal() + 
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(), 
      panel.grid.minor.x = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank(), 
      axis.text.x = ggplot2::element_text(angle = 45, size = 10, hjust = 1), 
      legend.position = 'top'
    )
  
  toplo <- resdat %>% 
    dplyr::mutate(
      `Activity Start Date` = lubridate::ymd(`Activity Start Date`)
    )
  
  ylab <- unique(toplo$`Result Unit`)
  
  p <- ggplot2::ggplot()
  
  # add threshold lines
  if(!is.null(threshln)){
    
    threshln <- na.omit(threshln)
    
    p <- p + 
      ggplot2::geom_hline(data = threshln, ggplot2::aes(yintercept  = thresh, color = label, size = label)) + 
      ggplot2::scale_color_manual(values = rep(threshcol, nrow(threshln))) +
      ggplot2::scale_size_manual(values = threshln$size)
    
  }
  
  # by site
  if(group == 'site'){

    # site labels
    sitelb <- toplo %>% 
      dplyr::group_by(`Monitoring Location ID`) %>% 
      dplyr::filter(`Activity Start Date` == max(`Activity Start Date`)) %>% 
      dplyr::select(`Monitoring Location ID`, `Activity Start Date`, `Result Value`)
    
    p <- p +
      ggplot2::geom_line(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`)) + 
      ggplot2::geom_point(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`), size = ptsize)
    
    if(repel)
      p <- p +
        ggrepel::geom_text_repel(data = sitelb, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`, label = `Monitoring Location ID`), 
                                 na.rm = T, size = labsize, hjust = 0, nudge_x = 5, segment.color = 'grey')
    
    if(!repel)
      p <- p + 
        ggplot2::geom_text(data = sitelb, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`, label = `Monitoring Location ID`), 
                           na.rm = T, size = labsize, hjust = 0, nudge_x = 3)
      
  }
  
  if(group == 'location'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Activity Start Date`, `Location Group`) 

    # get mean and CI summary
    toplo <- utilMWRconfint(toplo, logscl = logscl)
    
    # group labels
    grplb <- toplo %>% 
      dplyr::group_by(`Location Group`) %>% 
      dplyr::filter(`Activity Start Date` == max(`Activity Start Date`)) %>% 
      dplyr::select(`Location Group`, `Activity Start Date`, `Result Value`)
    
    p <- p +
      ggplot2::geom_line(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`)) + 
      ggplot2::geom_point(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`), size = ptsize)
    
    if(repel)
      p <- p +
      ggrepel::geom_text_repel(data = grplb, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`, label = `Location Group`), 
                               na.rm = T, size = labsize, hjust = 0, nudge_x = 5, segment.color = 'grey')
    
    if(!repel)
      p <- p + 
      ggplot2::geom_text(data = grplb, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`, label = `Location Group`), 
                         na.rm = T, size = labsize, hjust = 0, nudge_x = 3)
    
    if(confint)
      p <- p + 
       ggplot2::geom_errorbar(data = toplo, ggplot2::aes(x = `Activity Start Date`, ymin = lov, ymax = hiv, group = `Location Group`), width = 1)
    
  }
  
  # combine all sites
  if(group == 'all'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Activity Start Date`) 
    
    # get mean and CI summary
    toplo <- utilMWRconfint(toplo, logscl = logscl)
    
    p <- p +
      ggplot2::geom_line(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`)) + 
      ggplot2::geom_point(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`), size = ptsize)
    
    if(confint)
      p <- p + 
        ggplot2::geom_errorbar(data = toplo, ggplot2::aes(x = `Activity Start Date`, ymin = lov, ymax = hiv), width = 1)
    
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
