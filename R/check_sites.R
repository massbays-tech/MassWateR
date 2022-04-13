#' Check site metadata file
#'
#' @param dat input data frame
#'
#' @details This function is used internally within \code{\link{read_sites}} to run several checks on the input data for completeness and conformance to WQX requirements
#' 
#' The following checks are made: 
#' \itemize{
#'  \item{Column name spelling: }{Should be the following: Monitoring Location ID, Monitoring Location Name, Monitoring Location Latitude, Monitoring Location Longitude, Location Group}
#'  \item{Missing longitude or latitude: }{No missing entries in Monitoring Location Latitude or Monitoring Location Longitude}
#'  \item{Non-numeric latitude values: }{Values entered in Monitoring Location Latitude must be numeric}
#'  \item{Non-numeric longitude values: }{Values entered in Monitoring Location Longitude must be numeric}
#'  \item{Positive longitude values: }{Values in Monitoring Location Longitude must be negative}
#'  \item{Missing Location ID: }{No missing entries for Monitoring Location ID}
#' }
#' 
#' @return \code{dat} is returned as is if no errors are found, otherwise an informative error message is returned prompting the user to make the required correction to the raw data before proceeding. 
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' pth <- system.file('extdata/ExampleSites_final.xlsx', package = 'MassWateR')
#' 
#' dat <- readxl::read_excel(pth, na = c('na', ''))
#'     
#' check_sites(dat)
check_sites <- function(dat){
  
  message('Running checks on site metadata...\n')

  # globals
  colnms <- c("Monitoring Location ID", "Monitoring Location Name", "Monitoring Location Latitude", 
              "Monitoring Location Longitude", "Location Group")
  
  # check field names
  message('\tChecking column names...')
  nms <- names(dat) 
  chk <- nms %in% colnms
  if(any(!chk)){
    tochk <- nms[!chk]
    stop('Please correct the column names: ', paste(tochk, collapse = ', '))
  }

  # checking for missing lat/lon
  message('\tChecking for missing latitude or longitude values...')
  chk <- dat %>% 
    dplyr::select(`Monitoring Location Latitude`, `Monitoring Location Longitude`) %>% 
    apply(1, function(x) !anyNA(x))
  if(any(!chk)){
    rws <- which(!chk)
    stop('\tMissing latitude or longitude in rows ', paste(rws, collapse = ', '))
  }
  
  # check for non-numeric latitude
  message('\tChecking for non-numeric values in latitude...')
  typ <- dat$`Monitoring Location Latitude`
  chk <- !is.na(suppressWarnings(as.numeric(typ)))
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tNon-numeric entries in Monitoring Location Latitude found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '))
  }
  
  # check for non-numeric longitude
  message('\tChecking for non-numeric values in longitude...')
  typ <- dat$`Monitoring Location Longitude`
  chk <- !is.na(suppressWarnings(as.numeric(typ)))
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tNon-numeric entries in Monitoring Location Longitude found: ', paste(tochk, collapse = ', '), ' in rows ', paste(rws, collapse = ', '))
  }
  
  # positive values in lon
  message('\tChecking for positive values in longitude...')
  typ <- dat$`Monitoring Location Longitude`
  chk <- typ <= 0
  if(any(!chk)){
    rws <- which(!chk)
    tochk <- unique(typ[!chk])
    stop('\tPositive Monitoring Location Longitude found in rows ', paste(rws, collapse = ', '))
  }
  
  # missing location id
  message('\tChecking for missing entries for Monitoring Location ID...')
  chk <- dat$`Monitoring Location ID`
  chk <- !is.na(chk)
  if(any(!chk)){
    rws <- which(!chk)
    stop('\tMissing Monitoring Location ID in rows ', paste(rws, collapse = ', '))
  }
  
  message('\nAll checks passed!')
  
  return(dat)
  
}
