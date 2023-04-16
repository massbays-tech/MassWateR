#' Analyze trends by date in results file
#' 
#' Analyze trends by date in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform to entries in the \code{"Simple Parameter"} column of \code{\link{paramsMWR}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param sit optional character string of path to the site metadata file or \code{data.frame} of site metadata returned by \code{\link{readMWRsites}}, required if \code{locgroup} is not \code{NULL} 
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param thresh character indicating if relevant freshwater or marine threshold lines are included, one of \code{"fresh"}, \code{"marine"}, or \code{"none"}, or a single numeric value to override the values included with the package
#' @param group character indicating whether the results are grouped by site (default), combined across location groups, or combined across sites, see details
#' @param threshlab optional character string indicating legend label for the threshold, required only if \code{thresh} is numeric
#' @param threshcol character indicating color of threshold lines if available
#' @param site character string of sites to include, default all
#' @param resultatt character string of result attributes to plot, default all
#' @param locgroup character string of location groups to plot from the \code{"Location Group"} column in the site metadata file, optional and only if \code{sit} is not \code{NULL}
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, default all
#' @param ptsize numeric indicating size of the points
#' @param repel logical indicating if overlapping site labels are offset, default \code{FALSE}
#' @param labsize numeric indicating font size for the site labels, only if \code{group = "site"} or \code{group = "locgroup"}
#' @param expand numeric of length two indicating expansion proportions on the x-axis to include labels outside of the plot range if \code{repel = F} and \code{group = "site"} or \code{group = "locgroup"}
#' @param confint logical indicating if confidence intervals are shown, only applies if \code{type = "bar"}
#' @param palcol character string indicating the color palette for points and lines from \href{https://r-graph-gallery.com/38-rcolorbrewers-palettes.html}{RColorBrewer}, see details
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}} or \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param colleg logical indicating if a color legend for sites or location groups is included if \code{group = "site"} or \code{group = "locgroup"}
#' @param ttlsize numeric value indicating font size of the title relative to other text in the plot
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified.
#' 
#' @details Results are shown for the selected parameter as continuous line plots over time. Specifying \code{group = "site"} plot a separate line for each site.  Specifying \code{group = "locgroup"} will average results across sites in the `locgroup` argument.  The site metadata file must be passed to the \code{`sit`} argument to use this option.  Specifying \code{group = "all"} will average results across sites for each date.
#'
#' Threshold lines applicable to marine or freshwater environments can be included in the plot by using the \code{thresh} argument.  These thresholds are specific to each parameter and can be found in the \code{\link{thresholdMWR}} file.  Threshold lines are plotted only for those parameters with entries in \code{\link{thresholdMWR}} and only if the value in \code{`Result Unit`} matches those in \code{\link{thresholdMWR}}. The threshold lines can be suppressed by setting \code{thresh = 'none'}. A user-supplied numeric value can also be used for the \code{thresh} argument to override the default values. An appropriate label must also be supplied to \code{threshlab} if \code{thresh} is numeric.
#'  
#' Any acceptable color palette for from \href{https://r-graph-gallery.com/38-rcolorbrewers-palettes.html}{RColorBrewer} for the points and lines can be used for \code{palcol}, which is passed to the \code{palette} argument in \code{\link[ggplot2]{scale_color_brewer}}. These could include any of the qualitative color palettes, e.g., \code{"Set1"}, \code{"Set2"}, etc.  The continuous and diverging palettes will also work, but may return color scales for points and lines that are difficult to distinguish.  The \code{palcol} argument does not apply if \code{group = "all"}. 
#' 
#' The y-axis scaling as arithmetic (linear) or logarithmic can be set with the \code{yscl} argument.  If \code{yscl = "auto"} (default), the scaling is  determined automatically from the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are plotted on log10-scale, otherwise arithmetic. Setting \code{yscl = "linear"} or \code{yscl = "log"} will set the axis as linear or log10-scale, respectively, regardless of the information in the data quality objective file for accuracy. 
#' 
#' Any entries in \code{resdat} in the \code{"Result Value"} column as \code{"BDL"} or \code{"AQL"} are replaced with appropriate values in the \code{"Quantitation Limit"} column, if present, otherwise the \code{"MDL"} or \code{"UQL"} columns from the data quality objectives file for accuracy are used.  Values as \code{"BDL"} use one half of the appropriate limit.
#' 
#' @export
#' @import RColorBrewer
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
anlzMWRdate <- function(res = NULL, param, acc = NULL, sit = NULL, fset = NULL, thresh, group = c('site', 'locgroup', 'all'), threshlab = NULL, threshcol = 'tan', site = NULL, resultatt = NULL, locgroup = NULL, dtrng = NULL, ptsize = 2, repel = FALSE, labsize = 3, expand = c(0.05, 0.1), confint = FALSE, palcol = 'Set2', yscl = 'auto', colleg = FALSE, ttlsize = 1.2, runchk = TRUE, warn = TRUE){
  
  # remove site from input list check because optional
  chkin <- mget(ls())
  chkin <- chkin[!names(chkin) %in% 'sit']
  utilMWRinputcheck(chkin)
  
  group <- match.arg(group)

  # inputs
  inp <- utilMWRinput(res = res, acc = acc, sit = sit, fset = fset, runchk = runchk, warn = warn)
  
  # results data
  resdat <- utilMWRfiltersurface(inp$resdat)
  
  # accuracy data
  accdat <- inp$accdat
  
  sitdat <- inp$sitdat
  
  # use all location groups if group is locgroup and locgroup is NULL
  alllocgroup <- FALSE
  if(group == 'locgroup' & is.null(locgroup))
     alllocgroup <- TRUE
  
  # filter
  resdat <- utilMWRfilter(resdat = resdat, sitdat = sitdat, param = param, dtrng = dtrng, site = site, resultatt = resultatt, locgroup = locgroup, alllocgroup = alllocgroup)
  
  # fill BDL, AQL
  resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = param, warn = warn)
  
  # get thresholds
  threshln <- utilMWRthresh(resdat = resdat, param = param, thresh = thresh, threshlab = threshlab)
  
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
      legend.position = 'top',
      legend.key.width = ggplot2::unit(1.05, "cm"), 
      legend.spacing.y = ggplot2::unit(0, 'cm'),
      legend.box = "vertical", 
      plot.title = ggplot2::element_text(size = ggplot2::rel(ttlsize))
    )
  
  toplo <- resdat %>% 
    dplyr::mutate(
      `Activity Start Date` = lubridate::ymd(`Activity Start Date`)
    )
  
  ylab <- unique(toplo$`Result Unit`)
  ttl <- utilMWRtitle(param = param, site = site, dtrng = dtrng, locgroup = locgroup, resultatt = resultatt)
  
  p <- ggplot2::ggplot()
  
  # add threshold lines
  if(!is.null(threshln)){
    
    threshln <- na.omit(threshln)

    p <- p + 
      ggplot2::geom_hline(data = threshln, ggplot2::aes(yintercept  = thresh, linetype = label, size = label), color = threshcol) + 
      ggplot2::scale_linetype_manual(values = threshln$linetype) + 
      ggplot2::scale_size_manual(values = threshln$size)
    
  }
  
  # by site
  if(group == 'site'){

    # site labels
    sitelb <- toplo %>% 
      dplyr::group_by(`Monitoring Location ID`) %>% 
      dplyr::filter(`Activity Start Date` == max(`Activity Start Date`)) %>% 
      dplyr::select(`Monitoring Location ID`, `Activity Start Date`, `Result Value`)

    ncol <- nrow(sitelb)
    
    p <- p +
      ggplot2::geom_line(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`, color = `Monitoring Location ID`), show.legend = FALSE) + 
      ggplot2::geom_point(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`, color = `Monitoring Location ID`), size = ptsize, show.legend = colleg)
    
    if(repel)
      p <- p +
        ggrepel::geom_text_repel(data = sitelb, 
          ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`, label = `Monitoring Location ID`, color = `Monitoring Location ID`), 
          na.rm = T, size = labsize, hjust = 0, nudge_x = 5, segment.color = 'grey', show.legend = FALSE)
    
    if(!repel)
      p <- p + 
        ggplot2::geom_text(data = sitelb, 
          ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Monitoring Location ID`, label = `Monitoring Location ID`, color = `Monitoring Location ID`), 
          na.rm = T, size = labsize, hjust = 0, nudge_x = 3, show.legend = FALSE) + 
        ggplot2::scale_x_date(expand = ggplot2::expansion(mult = expand))
      
    # add color palette
    maxcol <- brewer.pal.info[palcol, 'maxcolors']
    if(is.na(maxcol))
      maxcol <- 3
    if(maxcol >= ncol)
      maxcol <- pmax(3, ncol)
    cols <- grDevices::colorRampPalette(brewer.pal(n = maxcol, name = palcol))(ncol)
    p <- p + 
      ggplot2::scale_color_manual(values = cols)
    
  }
  
  if(group == 'locgroup'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Activity Start Date`, `Location Group`) 

    # get mean and CI summary
    toplo <- utilMWRconfint(toplo, logscl = logscl)
    
    # group labels
    grplb <- toplo %>% 
      dplyr::group_by(`Location Group`) %>% 
      dplyr::filter(`Activity Start Date` == max(`Activity Start Date`)) %>% 
      dplyr::select(`Location Group`, `Activity Start Date`, `Result Value`)

    ncol <- nrow(grplb)
    
    p <- p +
      ggplot2::geom_line(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`, color = `Location Group`), show.legend = FALSE) + 
      ggplot2::geom_point(data = toplo, ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`, color = `Location Group`), size = ptsize, show.legend = colleg)
    
    if(repel)
      p <- p +
      ggrepel::geom_text_repel(data = grplb, 
        ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`, label = `Location Group`, color = `Location Group`), 
        na.rm = T, size = labsize, hjust = 0, nudge_x = 5, segment.color = 'grey', show.legend = FALSE)
    
    if(!repel)
      p <- p + 
      ggplot2::geom_text(data = grplb, 
        ggplot2::aes(x = `Activity Start Date`, y = `Result Value`, group = `Location Group`, label = `Location Group`, color = `Location Group`), 
        na.rm = T, size = labsize, hjust = 0, nudge_x = 3, show.legend = FALSE) +
        ggplot2::scale_x_date(expand = ggplot2::expansion(mult = expand))
    
    # make sure confint is calculated
    chkbar <- any(!is.na(toplo$lov))
    
    if(confint & chkbar)
      p <- p + 
       ggplot2::geom_errorbar(data = toplo, ggplot2::aes(x = `Activity Start Date`, ymin = lov, ymax = hiv, group = `Location Group`, color = `Location Group`), width = 1, show.legend = colleg)
    
    # add color palette
    maxcol <- brewer.pal.info[palcol, 'maxcolors']
    if(is.na(maxcol))
      maxcol <- 3
    if(maxcol >= ncol)
      maxcol <- pmax(3, ncol)
    cols <- grDevices::colorRampPalette(brewer.pal(n = maxcol, name = palcol))(ncol)
    p <- p + 
      ggplot2::scale_color_manual(values = cols)
    
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
    
    # make sure confint is calculated
    chkbar <- any(!is.na(toplo$lov))
    
    if(confint & chkbar)
      p <- p + 
        ggplot2::geom_errorbar(data = toplo, ggplot2::aes(x = `Activity Start Date`, ymin = lov, ymax = hiv), width = 1, show.legend = colleg)
    
  }
  
  if(logscl)
    p <- p + ggplot2::scale_y_log10()

  p <- p +
    thm +
    ggplot2::guides(
      linetype = ggplot2::guide_legend(order = 1, override.aes = list(shape = NA)),
      size = ggplot2::guide_legend(order = 1),
      color = ggplot2::guide_legend(order = 2)
    ) +
    ggplot2::labs(
      y = ylab, 
      title = ttl, 
      linetype = NULL,
      size = NULL, 
      color = NULL,
      alpha = NULL,
      x = NULL
    ) 
  
  return(p)
  
}
