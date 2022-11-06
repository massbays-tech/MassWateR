#' Create and save tables in a single workbook for WQX upload
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param sit character string of path to the site metadata file or \code{data.frame} for site metadata returned by \code{\link{readMWRsites}}
#' @param wqx character string of path to the wqx metadata file or \code{data.frame} for wqx metadata returned by \code{\link{readMWRwqx}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param output_dir character string of the output directory for the results, default is the working directory
#' @param output_file optional character string for the file name, must include .xlsx suffix
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRsites}}, \code{\link{checkMWRwqx}}, applies only if \code{res}, \code{acc}, \code{sit}, or \code{wqx} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return An Excel workbook named \code{wqxtab.xlsx} (or name passed to \code{output_file}) will be saved in the directory specified by \code{output_dir} (default is the working directory)
#' @export
#'
#' @examples
#' # results data path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # dqo accuracy data path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' # site data path
#' sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')
#' 
#' # wqx data path
#' wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # site data
#' sitdat <- readMWRsites(sitpth)
#' 
#' # wqx data
#' wqxdat <- readMWRwqx(wqxpth)
#' 
#' \dontrun{
#' # create workbook working directory
#' tabMWRwqx(res = resdat, acc = accdat, sit = sitdat, wqx = wqxdat)
#' }
tabMWRwqx <- function(res = NULL, acc = NULL, sit = NULL, wqx = NULL, fset = NULL, output_dir = NULL, output_file = NULL, warn = TRUE, runchk = TRUE){
  
  utilMWRinputcheck(mget(ls()))
  
  # get input 
  inp <- utilMWRinput(res = res, acc = acc, sit = sit, wqx = wqx, fset = fset, runchk = runchk, warn = warn)
  resdat <- inp$resdat
  accdat <- inp$accdat
  sitdat <- inp$sitdat
  wqxdat <- inp$wqxdat

  ##
  # Projects
  prjs <- dplyr::tibble(
      `Project ID` = sort(unique(resdat$`Project ID`))
    ) %>% 
    dplyr::mutate(
      `Project Name` = NA_character_,
      `Project Description` = NA_character_,
      `QAPP Approved Indicator (Yes/No)` = NA_character_,
      `Project Attachment File Name` = NA_character_,
      `Project Attachment Type` = NA_character_,
    )

  ##
  # Locations
  locs <- resdat %>% 
    dplyr::select(`Monitoring Location ID`) %>% 
    unique() %>% 
    dplyr::arrange(`Monitoring Location ID`) %>% 
    dplyr::left_join(sitdat, by = 'Monitoring Location ID') %>% 
    dplyr::mutate(
      `Monitoring Location Type` = NA_character_, 
      `Tribal Land Indicator (Yes/No)` =  NA_character_, 
      `Tribal Land Name` = NA_character_, 
      `Monitoring Location Latitude (DD.DDDD)` = `Monitoring Location Latitude`,
      `Monitoring Location Longitude (-DDD.DDDD)` = `Monitoring Location Longitude`,
      `Monitoring Location Source Map Scale` = NA_character_,
      `Monitoring Location Horizontal Collection Method` = 'Unknown',
      `Monitoring Location Horizontal Coordinate Reference System` = 'UNKWN'
    ) %>% 
    select(
      `Monitoring Location ID`,
      `Monitoring Location Name`,
      `Monitoring Location Type`,
      `Tribal Land Indicator (Yes/No)`,
      `Tribal Land Name`,
      `Monitoring Location Latitude (DD.DDDD)`,
      `Monitoring Location Longitude (-DDD.DDDD)`,
      `Monitoring Location Source Map Scale`,
      `Monitoring Location Horizontal Collection Method`,
      `Monitoring Location Horizontal Coordinate Reference System`
    )
      
  ##
  # Results
  resu <- NULL
  
  ##
  # save output
  
  # default output directory is working directory
  if(is.null(output_dir))
    output_dir <- getwd()
  
  if(is.null(output_file))
    output_file <- 'wqxtab.xlsx'
  
  out <- list(
    Projects = prjs,
    Locations = locs#,
    # Results = resu
  )
  
  # save
  writexl::write_xlsx(out, path = file.path(output_dir, output_file))
  
  file_loc <- list.files(path = output_dir, pattern = output_file, full.names = TRUE)
  msg <- paste("Excel workbook created successfully! File located at", file_loc)
  message(msg)
  
}