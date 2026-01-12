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
#' @param palcolrev logical indicating if color palette in \code{palcol} is reversed
#' @param sumfun character indicating one of \code{"auto"} (default), \code{"mean"}, \code{"geomean"}, \code{"median"}, \code{"min"}, or \code{"max"}, see details
#' @param crs numeric as a four-digit EPSG number for the coordinate reference system, see details
#' @param zoom numeric indicating resolution of the base map, see details
#' @param addwater character string as \code{"low"}, \code{"medium"} (default), \code{"high"}, or \code{NULL} (to suppress) to include water features with varying detail from the National Hydrography dataset, see details
#' @param watercol character string of color for water objects if \code{addwater} is not \code{NULL}
#' @param maptype character string indicating the basemap type, see details
#' @param buffdist numeric for buffer around the bounding box for the selected sites in kilometers, see details
#' @param scaledist character string indicating distance unit for the scale bar, \code{"km"} or \code{"mi"}
#' @param northloc character string indicating location of the north arrow, see details
#' @param scaleloc character string indicating location of the scale bar, see details
#' @param latlon logical to include latitude and longitude labels on the plot, default \code{TRUE}
#' @param useapi logical to use API to retrieve water features if \code{addwater} is not \code{NULL}
#' @param ttlsize numeric value indicating font size of the title relative to other text in the plot
#' @param bssize numeric for overall plot text scaling, passed to \code{\link[ggplot2]{theme_gray}}
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, or \code{\link{checkMWRsites}}, applies only if \code{res}, \code{acc}, or \code{sit} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified.
#' @export
#'
#' @details 
#' This function creates a map of summarized results for a selected parameter at each monitoring site.  By default, all dates for the parameter are averaged. Options to filter by site, date range, and result attribute are provided.  Only sites with spatial information in the site metadata file are plotted and a warning is returned for those that do not have this information. The site labels are also plotted next to each point.  The labels can be suppressed by setting \code{labsize = NULL}.
#' 
#' Any acceptable color palette from \href{https://r-graph-gallery.com/38-rcolorbrewers-palettes.html}{RColorBrewer} can be used for \code{palcol}, which is passed to the \code{palette} argument in \code{\link[ggplot2]{scale_fill_distiller}}. These could include any of the sequential color palettes, e.g., \code{"Greens"}, \code{"Blues"}, etc.  The diverging and qualitative palettes will also work, but may return uninterpretable color scales. The palette can be reversed by setting \code{palcolrev = TRUE}.
#' 
#' The default value for \code{crs} is EPSG 4326 for the WGS 84 projection in decimal degrees.  The \code{crs} argument is passed to \code{\link[sf]{st_as_sf}} and any acceptable CRS appropriate for the data can be used. 
#' 
#' The results shown on the map represent the parameter summary for each site within the date range provided by \code{dtrng}.  If \code{sumfun = "auto"} (default), the mean is used where the distribution is determined automatically from the data quality objective file for accuracy, i.e., parameters with "log" in any of the columns are summarized with the geometric mean, otherwise arithmetic. Any other valid summary function will be applied if passed to \code{sumfun} (\code{"mean"}, \code{"geomean"}, \code{"median"}, \code{"min"}, \code{"max"}), regardless of the information in the data quality objective file for accuracy. 
#' 
#' Using \code{addwater = "medium"} (default) will include lines and polygons of natural water bodies defined using the National Hydrography Dataset (NHD). The level of detail can be changed to low or high using \code{addwater = "low"} or \code{addwater = "high"}, respectively.  Use \code{addwater = NULL} to not show any water features.
#' 
#' A base map can be plotted using the \code{maptype} argument.  The \code{zoom} value specifies the resolution of the map.  Use higher values to download map tiles with greater resolution, although this increases the download time.  The \code{maptype} argument describes the type of base map to download. Acceptable options include \code{"OpenStreetMap"}, \code{"OpenStreetMap.DE"}, \code{"OpenStreetMap.France"}, \code{"OpenStreetMap.HOT"}, \code{"OpenTopoMap"}, \code{"Esri.WorldStreetMap"}, \code{"Esri.DeLorme"}, \code{"Esri.WorldTopoMap"}, \code{"Esri.WorldImagery"}, \code{"Esri.WorldTerrain"}, \code{"Esri.WorldShadedRelief"}, \code{"Esri.OceanBasemap"}, \code{"Esri.NatGeoWorldMap"}, \code{"Esri.WorldGrayCanvas"}, \code{"CartoDB.Positron"}, \code{"CartoDB.PositronNoLabels"}, \code{"CartoDB.PositronOnlyLabels"}, \code{"CartoDB.DarkMatter"}, \code{"CartoDB.DarkMatterNoLabels"}, \code{"CartoDB.DarkMatterOnlyLabels"}, \code{"CartoDB.Voyager"}, \code{"CartoDB.VoyagerNoLabels"}, or \code{"CartoDB.VoyagerOnlyLabels"}. Use \code{maptype = NULL} to suppress the base map.
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
anlzMWRmap<- function(res = NULL, param, acc = NULL, sit = NULL, fset = NULL, site = NULL, resultatt = NULL, locgroup = NULL, dtrng = NULL, ptsize = 4, repel = TRUE, labsize = 3, palcol = 'Greens', palcolrev = FALSE, sumfun = 'auto', crs = 4326, zoom = 11, addwater = 'medium', watercol = 'lightblue', maptype = NULL, buffdist = 2, scaledist = 'km', northloc = 'tl', scaleloc = 'br', latlon = TRUE, useapi = FALSE, ttlsize = 1.2, bssize = 11, runchk = TRUE, warn = TRUE){
  
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
  
  tomap <- resdat %>% 
    dplyr::group_by(`Monitoring Location ID`)
  
  tomap <- utilMWRsummary(tomap, accdat = accdat, param = param, sumfun = sumfun, confint = FALSE)
    
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
      sf::st_bbox()
  if(nrow(tomap) == 1)
    dat_ext <- tomap %>% 
      sf::st_as_sfc() %>% 
      sf::st_buffer(dist = units::set_units(buffdist, kilometer)) %>%
      sf::st_transform(crs = 4326) %>% 
      sf::st_bbox()
  
  ylab <- unique(resdat$`Result Unit`)
  ttl <- utilMWRtitle(param = param, accdat = accdat, sumfun = sumfun, site = site, dtrng = dtrng, locgroup = locgroup, resultatt = resultatt)
    
  m <- ggplot2::ggplot()

  if(!is.null(maptype)){
    
    maptype <- match.arg(maptype, c("OpenStreetMap", "OpenStreetMap.DE", "OpenStreetMap.France", 
                                    "OpenStreetMap.HOT", "OpenTopoMap",
                                    "Esri.WorldStreetMap", "Esri.DeLorme", "Esri.WorldTopoMap", 
                                    "Esri.WorldImagery", "Esri.WorldTerrain", "Esri.WorldShadedRelief", 
                                    "Esri.OceanBasemap", "Esri.NatGeoWorldMap", "Esri.WorldGrayCanvas", 
                                    "CartoDB.Positron", "CartoDB.PositronNoLabels", 
                                    "CartoDB.PositronOnlyLabels", "CartoDB.DarkMatter", 
                                    "CartoDB.DarkMatterNoLabels", "CartoDB.DarkMatterOnlyLabels", 
                                    "CartoDB.Voyager", "CartoDB.VoyagerNoLabels", "CartoDB.VoyagerOnlyLabels"))
    
    tls <- maptiles::get_tiles(dat_ext, provider = maptype, zoom = zoom, )
    
    m <- m + 
      tidyterra::geom_spatraster_rgb(data = tls, maxcell = 1e8)

  }

  if(!is.null(addwater)){
    
    chk <- addwater %in% c('low', 'medium', 'high')
    if(!chk)
      stop('addwater argument must be "low", "medium", "high", or NULL')

    dtl <- list('low' = 'low', 'medium' = c('low', 'medium'), 'high' = c('low', 'medium', 'high'))
    dtl <- dtl[[addwater]]

    if(!useapi){

      streamsMWR <- utilMWRhttpgrace('https://github.com/massbays-tech/MassWateRdata/raw/main/data/streamsMWR.RData')
      riversMWR <- utilMWRhttpgrace('https://github.com/massbays-tech/MassWateRdata/raw/main/data/riversMWR.RData')
      pondsMWR <- utilMWRhttpgrace('https://github.com/massbays-tech/MassWateRdata/raw/main/data/pondsMWR.RData')
      
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
      
    }

    if(useapi){

      streamscrop <- utilMWRgetnhd(
          id = 6,
          bbox = dat_ext, 
          dLevel = addwater
        )
      riverscrop <- utilMWRgetnhd(
          id = 9,
          bbox = dat_ext,
          dLevel = addwater
        )
      pondscrop <- utilMWRgetnhd(
          id = 12,
          bbox = dat_ext,
          dLevel = addwater
        )

    }
      
    suppressMessages({
      m <- m +
        ggplot2::geom_sf(data = streamscrop, col = watercol, fill = watercol, inherit.aes = FALSE) +
        ggplot2::geom_sf(data = riverscrop, col = watercol, fill = watercol, inherit.aes = FALSE) +
        ggplot2::geom_sf(data = pondscrop, col = watercol, fill = watercol, inherit.aes = FALSE)
    })
    
  }
  
  # color palette direction
  palcolrev <- ifelse(palcolrev, -1, 1)
  
  tomap <- tomap %>% 
    sf::st_transform(crs = 4326)
  
  m <-  m +
    ggplot2::geom_sf(data = tomap, ggplot2::aes(fill = `Result Value`), color = 'black', pch = 21, inherit.aes = F, size = ptsize) +
    ggplot2::scale_fill_distiller(name = ylab, palette = palcol, direction = palcolrev) +
    ggplot2::theme_gray(base_size = bssize) + 
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(), 
      axis.title = ggplot2::element_blank(), 
      axis.text.y = ggplot2::element_text(size = ggplot2::rel(0.9)), 
      axis.text.x = ggplot2::element_text(size = ggplot2::rel(0.9), angle = 30, hjust = 1),
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
      ggspatial::annotation_scale(location = scaleloc, unit_category = scaledist, text_cex = bssize / 11 * 0.7, 
                                  height = grid::unit(0.25 * bssize / 11, 'cm'))
  }
    
  if(!is.null(northloc))
    m <- m +
      ggspatial::annotation_north_arrow(location = northloc, which_north = "true", height = grid::unit(0.75 * bssize / 11, "cm"), 
                                                width = grid::unit(0.75 * bssize / 11, "cm"), 
                                        style = ggspatial::north_arrow_orienteering(text_size = bssize / 11 * 10))

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
      ggspatial::geom_spatial_text_repel(data = tolab, ggplot2::aes(label = `Monitoring Location ID`, x = x, y = y), size = bssize / 11 * labsize, 
                                   inherit.aes = F, crs = 4326)
  
  if(!repel & !is.null(labsize))
    m <- m  +
      ggspatial::geom_spatial_text_repel(data = tolab, ggplot2::aes(label = `Monitoring Location ID`, x = x, y = y), size = bssize / 11 * labsize, 
                                       inherit.aes = F, crs = 4326)

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
    ggplot2::coord_sf(xlim = dat_ext[c(1, 3)], ylim = dat_ext[c(2, 4)], expand = FALSE, crs = 4326)
  
  return(m)
  
}
