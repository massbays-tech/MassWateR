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
      `Project Attachment File Name (optional)` = NA_character_,
      `Project Attachment Type (optional)` = NA_character_,
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
      `Tribal Land Indicator (Yes/No) (optional)` =  NA_character_, 
      `Tribal Land Name (optional)` = NA_character_, 
      `Monitoring Location Latitude (DD.DDDD)` = `Monitoring Location Latitude`,
      `Monitoring Location Longitude (-DDD.DDDD)` = `Monitoring Location Longitude`,
      `Monitoring Location Source Map Scale (conditional)` = NA_character_,
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
  
  # format characteristic name in resdat to wqx parameter
  resdat <- resdat %>% 
    dplyr::mutate(
      `WQX Parameter` = dplyr::case_when(
                    `Characteristic Name` %in% paramsMWR$`Simple Parameter` ~ paramsMWR$`WQX Parameter`[match(`Characteristic Name`, paramsMWR$`Simple Parameter`)], 
                    T ~ `Characteristic Name`
                  )
    )
  
  # format parameter in accdat to wqx parameter
  accdat <- accdat %>% 
    dplyr::mutate(
      `WQX Parameter` = dplyr::case_when(
        Parameter %in% paramsMWR$`Simple Parameter` ~ paramsMWR$`WQX Parameter`[match(Parameter, paramsMWR$`Simple Parameter`)], 
        T ~ Parameter
      )
    ) %>% 
    dplyr::select(`WQX Parameter`, MDL, UQL, `Value Range`)

  # create output
  resu <- resdat %>% 
    dplyr::select(
      `Project ID`, 
      `Monitoring Location ID`, 
      `Activity Type`, 
      `Activity Start Date`,
      `Activity Start Time`, 
      `Activity Depth/Height Measure`, 
      `Activity Depth/Height Unit`, 
      `Activity Relative Depth Name`,
      `Sample Collection Method ID`, 
      `Characteristic Name`, 
      `WQX Parameter`,
      `Result Value`, 
      `Result Unit`, 
      `Result Measure Qualifier`, 
      `Result Comment`
      ) %>% 
    dplyr::left_join(wqxdat, by = 'WQX Parameter') %>% 
    dplyr::mutate(
      `Sample Collection Equipment Name` = ifelse(`Activity Type` == 'Sample-Routine', 'Water Bottle', ifelse(`Activity Type` == 'Field Msr/Obs', 'Probe/Sensor', '')), 
      moniaid = ifelse(is.na(`Monitoring Location ID`), '', `Monitoring Location ID`),
      dateaid = gsub('-', '', as.character(lubridate::ymd(`Activity Start Date`))),
      timeaid = gsub(':', '', as.character(`Activity Start Time`)),
      actyaid = ifelse(`Activity Type` == 'Sample-Routine', 'SR', ifelse(`Activity Type` == 'Field Msr/Obs', 'FM', '')),
      eqnmaic = ifelse(`Sample Collection Equipment Name` == 'Water Bottle', 'WB', ifelse(`Sample Collection Equipment Name` == 'Probe/Sensor', 'PS', '')),
      deptaid = ifelse(is.na(`Activity Depth/Height Measure`), '', round(as.numeric(`Activity Depth/Height Measure`), 2)), 
      `Activity Media Name` = 'Water',
      `Activity Start Time Zone` = 'EDT',
      `Project ID` = ifelse(is.na(`Project ID`), 'Water Quality', `Project ID`),
      `Monitoring Location ID` = ifelse(
        `Activity Type` %in% c('Quality Control Sample-Lab Blank', 'Quality Control Sample-Lab Duplicate', 'Quality Control Sample-Lab Spike', 'Quality Control Field Calibration Check'),
        'LAB', `Monitoring Location ID`), 
      `Activity Depth/Height Measure` = ifelse(is.na(`Activity Relative Depth Name`), `Activity Depth/Height Measure`, NA), 
      `Activity Depth/Height Unite` = ifelse(is.na(`Activity Relative Depth Name`), `Activity Depth/Height Unit`, NA), 
      `Sample Collection Method Context` = ifelse(!is.na(`Sample Collection Method ID`), `Sampling Method Context`, NA), 
      `Characteristic Name User Supplied` = ifelse(`Characteristic Name` == `WQX Parameter`, '', `Characteristic Name`)
    ) %>%
    tidyr::unite('Activity ID', moniaid, dateaid, timeaid, actyaid, eqnmaic, deptaid, sep = ':', remove = T)
    
  # # create quality control rows found in QC Reference Value
  # qrws <- out %>%
  #   filter(!is.na(`QC Reference Value`)) %>%
  #   mutate(
  #     `Result Value` = `QC Reference Value`,
  #     `Activity Type` = case_when(
  #       `Activity Type` == 'Field Msr/Obs' ~ 'Quality Control Field Replicate Msr/Obs',
  #       `Activity Type` == 'Sample-Routine' ~ 'Quality Control Sample-Field Replicate',
  #       `Activity Type` == 'Quality Control Sample-Field Blank' ~ NA_character_, # to remove
  #       `Activity Type` == 'Quality Control Sample-Lab Duplicate' ~ 'Quality Control Sample-Lab Duplicate',
  #       `Activity Type` == 'Quality Control Sample-Lab Blank' ~ NA_character_, # to remove
  #       `Activity Type` == 'Quality Control Sample-Lab Spike' ~ 'Quality Control Sample-Reference Sample'
  #     ),
  #     `QC Reference Value` = gsub('[[:digit:]]+', NA_character_, `QC Reference Value`)
  #   ) %>%
  #   filter!is.na(`Activity Type`) # remove those not needed
  # 
  # # append new quality control rows, remove values in QC Reference Value
  # out <- out %>%
  #   mutate(
  #     `QC Reference Value` = NA_character_
  #   ) %>%
  #   bind_rows(qrws)
  
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