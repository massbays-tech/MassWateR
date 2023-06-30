#' Create and save tables in a single workbook for WQX upload
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param sit character string of path to the site metadata file or \code{data.frame} for site metadata returned by \code{\link{readMWRsites}}
#' @param wqx character string of path to the wqx metadata file or \code{data.frame} for wqx metadata returned by \code{\link{readMWRwqx}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param output_dir character string of the output directory for the results
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
#' @return An Excel workbook named \code{wqxtab.xlsx} (or name passed to \code{output_file}) will be saved in the directory specified by \code{output_dir}. The workbook will include three sheets names "Projects", "Locations", and "Results".
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
#' 
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
#' # create workbook
#' tabMWRwqx(res = resdat, acc = accdat, sit = sitdat, wqx = wqxdat, output_dir = tempdir())
tabMWRwqx <- function(res = NULL, acc = NULL, sit = NULL, wqx = NULL, fset = NULL, output_dir, output_file = NULL, warn = TRUE, runchk = TRUE){
  
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
  
  # warning or stop if missing lat/lon or no lat/lon
  naloc <- is.na(locs$`Monitoring Location Longitude (-DDD.DDDD)`) | is.na(locs$`Monitoring Location Latitude (DD.DDDD)`)
  chk <- any(naloc)
  
  if(chk & warn){
    
    msg <- locs[naloc, ] %>% 
      dplyr::pull(`Monitoring Location ID`) %>% 
      sort
    
    warning('No spatial information for sites in the Locations tab: ', paste(msg, collapse = ', '))
    
  }
  
  ##
  # Results
  
  # format parameter in accdat to wqx parameter
  accdat <- accdat %>% 
    dplyr::mutate(
      `WQX Parameter` = ifelse(
        Parameter %in% paramsMWR$`Simple Parameter`, 
        paramsMWR$`WQX Parameter`[match(Parameter, paramsMWR$`Simple Parameter`)], 
        Parameter
      )
    ) %>% 
    dplyr::select(`WQX Parameter`, MDL, UQL, `Value Range`)

  # format characteristic name in resdat to wqx parameter
  resu <- resdat %>% 
    dplyr::mutate(
      `WQX Parameter` = ifelse(
        `Characteristic Name` %in% paramsMWR$`Simple Parameter`, 
        paramsMWR$`WQX Parameter`[match(`Characteristic Name`, paramsMWR$`Simple Parameter`)], 
        `Characteristic Name`
      )
    )
  
  # create quality control rows where QC Reference Value is not NA, only if qc ref values present
  qcref <- any(!is.na(resu$`QC Reference Value`))
  if(qcref){
    
    # qc rows
    qrws <- resu %>%
      filter(!is.na(`QC Reference Value`)) %>%
      mutate(
        `Result Value` = `QC Reference Value`,
        `Activity Type` = ifelse(`Activity Type` == 'Field Msr/Obs', 'Quality Control Field Replicate Msr/Obs',
          ifelse(`Activity Type` == 'Sample-Routine', 'Quality Control Sample-Field Replicate',
            ifelse(`Activity Type` == 'Quality Control Sample-Field Blank', NA_character_, # to remove
              ifelse(`Activity Type` == 'Quality Control Sample-Lab Blank', NA_character_, # to remove
                ifelse(`Activity Type` == 'Quality Control Sample-Lab Duplicate', 'Quality Control Sample-Lab Duplicate 2',
                  ifelse(`Activity Type` == 'Quality Control Sample-Lab Spike', 'Quality Control Sample-Lab Spike Target',
                    ifelse(`Activity Type` == 'Quality Control-Calibration Check', 'Quality Control-Calibration Check Buffer', 
                      ifelse(`Activity Type` == 'Quality Control-Meter Lab Duplicate', 'Quality Control-Meter Lab Duplicate 2', 
                        ifelse(`Activity Type` == 'Quality Control-Meter Lab Blank', NA_character_, # to remove, 
                          NA_character_
                        )
                      )
                    )
                  )
                )
              )
            )
          )
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

  }

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
      `Quantitation Limit`,
      `Record ID User Supplied` = `Local Record ID`,
      ) %>% 
    dplyr::group_by(`Activity Start Date`, `Characteristic Name`, `Activity Type`) %>% 
    dplyr::mutate(
      actstrtm = ifelse(
        !`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine') & is.na(`Activity Start Time`), 1,
        NA_real_
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
        !`Activity Type` %in% c('Quality Control Sample-Lab Duplicate', 'Quality Control-Meter Lab Duplicate', 'Quality Control Sample-Lab Duplicate 2', 'Quality Control Sample-Lab Blank', 'Quality Control-Meter Lab Blank', 'Quality Control Sample-Lab Spike', 'Quality Control-Calibration Check'), 
        `Monitoring Location ID`, 
        NA_character_
        ), 
      moniaid = ifelse(is.na(`Monitoring Location ID`), '', `Monitoring Location ID`),
      dateaid = gsub('-', '', as.character(lubridate::ymd(`Activity Start Date`))),
      timeaid = gsub(':', '', as.character(`Activity Start Time`)),
      deptaid = ifelse(is.na(`Activity Depth/Height Measure`), `Activity Relative Depth Name`, round(as.numeric(`Activity Depth/Height Measure`), 2)), 
      deptaid = ifelse(is.na(deptaid), '', deptaid),
      actyaid = ifelse(`Activity Type` == 'Sample-Routine', 'SR',
        ifelse(`Activity Type` == 'Field Msr/Obs', 'FM',
          ifelse(`Activity Type` == 'Quality Control Sample-Field Replicate', 'SR2',
            ifelse(`Activity Type` == 'Quality Control Field Replicate Msr/Obs', 'FM2',
              ifelse(`Activity Type` == 'Quality Control Sample-Lab Duplicate', 'LD',
                ifelse(`Activity Type` == 'Quality Control Sample-Lab Duplicate 2', 'LD2',
                  ifelse(`Activity Type` == 'Quality Control Sample-Lab Spike', 'LS',
                    ifelse(`Activity Type` == 'Quality Control Sample-Lab Spike Target', 'LS2',
                      ifelse(`Activity Type` == 'Quality Control-Calibration Check', 'CC',
                        ifelse(`Activity Type` == 'Quality Control-Calibration Check Buffer', 'CC2',
                          ifelse(`Activity Type` == 'Quality Control Sample-Field Blank', 'FB',
                            ifelse(`Activity Type` == 'Quality Control Sample-Lab Blank', 'LB',
                              ifelse(`Activity Type` == 'Quality Control-Meter Lab Duplicate', 'MLD',
                                ifelse(`Activity Type` == 'Quality Control-Meter Lab Duplicate 2', 'MLD2',
                                  ifelse(`Activity Type` == 'Quality Control-Meter Lab Blank', 'MLB',
                                    ''
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    ) %>%
    tidyr::unite('Activity ID', moniaid, dateaid, timeaid, deptaid, actyaid, sep = ':', remove = T)

  # add remaining columns that depend only on results file
  resu <- resu %>% 
    # dplyr::left_join(wqxdat, by = 'WQX Parameter') %>%
    dplyr::mutate(
      `Project ID` = ifelse(is.na(`Project ID`), 'Water Quality', `Project ID`),
      `Activity Media Name` = 'Water',
      `Activity Start Time Zone` = 'EDT',
      `Activity Depth/Height Measure` = ifelse(is.na(`Activity Relative Depth Name`), `Activity Depth/Height Measure`, NA), 
      `Activity Depth/Height Unit` = ifelse(is.na(`Activity Relative Depth Name`), `Activity Depth/Height Unit`, NA), 
      `Sample Collection Method ID` = ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate') & !is.na(`Sample Collection Method ID`), `Sample Collection Method ID`,
        ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate') & is.na(`Sample Collection Method ID`), 'Grab-MassWateR', 
          NA_character_
        )
      ),
      `Sample Collection Equipment Name` = ifelse(`Activity Type` %in% c('Sample-Routine', 'Quality Control Sample-Field Blank', 'Quality Control Sample-Field Replicate'), 'Water Bottle', NA_character_), 
      `Characteristic Name User Supplied` = `Characteristic Name`,
      `Result Detection Condition` = ifelse(`Result Value` == 'BDL', 'Not Detected',
        ifelse(`Result Value` == 'AQL', 'Present Above Quantitation Limit', 
          NA_character_
        )
      ),
      `Result Status ID` = 'Final', 
      `Result Value Type` = 'Actual', 
      `Result Detection/Quantitation Limit Type` = ifelse(`Result Value` == 'BDL', 'Method Detection Level',
        ifelse(`Result Value` == 'AQL', 'Upper Quantitation Limit', 
          NA_character_
        )
      ),
      `Result Unit` = ifelse(`Characteristic Name` == 'pH', 'None',
        ifelse(`Characteristic Name` == 'Salinity', 'ppth', 
          `Result Unit`
        )
      ),
      `Result Detection/Quantitation Limit Unit` = ifelse(
        `Result Value` %in% c('BDL', 'AQL'), 
        `Result Unit`,
        NA_character_
      ),
      `Result Unit` = ifelse(`Result Value` %in% c('BDL', 'AQL'), NA_character_,
        `Result Unit`
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
      `Result Value2` = ifelse(`Result Value` == 'AQL', 'Inf', 
        ifelse(`Result Value` == 'BDL', '-Inf', 
          `Result Value`
        )
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
      `Result Detection/Quantitation Limit Value` = ifelse(`Result Value` == 'BDL' & is.na(`Quantitation Limit`), as.character(MDL),
        ifelse(`Result Value` == 'BDL' & !is.na(`Quantitation Limit`), as.character(`Quantitation Limit`),
          ifelse(`Result Value` == 'AQL' & is.na(`Quantitation Limit`), as.character(UQL),
            ifelse(`Result Value` == 'AQL' & !is.na(`Quantitation Limit`), as.character(`Quantitation Limit`),
              NA_character_
            )
          )
        )
      )
    )

  # check if BDL and AQL in result value and no MDL or UQL if quantitation limit is na
  chk <- (resu$`Result Value` == 'BDL' & is.na(resu$`Quantitation Limit`) & is.na(resu$MDL)) |
    (resu$`Result Value` == 'AQL' & is.na(resu$`Quantitation Limit`) & is.na(resu$UQL))
  if(any(chk) & warn){
    rows <- which(chk)
    warning(paste('Empty entries for Result Detection/Quantitation Limit Value from missing MDL or UQL in accuracy file, rows:', paste(rows, collapse = ', ')))
  }
  
  # add columns from wqx meta
  resu <- resu %>% 
    left_join(wqxdat, by = c('Characteristic Name' = 'Parameter')) %>% 
    dplyr::mutate(
      `Sample Collection Method Context` = ifelse(!is.na(`Sample Collection Method ID`), `Sampling Method Context`, NA_character_),
      `Sample Collection Method Context` = ifelse(`Sample Collection Method ID` == 'Grab-MassWateR', 'MassWateR', `Sample Collection Method Context`),
      `Result Sample Fraction` = `Result Sample Fraction`, 
      `Result Analytical Method ID` = `Analytical Method`, 
      `Result Analytical Method Context` = `Analytical Method Context`
    )
  
  # final row selection for results
  # characeristic name and result value must be done last
  resu <- resu %>%
    dplyr::mutate(
      `Characteristic Name` = `WQX Parameter`, 
      `Result Value` = ifelse(`Result Value` %in% c('BDL', 'AQL'), NA_character_,
        `Result Value`
      )
    ) %>% 
    dplyr::select(
      `Project ID`,
      `Monitoring Location ID`,
      `Activity ID`,
      `Record ID User Supplied`,
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
      `Result Detection/Quantitation Limit Value`,
      `Result Detection/Quantitation Limit Unit`,
      `Result Comment`
    )
  
  ##
  # save output
  
  if(is.null(output_file))
    output_file <- 'wqxtab.xlsx'
  
  out <- list(
    Projects = prjs,
    Locations = locs,
    Results = resu
  )
  
  # save
  output_file <- paste0(tools::file_path_sans_ext(output_file), '.xlsx')
  writexl::write_xlsx(out, path = file.path(output_dir, output_file))

  file_loc <- list.files(path = output_dir, pattern = paste0('^', output_file), full.names = TRUE)
  msg <- paste("Excel workbook created successfully! File located at", file_loc)
  message(msg)
  
}
