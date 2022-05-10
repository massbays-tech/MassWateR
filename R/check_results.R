#' Check water quality monitoring results
#'
#' @param resdat input data frame for results
#'
#' @details This function is used internally within \code{\link{read_results}} to run several checks on the input data for completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Monitoring Location ID, Activity Type, Activity Start Date, Activity Start Time, Activity Depth/Height Measure, Activity Depth/Height Unit, Relative Depth Category, Characteristic Name, Result Value, Result Unit, Quantitation Limit, QC Reference Value, Result Measure Qualifier, Result Attribute.}
#'  \item{Columns present: }{All columns from the previous check should be present, Result Attribute is optional}
#'  \item{Activity Type: }{Should be one of Field Msr/Obs, Sample-Routine, Quality Control Sample-Field Blank, Quality Control Sample-Lab Blank, Quality Control Sample-Lab Duplicate, Quality Control Sample-Lab Spike}
#'  \item{Date formats: }{Should be mm/dd/yyyy and parsed correctly on import}
#'  \item{Time formats: }{Should be HH:MM and parsed correctly on import}
#'  \item{Relative Depth Category: }{Should be either Surface, Bottom, < 1m / 3.3ft or blank}
#'  \item{Characteristic Name: }{Should match parameter names in the \code{Simple Parameter} column of the \code{\link{params}} data, specifically Air Temp, Ammonia, Ammonium, Chl a, Chl a (probe), Chloride, Conductivity, Cyanobacteria (lab), Cyanobacteria (probe), Depth, DO, DO saturation, E.coli, Enterococcus, Fecal Coliform, Flow, Gage, Metals, Microcystins, Nitrate, Nitrate + Nitrite, Nitrite, Ortho P, pH, Pheophytin, Phosphate, PON, POP, Salinity, Secchi Depth, Silicate, Sp Conductance, Sulfate, Surfactants, TDS, TKN, TN, TP, TSS, Turbidity, or Water Temp}, 
#'  \item{Result Value: }{Should be a numeric value or a text value as AQL or BDL}
#'  \item{QC Reference Value: }{Should be a numeric value or a text value as AQL or BDL}
#'  \item{Result Unit: }{No missing entries in \code{Result Unit}, except pH which can be blank}
#'  \item{Single Result Unit: }{Each unique parameter in \code{Characteristic Name} should have only one entry in \code{Result Unit}}
#'  \item{Correct Result Unit: }{Each unique parameter in \code{Characteristic Name} should have an entry in \code{Result Unit} that matches one of the acceptable values in the \code{Units of measure} column of the \code{\link{params}} data}
#' }
#' 
#' @return \code{resdat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' resdat <- readxl::read_excel(respth, 
#'   col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
#'              'text', 'text', 'text', 'text'))
#'              
#' check_results(resdat)
check_results <- function(resdat){
  
  message('Running checks on results data...\n')
  
  # globals
  colnms <- c("Monitoring Location ID", "Activity Type", "Activity Start Date", 
              "Activity Start Time", "Activity Depth/Height Measure", "Activity Depth/Height Unit", 
              "Relative Depth Category", "Characteristic Name", "Result Value", 
              "Result Unit", "Quantitation Limit", "QC Reference Value", "Result Measure Qualifier", 
              "Result Attribute")
  acttyp <- c("Field Msr/Obs", "Sample-Routine", "Quality Control Sample-Field Blank", 
              "Quality Control Sample-Lab Blank", "Quality Control Sample-Lab Duplicate", 
              "Quality Control Sample-Lab Spike")
  dpstyp <- c('Surface', 'Bottom', '< 1m / 3.3ft', NA)
  chntyp <- sort(params$`Simple Parameter`)
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
  
  # check all fields are present, Result Attribute optional
  msg <- '\tChecking all required columns are present...'
  nms <- names(resdat)
  chk <- colnms[-14] %in% nms
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
  if(anyNA(dts)){
    rws <- which(is.na(dts))
    stop(msg, '\n\tCheck date on row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check time formats
  msg <- '\tChecking Activity Start Time formats...'
  tms <- resdat$`Activity Start Time`
  if(anyNA(tms)){
    rws <- which(is.na(tms))
    stop(msg, '\n\tCheck time on row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check depth categories
  msg <- '\tChecking Relative Depth Category formats...'
  dps <- resdat$`Relative Depth Category`
  chk <- dps %in% dpstyp
  if(any(!chk)){
    rws <- which(!dps %in% dpstyp)
    tochk <- unique(dps[!chk])
    stop(msg, '\n\tIncorrect Relative Depth Category format found: ', paste(tochk, collapse = ', '), ' on row(s)', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
  # check characteristic names
  msg <- '\tChecking Characteristic Name formats...'
  typ <- resdat$`Characteristic Name`
  chk <- typ %in% chntyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop(msg, '\n\tIncorrect Characteristic Name found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '), call. = FALSE)
  }
  message(paste(msg, 'OK'))
  
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
  typ <- resdat[, c('Characteristic Name', 'Result Unit')]
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

  # check acceptable units for each parameter
  msg <- '\tChecking acceptable units for each entry in Characteristic Name...'
  typ <- resdat[, c('Characteristic Name', 'Result Unit')]
  typ <- unique(typ)
  typ$`Result Unit`[is.na(typ$`Result Unit`) & typ$`Characteristic Name` == 'pH'] <- 'NA'
  tojn <- params[, c('Simple Parameter', 'Units of measure')]
  tojn <- dplyr::rename(tojn, `Characteristic Name` = `Simple Parameter`)
  typ <- dplyr::left_join(typ, tojn, by = 'Characteristic Name')
  chk <- dplyr::rowwise(typ)
  chk <- dplyr::mutate(chk, 
    fnd = grepl(`Result Unit`, `Units of measure`, fixed = TRUE)
  )
  if(any(!chk$fnd)){
    tochk <- chk[!chk$fnd, c('Characteristic Name', 'Result Unit')]
    tochk <- tidyr::unite(tochk, 'res', sep = ': ')[[1]]
    stop(msg, '\n\tIncorrect Result Unit found for Characteristic Names: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  
  message('\nAll checks passed!')

  return(resdat)
  
}