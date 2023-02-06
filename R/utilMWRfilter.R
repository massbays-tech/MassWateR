#' Filter results data by date range, site, result attributes, and/or location group
#'
#' @param resdat results data as returned by \code{\link{readMWRresults}}
#' @param sitdat site metadata file as returned by \code{\link{readMWRresults}}
#' @param param character string to filter results by a parameter in \code{"Characteristic Name"}
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD
#' @param site character string of sites to include, default all
#' @param resultatt character string of result attributes to include, default all
#' @param locgroup character string of location groups to include from the \code{"Location Group"} column in the site metadata file
#' @param alllocgroup logical indicating if results data are filtered by all location groups in \code{"Location Group"} in the site metadata file if \code{locgroup = NULL}, used only in \code{\link{anlzMWRdate}}
#' @param allresultatt logical indicating if results data are filtered by all result attributes if \code{resultatt = NULL}, used only in \code{\link{anlzMWRsite}}
#'
#' @return \code{resdat} filtered by \code{dtrng}, \code{site}, \code{resultatt}, and/or \code{locgroup}, otherwise \code{resdat} unfiltered if arguments are \code{NULL}
#' @export
#'
#' @examples
#' # results file path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # site data path
#' sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')
#' 
#' # site data
#' sitdat <- readMWRsites(sitpth)
#' 
#' # filter by date
#' utilMWRfilter(resdat, param = 'DO', dtrng = c('2022-06-01', '2022-06-30'))
#' 
#' # filter by site
#' utilMWRfilter(resdat, param = 'DO', site = c('ABT-026', 'ABT-062', 'ABT-077'))
#' 
#' # filter by result attribute
#' utilMWRfilter(resdat, param = 'DO', resultatt = 'DRY')
#' 
#' # filter by location group
#' utilMWRfilter(resdat, param = 'DO', sitdat = sitdat, 
#'      locgroup = 'Assabet', dtrng = c('2022-06-01', '2022-06-30'))
utilMWRfilter <- function(resdat, sitdat = NULL, param, dtrng = NULL, site = NULL, resultatt = NULL, locgroup = NULL, alllocgroup = FALSE, allresultatt = FALSE){
  
  resdat <- resdat %>% 
    dplyr::filter(`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine'))
  
  ##
  # filter by parameter
  
  resprms <- resdat %>% 
    dplyr::pull(`Characteristic Name`) %>% 
    unique() %>% 
    sort
  
  # check if parameter in resdat
  chk <- param %in% resprms
  if(!chk)
    stop(param, ' not found in results data, should be one of ', paste(resprms, collapse = ', '), call. = FALSE)
  
  resdat <- resdat %>% 
    dplyr::filter(`Characteristic Name` %in% param)
  
  ##
  # filter by date range
  
  # check date format if provided
  if(!is.null(dtrng)){
    
    if(length(dtrng) != 2)
      stop('Must supply two dates for dtrng', call. = FALSE)
    
    dtflt <- suppressWarnings(as.Date(c(dtrng), format = '%Y-%m-%d'))
    
    if(anyNA(dtflt)){
      stop('Dates in dtrng not entered as YYYY-MM-DD', call. = FALSE)
    } 
    
    dtflt <- sort(dtflt)
    
    resdat <- resdat[resdat$`Activity Start Date` >= dtflt[1] & resdat$`Activity Start Date` <= dtflt[2], ]
  
    if(nrow(resdat) == 0)
      stop('No data available for date range', call. = FALSE)
    
  }
  
  ##
  # filter by site
  
  if(!is.null(site)){
    
    # run checks if site in resdat
    ressit <- sort(unique(resdat$`Monitoring Location ID`))
    chk <- !site %in% ressit
    if(any(chk)){
      msg <- site[chk]
      stop('Sites not found in Monitoring Location ID in results file for ', param, ': ', paste(msg, collapse = ', '), ', should be any of ', paste(ressit, collapse = ', '), call. = FALSE)
    }
    
    resdat <- resdat %>% 
      dplyr::filter(`Monitoring Location ID` %in% site)
    
  }
  
  ##
  # filter by result attribute
  
  if(!is.null(resultatt) | allresultatt){
    
    # get all result attributes if resultatt NULL
    if(is.null(resultatt))
      resultatt <- resdat %>% 
        dplyr::pull(`Result Attribute`) %>% 
        unique()
        
    # run checks if result attribute in resdat
    resatt <- unique(resdat$`Result Attribute`)
    chk <- !resultatt %in% resatt
    if(any(chk)){
      msg <- resultatt[chk]
      resatt <- ifelse(length(na.omit(resatt)) == 0, 'none available', paste('should be any of', paste(sort(resatt), collapse = ', ')))
      stop('Result attributes not found in results file for ', param, ': ', paste(msg, collapse = ', '), ', ', resatt, call. = FALSE)
    }
    
    resdat <- resdat %>% 
      dplyr::filter(`Result Attribute` %in% resultatt)
    
  }
  
  ##
  # filter by location group
  
  if(!is.null(locgroup) | alllocgroup){
    
    if(is.null(sitdat))
      stop('Site metadata file required if filtering by location group', call. = FALSE)
    
    sitdat <- sitdat %>% 
      dplyr::select(`Monitoring Location ID`, `Location Group`) %>% 
      unique
    
    resdat <- resdat %>% 
      dplyr::left_join(sitdat, by = c('Monitoring Location ID'))
    
    if(is.null(locgroup))
      locgroup <- resdat %>% 
        dplyr::pull(`Location Group`) %>% 
        unique() %>% 
        sort() %>% 
        na.omit()
    
    # run checks if location group in resdat
    reslocgroup <- sort(unique(resdat$`Location Group`))
    chk <- !locgroup %in% reslocgroup
    if(any(chk)){
      msg <- locgroup[chk]
      reslocgroup <- ifelse(length(na.omit(reslocgroup)) == 0, 'none available', paste('should be any of', paste(reslocgroup, collapse = ', ')))
      stop('Location group not found in site metadata file for ', param, ': ', paste(msg, collapse = ', '), ', ', reslocgroup, call. = FALSE)
    }
    
    resdat <- resdat %>% 
      dplyr::filter(`Location Group` %in% locgroup)
    
  }
  
  out <- resdat
  
  return(out)
  
}
