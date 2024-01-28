#' Check water quality monitoring results
#'
#' @param resdat input data frame for results
#' @param warn logical to return warnings to the console (default)
#'
#' @details This function is used internally within \code{\link{readMWRresults}} to run several checks on the input data for completeness and conformance to WQX requirements.
#' 
#' The following checks are made: 
#' \itemize{
#'  \item Column name spelling: Should be the following: Monitoring Location ID, Activity Type, Activity Start Date, Activity Start Time, Activity Depth/Height Measure, Activity Depth/Height Unit, Activity Relative Depth Name, Characteristic Name, Result Value, Result Unit, Quantitation Limit, QC Reference Value, Result Measure Qualifier, Result Attribute, Sample Collection Method ID, Project ID, Local Record ID, Result Comment
#'  \item Columns present: All columns from the previous check should be present
#'  \item Activity Type: Should be one of Field Msr/Obs, Sample-Routine, Quality Control Sample-Field Blank, Quality Control Sample-Lab Blank, Quality Control Sample-Lab Duplicate, Quality Control Sample-Lab Spike, Quality Control-Calibration Check, Quality Control-Meter Lab Duplicate, Quality Control-Meter Lab Blank
#'  \item Date formats: Should be mm/dd/yyyy and parsed correctly on import
#'  \item Depth data present: Depth data should be included in Activity Depth/Height Measure or Activity Relative Depth Name for all rows where Activity Type is Field Msr/Obs or Sample-Routine
#'  \item Non-numeric Activity Depth/Height Measure: All depth values should be numbers, excluding missing values
#'  \item Activity Depth/Height Unit: All entries should be \code{ft}, \code{m}, or blank
#'  \item Activity Relative Depth Name: Should be either Surface, Bottom, Midwater, Near Bottom, or blank (warning only)
#'  \item Activity Depth/Height Measure out of range: All depth values should be less than or equal to 1 meter / 3.3 feet or entered as Surface in the Activity Relative Depth Name column (warning only)
#'  \item Characteristic Name: Should match parameter names in the \code{Simple Parameter} or \code{WQX Parameter} columns of the \code{\link{paramsMWR}} data (warning only)
#'  \item Result Value: Should be a numeric value or a text value as AQL or BDL
#'  \item Non-numeric Quantitation Limit: All values should be numbers, excluding missing values
#'  \item QC Reference Value: Should be a numeric value or a text value as AQL or BDL
#'  \item Result Unit: No missing entries in \code{Result Unit}, except pH which can be blank
#'  \item Single Result Unit: Each unique parameter in \code{Characteristic Name} should have only one entry in \code{Result Unit} (excludes entries for lab spikes reported as \code{\%} or \code{\% recovery})
#'  \item Correct Result Unit: Each unique parameter in \code{Characteristic Name} should have an entry in \code{Result Unit} that matches one of the acceptable values in the \code{Units of measure} column of the \code{\link{paramsMWR}} data (excludes entries for lab spikes reported as \code{\%} or \code{\% recovery})
#' }
#' 
#' @return \code{resdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. Checks with warnings can be fixed at the discretion of the user before proceeding.
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), guess_max = Inf)) %>% 
#'   dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character)
#'              
#' checkMWRresults(resdat)
checkMWRresults <- function(resdat, warn = TRUE){
  
  message('Running checks on results data...\n')
  wrn <- 0
  
  # globals
  colnms <- c("Monitoring Location ID", "Activity Type", "Activity Start Date", 
              "Activity Start Time", "Activity Depth/Height Measure", "Activity Depth/Height Unit", 
              "Activity Relative Depth Name", "Characteristic Name", "Result Value", 
              "Result Unit", "Quantitation Limit", "QC Reference Value", "Result Measure Qualifier", 
              "Result Attribute", "Sample Collection Method ID", "Project ID", "Local Record ID", 
              "Result Comment")
  acttyp <- c("Field Msr/Obs", "Sample-Routine", "Quality Control Sample-Field Blank", 
              "Quality Control Sample-Lab Blank", "Quality Control Sample-Lab Duplicate", 
              "Quality Control Sample-Lab Spike", "Quality Control-Calibration Check", 
              "Quality Control-Meter Lab Duplicate", "Quality Control-Meter Lab Blank")
  dpstyp <- c('Surface', 'Bottom', 'Midwater', NA)
  chntyp <- sort(unique(c(paramsMWR$`Simple Parameter`, paramsMWR$`WQX Parameter`)))
  unityp <- c('ft', 'm')
  restyp <- c('AQL', 'BDL')

  # check field names
  msg <- '\tChecking column names...'
  nms <- names(resdat)
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop(msg, '\n\tPlease correct the column names or remove: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check all fields are present
  msg <- '\tChecking all required columns are present...'
  nms <- names(resdat)
  chk <- colnms %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop(msg, '\n\tMissing the following columns: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check activity types
  msg <- '\tChecking valid Activity Types...'
  typ <- resdat$`Activity Type`
  chk <- typ %in% acttyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect Activity Type found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check date parsing
  msg <- '\tChecking Activity Start Date formats...'
  dts <- resdat$`Activity Start Date`
  dts <- lubridate::ymd(dts, quiet = TRUE)
  rws <- which(is.na(dts))
  chk <- length(rws) == 0
  if(anyNA(dts)){
    stop(msg, '\n\tCheck date on row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check depth data present
  msg <- '\tChecking depth data present...'
  typ <- resdat[, c('Activity Depth/Height Measure', 'Activity Relative Depth Name')]
  rws <- rowSums(is.na(typ)) == 2 & resdat$`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine')
  chk <- !any(rws)
  if(!chk){
    rws <- which(rws)
    stop(msg, '\n\tNo data in Activity Depth/Height Measure and Activity Relative Depth Name on row(s): ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check for non-numeric depth
  msg <- '\tChecking for non-numeric values in Activity Depth/Height Measure...'
  typ <- resdat$`Activity Depth/Height Measure`
  chk <- !grepl('[[:alpha:]]', typ, ignore.case = TRUE)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tNon-numeric entries in Activity Depth/Height Measure found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # checking invalid unit entries for depth
  msg <- '\tChecking Activity Depth/Height Unit...'
  typ <- resdat$`Activity Depth/Height Unit`
  chk <- typ %in% unityp | is.na(typ)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect Activity Depth/Height Unit found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check depth categories
  msg <- '\tChecking Activity Relative Depth Name formats...'
  dps <- resdat$`Activity Relative Depth Name`
  chk <- dps %in% dpstyp
  if(any(!chk)){
    rws <- which(!dps %in% dpstyp)
    tochk <- unique(dps[!chk])
    if(warn)
      warning(msg, '\n\tIncorrect Activity Relative Depth Name format found: ', paste(tochk, collapse = ', '), ' on row(s) ', paste(rws, collapse = ', '), call. = FALSE)
    wrn <- wrn + 1
    message(paste(msg, 'WARNING'))
  } else {
    message(paste(msg, 'OK'))
  }

  # check for depth out of range
  msg <- '\tChecking values in Activity Depth/Height Measure > 1 m / 3.3 ft...'
  typ <- resdat[, c('Activity Depth/Height Measure', 'Activity Depth/Height Unit', 'Activity Relative Depth Name')]
  typsrft <- as.numeric(typ$`Activity Depth/Height Measure`) > 3.3 & typ$`Activity Depth/Height Unit` == 'ft' & is.na(typ$`Activity Relative Depth Name`)
  typsrm <- as.numeric(typ$`Activity Depth/Height Measure`) > 1 & typ$`Activity Depth/Height Unit` == 'm' & is.na(typ$`Activity Relative Depth Name`)
  typmid <- typ$`Activity Relative Depth Name` %in% 'Midwater'
  typbot <- typ$`Activity Relative Depth Name` %in% 'Bottom'
  chk <- typsrm | typsrft | typmid | typbot
  if(any(chk, na.rm = TRUE)){
    rwssrf <- unique(sort(c(which(typsrm), which(typsrft))))
    rwsmid <- which(typmid)
    rwsbot <- which(typbot)
    rwssrfmsg <- ifelse(length(rwssrf) > 0, paste0('\n\tValues in Activity Depth/Height Measure > 1 m / 3.3 ft for Surface values found on row(s): ', paste(rwssrf, collapse = ', ')), '')
    rwsmidmsg <- ifelse(length(rwsmid) > 0, paste0('\n\tMidwater values found in Activity Relative Depth Name on row(s): ', paste(rwsmid, collapse = ', ')), '')
    rwsbotmsg <- ifelse(length(rwsbot) > 0, paste0('\n\tBottom values found in Activity Relative Depth Name on row(s): ', paste(rwsbot, collapse = ', ')), '')
    rws <- paste0(rwssrfmsg, rwsmidmsg, rwsbotmsg)
    if(warn)
      warning(msg, rws, call. = FALSE)
    wrn <- wrn + 1
    message(paste(msg, 'WARNING'))
  } else {
    message(paste(msg, 'OK'))
  }
  
  # check characteristic names
  msg <- '\tChecking Characteristic Name formats...'
  typ <- resdat$`Characteristic Name`
  chk <- typ %in% chntyp
  if(any(!chk)){
    tochk <- unique(typ[!chk])
    if(warn)
      warning(msg, '\n\tCharacteristic Name not included in approved parameters: ', paste(tochk, collapse = ', '), call. = FALSE)
    wrn <- wrn + 1
    message(paste(msg, 'WARNING'))
  } else {
    message(paste(msg, 'OK'))
  }
  
  # check result values 
  msg <- '\tChecking Result Values...'
  typ <- resdat$`Result Value`
  chk <- paste(paste0('^', restyp, '$'), collapse = '|')
  chk <- !is.na(suppressWarnings(as.numeric(typ))) | grepl(chk, typ) | is.na(typ)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect entries in Result Value found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check Quantitation Limit for non-numeric (allows NA/missing)
  msg <- '\tChecking for non-numeric values in Quantitation Limit...'
  typ <- resdat$`Quantitation Limit`
  chk <- !is.na(suppressWarnings(as.numeric(typ))) | is.na(typ)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tNon-numeric entries in Quantitation Limit found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check QC Reference Values 
  msg <- '\tChecking QC Reference Values...'
  typ <- resdat$`QC Reference Value`
  chk <- paste(paste0('^', restyp, '$'), collapse = '|')
  chk <- !is.na(suppressWarnings(as.numeric(typ))) | grepl(chk, typ) | is.na(typ)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect entries in QC Reference Value found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check no missing entries in result unit, except pH
  msg <- '\tChecking for missing entries for Result Unit...'
  chk <- resdat[, c('Characteristic Name', 'Result Unit')]
  chk <- is.na(chk$`Result Unit`) & !chk$`Characteristic Name` %in% 'pH'
  chk <- !chk
  if(any(!chk)){
    rws <- which(!chk)
    stop(msg, '\n\tMissing Result Unit in rows ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check different units for each parameter
  msg <- '\tChecking if more than one unit per Characteristic Name...'
  typ <- resdat[, c('Characteristic Name', 'Result Unit', 'Activity Type')] %>% 
    dplyr::filter(!(`Activity Type` %in% 'Quality Control Sample-Lab Spike' & `Result Unit` %in% c('%', '% recovery'))) %>% 
    dplyr::select(-`Activity Type`)
  typ <- unique(typ)
  chk <- !duplicated(typ$`Characteristic Name`)
  if(any(!chk)){
    tochk <- typ[!chk, 'Characteristic Name', drop = TRUE]
    tochk <- typ[typ$`Characteristic Name` %in% tochk, ]
    tochk <- dplyr::group_by(tochk, `Characteristic Name`)
    tochk <- tidyr::nest(tochk)
    tochk$data <- lapply(tochk$data, function(x) paste(x[[1]], collapse = ', '))
    tochk <- tidyr::unnest(tochk, cols = 'data')
    tochk <- tidyr::unite(tochk, 'res', sep = ': ')[[1]]
    stop(msg, '\n\tMore than one Result Unit found for Characteristic Names: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # check acceptable units for each parameter, must check all parameter names simple or wqx in paramsMWR
  # does not check those in Characteristic Name not found in parameter names in simple or wqx in paramsMWR
  msg <- '\tChecking acceptable units for each entry in Characteristic Name...'
  typ <- resdat[, c('Characteristic Name', 'Result Unit', 'Activity Type')] %>% 
    dplyr::filter(!(`Activity Type` %in% 'Quality Control Sample-Lab Spike' & `Result Unit` %in% c('%', '% recovery'))) %>% 
    dplyr::select(-`Activity Type`)
  typ <- unique(typ)
  typ$`Result Unit`[(is.na(typ$`Result Unit`) | typ$`Result Unit` == 's.u.') & typ$`Characteristic Name` == 'pH'] <- 'blank'
  tojn <- paramsMWR[, c('Simple Parameter', 'Units of measure')]
  tojn <- dplyr::rename(tojn, `Characteristic Name` = `Simple Parameter`)
  typ <- dplyr::left_join(typ, tojn, by = 'Characteristic Name')
  tojn <- paramsMWR[, c('WQX Parameter', 'Units of measure')] # repeat for wqx parameter names
  tojn <- dplyr::rename(tojn, `Characteristic Name` = `WQX Parameter`)
  typ <- dplyr::left_join(typ, tojn, by = 'Characteristic Name')
  typ <- dplyr::filter(typ, !(is.na(`Units of measure.x`) & is.na(`Units of measure.y`)))
  typ <- dplyr::rowwise(typ)
  typ <- dplyr::mutate(typ, 
    `Units of measure` = na.omit(unique(c(`Units of measure.x`, `Units of measure.y`)))
  )
  chk <- dplyr::mutate(typ, 
    fnd = grepl(`Result Unit`, `Units of measure`, fixed = TRUE)
  )
  if(any(!chk$fnd)){
    tochk <- chk[!chk$fnd, c('Characteristic Name', 'Result Unit')]
    tochk <- tidyr::unite(tochk, 'res', sep = ': ')[[1]]
    stop(msg, '\n\tIncorrect Result Unit found for Characteristic Names: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))

  # final out message
  outmsg <- '\nAll checks passed'
  if(wrn > 0)
    outmsg <- paste0(outmsg, ' (', wrn, ' WARNING(s))')
  outmsg <- paste0(outmsg, '!')
  message(outmsg)

  return(resdat)
  
}
