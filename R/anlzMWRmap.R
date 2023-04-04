#' Analyze results with maps
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform to entries in the \code{"Simple Parameter"} column of \code{\link{paramsMWR}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param sit character string of path to the site metadata file or \code{data.frame} of site metadata returned by \code{\link{readMWRsites}}
#' @param site character string of sites to include, default all
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param resultatt character string of result attributes to plot, default all
#' @param locgroup character string of location groups to plot from the \code{"Location Group"} column in the site metadata file, default all
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, default all
#' @param ptsize numeric for size of the points, use a negative value to omit the points
#' @param repel logical indicating if overlapping site labels are offset
#' @param labsize numeric for size of the site labels
#' @param palcol character string indicating the color palette to be used from \href{https://r-graph-gallery.com/38-rcolorbrewers-palettes.html}{RColorBrewer}, see details
#' @param rev logical indicating if color palette in \code{palcol} is reversed
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param crs numeric as a four-digit EPSG number for the coordinate reference system, see details
#' @param zoom numeric indicating resolution of the base map, see details
#' @param addwater character string as \code{"low"}, \code{"medium"} (default), \code{"high"}, or \code{NULL} (to supress) to include water features with varying detail from the National Hydrography dataset, see details
#' @param watercol character string of color for water objects if \code{addwater = "nhd"} or \code{addwater = "osm"}
#' @param maptype character string for the base map type, see details
#' @param buffdist numeric for buffer around the bounding box for the selected sites in kilometers, see details
#' @param scaledist character string indicating distance unit for the scale bar, \code{"km"} or \code{"mi"}
#' @param northloc character string indicating location of the north arrow, see details
#' @param scaleloc character string indicating location of the scale bar, see details
#' @param latlon logical to include latitude and longitude labels on the plot, default \code{TRUE}
#' @param ttlsize numeric value indicating font size of the title relative to other text in the plot
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, or \code{\link{checkMWRsites}}, applies only if \code{res}, \code{acc}, or \code{sit} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified.
#' @export
#'
#' @details 
#' This function creates a map of summarized results for a selected parameter at each monitoring site.  By default, all dates for the parameter are averaged. Options to filter by site, date range, and result attribute are provided.  Only sites with spatial information in the site metadata file are plotted and a warning is returned for those that do not have this information. The site labels are also plotted next to each point.  The labels can be suppressed by setting \code{labsize = NULL}.
#' 
#' Any acceptable color palette from \href{https://r-graph-gallery.com/38-rcolorbrewers-palettes.html}{RColorBrewer} can be used for \code{palcol}, which is passed to the \code{palette} argument in \code{\link[ggplot2]{scale_fill_distiller}}. These could include any of the sequential color palettes, e.g., \code{"Greens"}, \code{"Blues"}, etc.  The diverging and qualitative palettes will also work, but may return uninterpretable color scales. The palette can be reversed by setting \code{rev = TRUE}.
#' 
#' The default value for \code{crs} is EPSG 4326 for the WGS 84 projection in decimal degrees.  The \code{crs} argument is passed to \code{\link[sf]{st_as_sf}} and any acceptable CRS appropriate for the data can be used. 
#' 
#' The results shown on the map represent the parameter average for each site within the date range provided by \code{dtrng}.  The average may differ depending on the value provided to the \code{yscl} argument.  Log10-distributed parameters use the geometric mean and normally-distributed parameters use the arithmetic mean.  The distribution is determined from the \code{ycsl} argument. If \code{yscl = "auto"} (default), the distribution is determined automatically from the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are summarized with the geometric mean, otherwise arithmetic. Setting \code{yscl = "linear"} or \code{yscl = "log"} will the use arithmetic or geometric summaries, respectively, regardless of the information in the data quality objective file for accuracy. 
#' 
#' Using \code{addwater = "medium"} (default) will include lines and polygons of natural water bodies defined using the National Hydrography Dataset (NHD). The level of detail can be changed to low or high using \code{addwater = "low"} or \code{addwater = "high"}, respectively.  Use \code{addwater = NULL} to not show any water features.
#' 
#' A base map can be plotted using the \code{maptype} argument and is obtained from the \code{\link[ggmap]{get_stamenmap}} function of ggmap.  The \code{zoom} value specifies the resolution of the map.  Use higher values to download map tiles with greater resolution, although this increases the download time.  The \code{maptype} argument describes the type of base map to download. Acceptable options include \code{"terrain"}, \code{"terrain-background"}, \code{"terrain-labels"}, \code{"terrain-lines"}, \code{"toner"}, \code{"toner-2010"}, \code{"toner-2011"}, \code{"toner-background"}, \code{"toner-hybrid"}, \code{"toner-labels"}, \code{"toner-lines"}, \code{"toner-lite"}, or \code{"watercolor"}. Use \code{maptype = NULL} to suppress the base map.
#' 
#' The area around the summarized points can be increased or decreased using the \code{buffdist} argument.  This creates a buffered area around the bounding box for the points, where the units are kilometers.  
#' 
#' A north arrow and scale bar are also placed on the map as defined by the \code{northloc} and \code{scaleloc} arguments.  The placement for both can be chosen as \code{"tl"}, \code{"tr"}, \code{"bl"}, or \code{"br"} for top-left, top-right, bottom-left, or bottom-right respectively.  Setting either of the arguments to \code{NULL} will suppress the placement on the map.  
#'  
#' @examples
#' # results data path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
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
#' \donttest{
#' # map with NHD water bodies
#' anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, addwater = 'medium')
#' }
anlzMWRmap<- function(res = NULL, param, acc = NULL, sit = NULL, fset = NULL, site = NULL, resultatt = NULL, locgroup = NULL, dtrng = NULL, ptsize = 4, repel = TRUE, labsize = 3, palcol = 'Greens', rev = FALSE, yscl = c('auto', 'log', 'linear'), crs = 4326, zoom = 11, addwater = 'medium', watercol = 'lightblue', maptype = NULL, buffdist = 2, scaledist = 'km', northloc = 'tl', scaleloc = 'br', latlon = TRUE, ttlsize = 1.2, runchk = TRUE, warn = TRUE){
  
  utilMWRinputcheck(mget(ls()))
  
  # inputs
  inp <- utilMWRinput(res = res, acc = acc, sit = sit, fset = fset, runchk = F, warn = warn)
  
  # results data
  resdat <- utilMWRfiltersurface(inp$resdat) 
  
  # accuracy data
  accdat <- inp$accdat
  
  # site data
  sitdat <- inp$sitdat
  
  # filter
  resdat <- utilMWRfilter(resdat = resdat, sitdat = sitdat, param = param, dtrng = dtrng, site = site, resultatt = resultatt, locgroup = locgroup)
  
  # fill BDL, AQL
  resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = param, warn = warn)
  
  # get y axis scaling
  logscl <- utilMWRyscale(accdat = accdat, param = param, yscl = yscl)
  
  tomap <- resdat %>% 
    dplyr::group_by(`Monitoring Location ID`)
  
  tomap <- utilMWRconfint(tomap, logscl = logscl)
    
  # prep map
  
  # check scaledist arg as km or mi
  scaledist <- match.arg(scaledist, c('km', 'mi'))
  
  tomap <- tomap %>% 
    left_join(sitdat, by = 'Monitoring Location ID')

  # warning or stop if missing lat/lon or no lat/lon
  naloc <- is.na(tomap$`Monitoring Location Longitude`) | is.na(tomap$`Monitoring Location Latitude`)
  chk <- any(naloc)

  if(nrow(tomap) == sum(naloc))
    stop('No spatial information in sites file for selected data')
  
  if(chk & warn){
    
    msg <- tomap[naloc, ] %>% 
      dplyr::pull(`Monitoring Location ID`) %>% 
      sort
    
    warning('No spatial information for sites: ', paste(msg, collapse = ', '))
    
  }

  tomap <- tomap %>% 
    dplyr::filter(!naloc) %>% 
    sf::st_as_sf(coords = c('Monitoring Location Longitude', 'Monitoring Location Latitude'), crs = crs) %>% 
    sf::st_transform(crs = 26986) %>% 
    sf::st_zm()

  # layer extent as bbox plus buffer
  if(nrow(tomap) > 1)
    dat_ext <- tomap %>% 
      sf::st_bbox() %>% 
      sf::st_as_sfc() %>% 
      sf::st_buffer(dist = units::set_units(buffdist, kilometer)) %>%
      sf::st_transform(crs = 4326) %>% 
      sf::st_bbox() %>% 
      unname
  if(nrow(tomap) == 1)
    dat_ext <- tomap %>% 
      sf::st_as_sfc() %>% 
      sf::st_buffer(dist = units::set_units(buffdist, kilometer)) %>%
      sf::st_transform(crs = 4326) %>% 
      sf::st_bbox() %>% 
      unname
  
  ylab <- unique(resdat$`Result Unit`)
  ttl <- utilMWRtitle(param = paste('Average', param), site = site, dtrng = dtrng, locgroup = locgroup, resultatt = resultatt)
    
  m <- ggplot2::ggplot()

  if(!is.null(maptype)){

    bsmap <- suppressMessages(ggmap::get_stamenmap(bbox = dat_ext, maptype = maptype, zoom = zoom))
    m <- ggmap::ggmap(bsmap)
    
  }

  if(!is.null(addwater)){
    
    chk <- addwater %in% c('low', 'medium', 'high')
    if(!chk)
      stop('addwater argument must be "low", "medium", "high", or NULL')

    streamsMWR <- utilMWRhttpgrace('https://github.com/massbays-tech/MassWateRdata/raw/main/data/streamsMWR.RData')
    riversMWR <- utilMWRhttpgrace('https://github.com/massbays-tech/MassWateRdata/raw/main/data/riversMWR.RData')
    pondsMWR <- utilMWRhttpgrace('https://github.com/massbays-tech/MassWateRdata/raw/main/data/pondsMWR.RData')
    
    dtl <- list('low' = 'low', 'medium' = c('low', 'medium'), 'high' = c('low', 'medium', 'high'))
    dtl <- dtl[[addwater]]
 
    dat_ext <- dat_ext %>% 
      sf::st_as_sfc() %>% 
      sf::st_transform(crs = 26986) %>% 
      sf::st_bbox()
    
    streamscrop <- suppressWarnings({streamsMWR %>% 
      dplyr::filter(dLevel %in% dtl) %>% 
      sf::st_crop(dat_ext) %>% 
      sf::st_transform(crs = 4326)
    })
    riverscrop <- suppressWarnings({riversMWR %>% 
      dplyr::filter(dLevel %in% dtl) %>% 
      sf::st_crop(dat_ext) %>% 
      sf::st_transform(crs = 4326)
    })
    pondscrop <- suppressWarnings({pondsMWR %>% 
      dplyr::filter(dLevel %in% dtl) %>% 
      sf::st_crop(dat_ext) %>% 
      sf::st_transform(crs = 4326)
      })
  
    suppressMessages({
      m <- m +
        ggplot2::geom_sf(data = streamscrop, col = watercol, fill = watercol, inherit.aes = FALSE) +
        ggplot2::geom_sf(data = riverscrop, col = watercol, fill = watercol, inherit.aes = FALSE) +
        ggplot2::geom_sf(data = pondscrop, col = watercol, fill = watercol, inherit.aes = FALSE)
    })
    
  }
  
  # color palette direction
  rev <- ifelse(rev, -1, 1)
  
  tomap <- tomap %>% 
    sf::st_transform(crs = 4326)

    m <-  m +
      ggplot2::geom_sf(data = tomap, ggplot2::aes(fill = `Result Value`), color = 'black', pch = 21, inherit.aes = F, size = ptsize) +
      ggplot2::scale_fill_distiller(name = ylab, palette = palcol, direction = rev) +
      ggplot2::theme(
        panel.grid = ggplot2::element_blank(), 
        axis.title = ggplot2::element_blank(), 
        axis.text.y = ggplot2::element_text(size = 8), 
        axis.text.x = ggplot2::element_text(size = 8, angle = 30, hjust = 1),
        axis.ticks = ggplot2::element_line(colour = 'grey'),
        plot.title = ggplot2::element_text(size = ggplot2::rel(ttlsize)), 
        panel.background = ggplot2::element_rect(fill = NA, color = 'black')
      ) +
      ggplot2::labs(
        title = ttl
      ) 

  if(!is.null(scaleloc)){
    scaledist <- ifelse(scaledist == 'km', 'metric', 'imperial')
    m <- m +
      ggspatial::annotation_scale(location = scaleloc, unit_category = scaledist)
  }
    
  if(!is.null(northloc))
    m <- m +
      ggspatial::annotation_north_arrow(location = northloc, which_north = "true", height = grid::unit(0.75, "cm"), 
                                                width = grid::unit(0.75, "cm"))

  # labels must not be sf to prevent warning
  tolab <- tomap %>% 
    sf::st_transform(crs = 4326) %>% 
    dplyr::mutate(
      x = sf::st_coordinates(.)[, 1],
      y = sf::st_coordinates(.)[, 2]
    ) %>% 
    dplyr::select(`Monitoring Location ID`, x, y) %>% 
    sf::st_set_geometry(NULL)
  
  if(repel & !is.null(labsize))
    m <- m  +
      ggrepel::geom_text_repel(data = tolab, ggplot2::aes(label = `Monitoring Location ID`, x = x, y = y), size = labsize)
  
  if(!repel & !is.null(labsize))
      m <- m  +
        ggplot2::geom_text(data = tolab, ggplot2::aes(label = `Monitoring Location ID`, x = x, y = y), size = labsize)

  if(!latlon)
    m <- m + 
      ggplot2::theme(
        axis.text.x = ggplot2::element_blank(), 
        axis.text.y = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank()
      )
  
  dat_ext <- dat_ext %>% 
    sf::st_as_sfc(dat_ext) %>% 
    sf::st_transform(crs = 4326) %>% 
    sf::st_bbox()
  
  # set coordinates because vector not clipped
  m <- m +
    ggplot2::coord_sf(xlim = dat_ext[c(1, 3)], ylim = dat_ext[c(2, 4)], expand = FALSE)
  
  return(m)
  
}
