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
#' @details This function will export a single Excel workbook with three sheets, named "Project", "Locations", and "Results". The output is populated with as much content as possible based on information in the input files.  The remainder of the information not included in the output will need to be manually entered before uploading the data to WQX.  All required columns are present, but individual rows will need to be verified for completeness.  It is the responsibility of the user to verify this information is complete and correct before uploading the data. 
#' 
#' The workflow for using this function is to import the required data (results, data quality objectives file for accuracy, site metadata, and wqx metadata) and to fix any errors noted on import prior to creating the output. The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRacc}}, \code{\link{readMWRsites}}, and \code{\link{readMWRwqx}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.
#'
#' The name of the output file can also be changed using the \code{output_file} argument, the default being \code{wqxtab.xlsx}.  Warnings can also be turned off or on (default) using the \code{warn} argument.  This returns any warnings when data are imported and only applies if the file inputs are paths.
#' 
#' @return An Excel workbook named \code{wqxtab.xlsx} (or name passed to \code{output_file}) will be saved in the directory specified by \code{output_dir} (default is the working directory). The workbook will include three sheets names "Projects", "Locations", and "Results".
#' 
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
      `Project ID` = c(
        sort(unique(resdat$`Project ID`)), 
        ifelse(anyNA(resdat$`Project ID`), 'Water Quality', NA)
        )
    ) %>% 
    dplyr::mutate(
      `Project Name` = NA_character_,
      `Project Description` = NA_character_,
      `QAPP Approved Indicator (Yes/No)` = NA_character_,
      `Project Attachment File Name (optional)` = NA_character_,
      `Project Attachment Type (optional)` = NA_character_
    )

  ##
  # Locations
  locs <- resdat %>% 
    dplyr::select(`Monitoring Location ID`) %>% 
    unique() %>% 
    dplyr::filter(!is.na(`Monitoring Location ID`)) %>% 
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
      `Tribal Land Indicator (Yes/No) (optional)`,
      `Tribal Land Name (optional)`,
      `Monitoring Location Latitude (DD.DDDD)`,
      `Monitoring Location Longitude (-DDD.DDDD)`,
      `Monitoring Location Source Map Scale (conditional)`,
      `Monitoring Location Horizontal Collection Method`,
      `Monitoring Location Horizontal Coordinate Reference System`
    )
  
  ##
  # Results
  
  # new activity types for quality control rows where QC Reference Value is not blank
  qcrws <- c('Quality Control Field Replicate Msr/Obs', 'Quality Control Sample-Field Replicate',
             'Quality Control Sample-Lab Duplicate 2', 'Quality Control Sample-Reference Sample',
             'Quality Control Sample-Measurement Precision Sample')
  
  # format parameter in accdat to wqx parameter
  accdat <- accdat %>% 
    dplyr::mutate(
      `WQX Parameter` = dplyr::case_when(
        Parameter %in% paramsMWR$`Simple Parameter` ~ paramsMWR$`WQX Parameter`[match(Parameter, paramsMWR$`Simple Parameter`)], 
        T ~ Parameter
      )
    ) %>% 
    dplyr::select(`WQX Parameter`, MDL, UQL, `Value Range`)

  # format characteristic name in resdat to wqx parameter
  resu <- resdat %>% 
    dplyr::mutate(
      `WQX Parameter` = dplyr::case_when(
        `Characteristic Name` %in% paramsMWR$`Simple Parameter` ~ paramsMWR$`WQX Parameter`[match(`Characteristic Name`, paramsMWR$`Simple Parameter`)], 
        T ~ `Characteristic Name`
      )
    )
  
  # create quality control rows where QC Reference Value is not NA
  qrws <- resu %>%
    filter(!is.na(`QC Reference Value`)) %>%
    mutate(
      `Result Value` = `QC Reference Value`,
      `Activity Type` = case_when(
        `Activity Type` == 'Field Msr/Obs' ~ 'Quality Control Field Replicate Msr/Obs',
        `Activity Type` == 'Sample-Routine' ~ 'Quality Control Sample-Field Replicate',
        `Activity Type` == 'Quality Control Sample-Field Blank' ~ NA_character_, # to remove
        `Activity Type` == 'Quality Control Sample-Lab Blank' ~ NA_character_, # to remove
        `Activity Type` == 'Quality Control Sample-Lab Duplicate' ~ 'Quality Control Sample-Lab Duplicate 2',
        `Activity Type` == 'Quality Control Sample-Lab Spike' ~ 'Quality Control Sample-Reference Sample',
        `Activity Type` == 'Quality Control Field Calibration Check' ~ 'Quality Control Sample-Measurement Precision Sample'
      ),
      `QC Reference Value` = gsub('[[:digit:]]+', NA_character_, `QC Reference Value`)
    ) %>%
    filter(!is.na(`Activity Type`))

  # append new quality control rows, remove values in QC Reference Value
  resu <- resu %>%
    mutate(
      `QC Reference Value` = NA_character_
    ) %>%
    bind_rows(qrws)

  # add unique time to QC rows that don't have time
  resu <- resu %>% 
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
      `Result Comment`, 
      `Quantitation Limit`
      ) %>% 
    dplyr::group_by(`Activity Start Date`, `Characteristic Name`, `Activity Type`) %>% 
    dplyr::mutate(
      actstrtm = dplyr::case_when(
        !`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine') & is.na(`Activity Start Time`) ~ 1,
        T ~ NA_real_
      ), 
      actstrtm = cumsum(actstrtm)
    ) %>% 
    dplyr::rowwise() %>% 
    dplyr::mutate(
      actstrtm = paste0(c(sprintf("%02d", actstrtm %/% 60), sprintf('%02d', actstrtm %% 60)), collapse = ':'),
      actstrtm = ifelse(actstrtm == 'NA:NA', NA, actstrtm)
    ) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(
      `Activity Start Time` = ifelse(is.na(`Activity Start Time`), actstrtm, `Activity Start Time`)
    ) %>% 
    dplyr::select(-actstrtm)

  # add activity id
  resu <- resu %>% 
    dplyr::mutate(
      `Monitoring Location ID` = ifelse(
        !`Activity Type` %in% c('Quality Control Sample-Lab Duplicate', 'Quality Control Sample-Lab Duplicate 2', 'Quality Control Sample-Lab Blank', 'Quality Control Sample-Lab Spike', 'Quality Control Field Calibration Check'), 
        `Monitoring Location ID`, 
        NA_character_
        ), 
      moniaid = ifelse(is.na(`Monitoring Location ID`), '', `Monitoring Location ID`),
      dateaid = gsub('-', '', as.character(lubridate::ymd(`Activity Start Date`))),
      timeaid = gsub(':', '', as.character(`Activity Start Time`)),
      actyaid = dplyr::case_when(
        `Activity Type` == 'Sample-Routine' ~ 'SR',
        `Activity Type` == 'Field Msr/Obs' ~ 'FM',
        `Activity Type` == 'Quality Control Sample-Lab Duplicate' ~ 'LD',
        `Activity Type` == 'Quality Control Field Replicate Msr/Obs' ~ 'FM2',
        `Activity Type` == 'Quality Control Sample-Field Replicate' ~ 'SR2',
        `Activity Type` == 'Quality Control Sample-Lab Duplicate 2' ~ 'LD2',
        `Activity Type` == 'Quality Control Sample-Lab Spike' ~ 'LS',
        `Activity Type` == 'Quality Control Sample-Reference Sample' ~ 'LSR',
        `Activity Type` == 'Quality Control Field Calibration Check' ~ 'CC',
        `Activity Type` == 'Quality Control Sample-Measurement Precision Sample' ~ 'CCR',
        T ~ ''
      ),
      deptaid = ifelse(is.na(`Activity Depth/Height Measure`), `Activity Relative Depth Name`, round(as.numeric(`Activity Depth/Height Measure`), 2)), 
      deptaid = ifelse(is.na(deptaid), '', deptaid)
    ) %>%
    tidyr::unite('Activity ID', moniaid, dateaid, timeaid, actyaid, deptaid, sep = ':', remove = T)

  # add remaining columns that depend only on results file
  resu <- resu %>% 
    # dplyr::left_join(wqxdat, by = 'WQX Parameter') %>%
    dplyr::mutate(
      `Project ID` = ifelse(is.na(`Project ID`), 'Water Quality', `Project ID`),
      `Activity Media Name` = 'Water',
      `Activity Start Time Zone` = 'EDT',
      `Activity Depth/Height Measure` = ifelse(is.na(`Activity Relative Depth Name`), `Activity Depth/Height Measure`, NA), 
      `Activity Depth/Height Unit` = ifelse(is.na(`Activity Relative Depth Name`), `Activity Depth/Height Unit`, NA), 
      `Sample Collection Method ID` = dplyr::case_when(
        `Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate') & !is.na(`Sample Collection Method ID`) ~ `Sample Collection Method ID`,
        `Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate') & is.na(`Sample Collection Method ID`) ~ 'Grab', 
        T ~ NA_character_
      ),
      `Sample Collection Equipment Name` = ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate'), 'Water Bottle', NA_character_), 
      `Characteristic Name User Supplied` = `Characteristic Name`,
      `Result Detection Condition` = dplyr::case_when(
        `Result Value` == 'BDL' ~ 'Not Detected',
        `Result Value` == 'AQL' ~ 'Present Above Quantitation Limit', 
        T ~ NA_character_
      ),
      `Result Status ID` = 'Final', 
      `Result Value Type` = 'Actual', 
      `Result Detection/Quantitation Limit Type` = dplyr::case_when(
        `Result Value` == 'BDL' ~ 'Method Detection Level',
        `Result Value` == 'AQL' ~ 'Upper Quantitation Limit', 
        T ~ NA_character_
      ),
      `Result Unit` = dplyr::case_when(
        `Characteristic Name` == 'pH' ~ 'blank', 
        `Characteristic Name` == 'Salinity' ~ 'ppth', 
        T ~ `Result Unit`
      ),
      `Result Detection/Quantitation Limit Unit` = ifelse(
        `Result Value` %in% c('BDL', 'AQL'), 
        `Result Unit`,
        NA_character_
      ),
      `Result Unit` = dplyr::case_when(
        `Result Value` %in% c('BDL', 'AQL') ~ NA_character_,
        T ~ `Result Unit`
      )
    )
  
  # add quantitation limit from dqo accuracy file
  
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')

  # combining with dqo acc requires multiple filters
  # first 1 to many left_join
  # then filter values where the accuracy values are binary (above below)
  # then filter values where the accuracy values are many (a range)
  # then filter values where there is no result value but more than one dqo accuracy range
  resu <- resu %>% 
    mutate(
      ind = 1:dplyr::n()
    ) %>% 
    left_join(accdat, by = 'WQX Parameter') %>% 
    dplyr::mutate(
      `Result Value2` = dplyr::case_when(
        `Result Value` == 'AQL' ~ 'Inf', 
        `Result Value` == 'BDL' ~ '-Inf', 
        T ~ `Result Value`
      )
    ) %>% 
    tidyr::unite('flt', `Result Value2`, `Value Range`, sep = ' ', remove = FALSE) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      flt = ifelse(grepl('all|NA', flt), T, eval(parse(text = flt)))
    ) %>%
    dplyr::filter(flt) %>% 
    dplyr::group_by(ind) %>% 
    dplyr::mutate(
      `rngflt` = as.numeric(gsub(paste(colsym, collapse = '|'), '', `Value Range`))
    ) %>% 
    dplyr::filter(ifelse(is.na(rngflt), T, max(rngflt) == rngflt)) %>% 
    dplyr::ungroup() %>% 
    filter(!(duplicated(ind) & is.na(`Result Value2`))) %>% 
    dplyr::select(-ind, -`Value Range`, -`Result Value2`, -`rngflt`, -flt) %>% 
    dplyr::mutate(
      `Result Detection/Quantitation Limit Measure` = dplyr::case_when(
        `Result Value` == 'BDL' & is.na(`Quantitation Limit`) ~ as.character(MDL), 
        `Result Value` == 'BDL' & !is.na(`Quantitation Limit`) ~ as.character(`Quantitation Limit`), 
        `Result Value` == 'AQL' & is.na(`Quantitation Limit`) ~ as.character(UQL),
        `Result Value` == 'AQL' & !is.na(`Quantitation Limit`) ~ as.character(`Quantitation Limit`),
        T ~ NA_character_
      )
    )

  # add columns from wqx meta
  resu <- resu %>% 
    left_join(wqxdat, by = c('Characteristic Name' = 'Parameter')) %>% 
    dplyr::mutate(
      `Sample Collection Method Context` = ifelse(!is.na(`Sample Collection Method ID`), `Sampling Method Context`, NA_character_),
      `Sample Collection Method Context` = ifelse(`Sample Collection Method ID` == 'Grab', 'MassWateR', `Sample Collection Method Context`),
      `Result Sample Fraction` = ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate', 'Quality Control Field Replicate Msr/Obs'),
                                        `Result Sample Fraction`, 
                                        NA_character_
                                        ), 
      `Result Analytical Method ID` = ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Lab Duplicate', 'Quality Control Sample-Lab Duplicate 2', 'Quality Control Sample-Lab Spike', 'Quality Control Sample-Reference Sample'),
                                               `Analytical Method`, 
                                               NA_character_
                                             ),
      `Result Analytical Method Context` = ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Lab Duplicate', 'Quality Control Sample-Lab Duplicate 2', 'Quality Control Sample-Lab Spike', 'Quality Control Sample-Reference Sample'),
                                                  `Analytical Method Context`, 
                                                  NA_character_
                                                  )
    )
  
  # final row selection for results
  # characeristic name and result value must be done last
  resu <- resu %>%
    dplyr::mutate(
      `Characteristic Name` = `WQX Parameter`, 
      `Result Value` = dplyr::case_when(
        `Result Value` %in% c('BDL', 'AQL') ~ NA_character_,
        T ~ `Result Value`
      )
    ) %>% 
    dplyr::select(
      `Project ID`,
      `Monitoring Location ID`,
      `Activity ID`,
      `Activity Type`,
      `Activity Media Name`,
      `Activity Start Date`,
      `Activity Start Time`,
      `Activity Start Time Zone`,
      `Activity Depth/Height Measure`,
      `Activity Depth/Height Unit`,
      `Activity Relative Depth Name`,
      `Sample Collection Method ID`,
      `Sample Collection Method Context`,
      `Sample Collection Equipment Name`,
      `Characteristic Name`,
      `Characteristic Name User Supplied`,
      `Method Speciation`,
      `Result Detection Condition`,
      `Result Value`,
      `Result Unit`,
      `Result Measure Qualifier`,
      `Result Sample Fraction`,
      `Result Status ID`,
      `Result Value Type`,
      `Result Analytical Method ID`,
      `Result Analytical Method Context`,
      `Result Detection/Quantitation Limit Type`,
      `Result Detection/Quantitation Limit Measure`,
      `Result Detection/Quantitation Limit Unit`,
      `Result Comment`
    )
  
  ##
  # save output
  
  # default output directory is working directory
  if(is.null(output_dir))
    output_dir <- getwd()
  
  if(is.null(output_file))
    output_file <- 'wqxtab.xlsx'
  
  out <- list(
    Projects = prjs,
    Locations = locs,
    Results = resu
  )
  
  # save
  writexl::write_xlsx(out, path = file.path(output_dir, output_file))
  
  file_loc <- list.files(path = output_dir, pattern = output_file, full.names = TRUE)
  msg <- paste("Excel workbook created successfully! File located at", file_loc)
  message(msg)
  
}
