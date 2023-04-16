#' Analyze outliers in results file
#' 
#' Analyze outliers in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform to entries in the \code{"Simple Parameter"} column of \code{\link{paramsMWR}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param type character indicating \code{"box"}, \code{"jitterbox"}, or \code{"jitter"}, see details
#' @param group character indicating whether the summaries are grouped by month, site, or week of year
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, optional
#' @param repel logical indicating if overlapping outlier labels are offset
#' @param outliers logical indicating if outliers are returned to the console instead of plotting
#' @param labsize numeric indicating font size for the outlier labels
#' @param fill numeric indicating fill color for boxplots
#' @param alpha numeric from 0 to 1 indicating transparency of fill color
#' @param width numeric for width of boxplots
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param ttlsize numeric value indicating font size of the title relative to other text in the plot
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}} or \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified if \code{outliers = FALSE}, otherwise a data frame of outliers is returned.
#' 
#' @details Outliers are defined following the standard \code{\link[ggplot2]{ggplot}} definition as 1.5 times the inter-quartile range of each boxplot.  The data frame returned if \code{outliers = TRUE} may vary based on the boxplot groupings defined by \code{group}.
#' 
#' Specifying \code{type = "box"} (default) will produce standard boxplots.  Specifying \code{type = "jitterbox"} will produce boxplots with non-outlier observations jittered on top.  Specifying \code{type = "jitter"} will suppress the boxplots and show only the jittered points and the outliers. 
#' 
#' Specifying \code{group = "week"} will group the samples by week of year using an integer specifying the week.  Note that there can be no common month/day indicating the start of the week between years and an integer is the only way to compare summaries if the results data span multiple years.
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
#' # outliers by month
#' anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month')
#' 
#' # outliers by site
#' anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'site')
#' 
#' # outliers by site, May through July 2021 only
#' anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'site', 
#'      dtrng = c('2022-05-01', '2022-07-31'))
#' 
#' # outliers by month, type as jitterbox
#' anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month', type = 'jitterbox')
#' 
#' # outliers by month, type as jitter
#' anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month', type = 'jitter')
#' 
#' # data frame output
#' anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month', outliers = TRUE)
#' 
anlzMWRoutlier <- function(res = NULL, param, acc = NULL, fset = NULL, type = c('box', 'jitterbox', 'jitter'), group, dtrng = NULL, repel = TRUE, outliers = FALSE, labsize = 3, fill = 'lightgrey', alpha = 0.8, width = 0.8, yscl = 'auto', ttlsize = 1.2, runchk = TRUE, warn = TRUE){
  
  utilMWRinputcheck(mget(ls()))
  
  type <- match.arg(type)
  group <- match.arg(group, choices = c('month', 'site', 'week'))
  
  # inputs
  inp <- utilMWRinput(res = res, acc = acc, fset = fset, runchk = runchk, warn = warn)
  
  # results data
  resdat <- utilMWRfiltersurface(inp$resdat)

  # accuracy data
  accdat <- inp$accdat
  
  # filter
  resdat <- utilMWRfilter(resdat = resdat, param = param, dtrng = dtrng)
  
  # fill BDL, AQL
  resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = param, warn = warn)
  
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
      plot.title = ggplot2::element_text(size = ggplot2::rel(ttlsize))
    )

  toplo <- resdat

  ylab <- unique(toplo$`Result Unit`)
  ttl <- utilMWRtitle(param = param, dtrng = dtrng)
  
  # plot by month
  if(group == 'month'){
   
    toplo <- toplo %>% 
      dplyr::mutate(
        Month = factor(lubridate::month(`Activity Start Date`, label = TRUE, abbr = TRUE))
        ) %>% 
      dplyr::group_by(Month) %>% 
      dplyr::mutate(
        outlier = ifelse(utilMWRoutlier(`Result Value`, logscl = logscl), `Monitoring Location ID`, NA_character_)
      ) %>% 
      dplyr::ungroup()

    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = Month, y = `Result Value`))
    
  }
  
  # plot by site
  if(group == 'site'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Monitoring Location ID`) %>% 
      dplyr::mutate(
        outlier = ifelse(utilMWRoutlier(`Result Value`, logscl = logscl), as.character(`Activity Start Date`), NA_character_)
      ) %>% 
      dplyr::ungroup()
    
    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = `Monitoring Location ID`, y = `Result Value`)) 
    
  }

  # plot by week
  if(group == 'week'){
    
    toplo <- toplo %>% 
      dplyr::mutate(
        Week = factor(lubridate::week(`Activity Start Date`))
      ) %>% 
      dplyr::group_by(Week) %>% 
      dplyr::mutate(
        outlier = ifelse(utilMWRoutlier(`Result Value`, logscl = logscl), `Monitoring Location ID`, NA_character_)
      ) %>% 
      dplyr::ungroup()
    
    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = Week, y = `Result Value`))
    
  }
  
  # return outliers if TRUE
  if(outliers){

    out <- toplo %>% 
      dplyr::filter(!is.na(outlier)) %>% 
      dplyr::select(`Monitoring Location ID`, `Activity Start Date`, `Activity Start Time`, `Characteristic Name`, `Result Value`, `Result Unit`)

    return(out)      
    
  }
  
  if(type == 'box')
    p <- p + 
      ggplot2::geom_boxplot(outlier.color = 'tomato1', fill = fill, alpha = alpha, width = width)
  
  if(type == 'jitterbox')
    p <- p + 
      ggplot2::geom_boxplot(outlier.color = NA, fill = fill, alpha = alpha, width = width)
  
  if(type == 'jitter' | type == 'jitterbox'){
    
    outplo <- toplo %>% 
      dplyr::filter(is.na(outlier))
    jitplo <- toplo %>% 
      dplyr::filter(!is.na(outlier))
    
    p <- p + 
      ggplot2::geom_point(data = outplo, position = ggplot2::position_dodge2(width = 0.7 * width), alpha = 0.5, size = 1) +
      ggplot2::geom_point(data = jitplo, color = 'tomato1', position = ggplot2::position_dodge2(width = 0.7 * width))
    
  }
  
  if(repel)
    p <- p +
    ggrepel::geom_text_repel(ggplot2::aes(label = outlier), na.rm = T, point.size = NA, size = labsize, segment.color = 'grey')
  
  if(!repel)
    p <- p + 
    ggplot2::geom_text(ggplot2::aes(label = outlier), na.rm = T, size = labsize)
  
  if(logscl)
    p <- p + ggplot2::scale_y_log10()
  
  p <- p +  
    thm +
    ggplot2::labs(
      y = ylab, 
      title = ttl, 
      x = NULL
    )
  
  return(p)
  
}
