#' Check water quality monitoring results
#'
#' @param dat input data frame
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
#'  \item{Characteristic Name: }{Should be one of air temperature, water temperature, TP, TSS, DO % saturation, DO concentration, flow, gage, pH, sp conductivity, NH3, NO3, orthoP, E coli, or chlorophyll a}, 
#'  \item{Result Value: }{Should be a numeric value or a text value as AQL or BDL}
#'  \item{QC Reference Value: }{Should be a numeric value or a text value as AQL or BDL}
#' }
#' 
#' @return \code{dat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @export
#'
#' @examples
#' pth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' dat <- readxl::read_excel(pth, 
#'   col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
#'              'text', 'text', 'text', 'text'))
#' check_results(dat)
check_results <- function(dat){
  
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
  chntyp <- c("air temperature", "water temperature", "TP", "TSS", "DO % saturation", 
              "DO concentration", "flow", "gage", "pH", "sp conductivity", 
              "NH3", "NO3", "orthoP", "E coli", "chlorophyll a")
  restyp <- c('AQL', 'BDL')

  # check field names
  message('\tChecking column names...')
  nms <- names(dat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop('Please correct the column names or remove: ', paste(tochk, collapse = ', '))
  }
  
  # check all fields are present, Result Attribute optional
  message('\tChecking all required columns are present...')
  nms <- names(dat)
  chk <- colnms[-14] %in% nms
  if(any(!chk)){
    tochk <- colnms[!chk]
    stop('Missing the following columns: ', paste(tochk, collapse = ', '))
  }
  
  # check activity types
  message('\tChecking valid Activity Types...')
  typ <- dat$`Activity Type`
  chk <- typ %in% acttyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tIncorrect Activity Type found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '))
  }
  
  # check date parsing
  message('\tChecking Activity Start Date formats...')
  dts <- dat$`Activity Start Date`
  if(anyNA(dts)){
    rws <- which(is.na(dts))
    stop('Check date on row(s) ', paste(rws, collapse = ', '))
  }
  
  # check time formats
  message('\tChecking Activity Start Time formats...')
  tms <- dat$`Activity Start Time`
  if(anyNA(tms)){
    rws <- which(is.na(tms))
    stop('Check time on row(s) ', paste(rws, collapse = ', '))
  }
  
  # check depth categories
  message('\tChecking Relative Depth Category formats...')
  dps <- dat$`Relative Depth Category`
  chk <- dps %in% dpstyp
  if(any(!chk)){
    rws <- which(!dps %in% dpstyp)
    tochk <- unique(dps[!chk])
    stop('Incorrect Relative Depth Category format found: ', paste(tochk, collapse = ', '), ' on row(s)', paste(rws, collapse = ', '))
  }
  
  # check characteristic names
  message('\tChecking Characteristic Name formats...')
  typ <- dat$`Characteristic Name`
  chk <- typ %in% chntyp
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tIncorrect Characteristic Name found: ', paste(tochk, collapse = ', '), ' in row(s) ', paste(rws, collapse = ', '))
  }
  
  # check result values 
  message('\tChecking Result Values...')
  typ <- dat$`Result Value`
  chk <- paste(paste0('^', restyp, '$'), collapse = '|')
  chk <- !is.na(suppressWarnings(as.numeric(typ))) | grepl(chk, typ) | is.na(typ)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tIncorrect entries in Result Value found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '))
  }

  # check QC Reference Values 
  typ <- dat$`QC Reference Value`
  chk <- paste(paste0('^', restyp, '$'), collapse = '|')
  chk <- !is.na(suppressWarnings(as.numeric(typ))) | grepl(chk, typ) | is.na(typ)
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tIncorrect entries in QC Reference Value found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '))
  }
    
  message('\nAll checks passed!')
  
  return(dat)
  
}