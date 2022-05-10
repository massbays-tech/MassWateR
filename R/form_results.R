#' Format water quality monitoring results
#'
#' @param resdat input data frame for results
#' @param tzone character string for time zone
#'
#' @details This function is used internally within \code{\link{read_results}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Fix date and time inputs: }{Activity Start Date is converted to YYYY-MM-DD as a date object, Actvity Start Time is convered to HH:MM as a character to fix artifacts from Excel import},
#'   \item{Create duplicate rows for entries in QC Reference Value: }{This is done if a value is found in the QC Reference Value column by creating a "new" row with the same location, date, time, etc as the original but with an appropriate quality control entry for the Activity Type}
#'   \item{Remove non-text or math symbols and other minor formatting for Result Unit: }{For conformance to WQX, e.g., the degree symbols for degrees C/F is changed to "deg", ppt is changed to ppth, s.u. is changed to NA}
#' }
#' 
#' @import dplyr
#' @import tidyr
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' resdat <- readxl::read_excel(respth, 
#'   col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
#'              'text', 'text', 'text', 'text'))
#' form_results(resdat)
form_results <- function(resdat, tzone = 'America/Jamaica'){
  
  # format input
  out <- resdat %>% 
    mutate(
      `Activity Start Date` = lubridate::force_tz(`Activity Start Date`, tzone = tzone), 
      `Activity Start Date` = lubridate::ymd(`Activity Start Date`),
      `Activity Start Time` = gsub('^.*\\s', '', as.character(`Activity Start Time`)),
      `Activity Start Time` = gsub(':00$', '', `Activity Start Time`)
    )

  # create quality control rows found in QC Reference Value
  qrws <- out %>% 
    filter(!is.na(`QC Reference Value`)) %>% 
    mutate(
      `Result Value` = `QC Reference Value`, 
      `Activity Type` = case_when(
        `Activity Type` == 'Field Msr/Obs' ~ 'Quality Control Field Replicate Msr/Obs', 
        `Activity Type` == 'Sample-Routine' ~ 'Quality Control Sample-Field Replicate', 
        `Activity Type` == 'Quality Control Sample-Field Blank' ~ NA_character_, 
        `Activity Type` == 'Quality Control Sample-Lab Duplicate' ~ 'Quality Control Sample-Lab Duplicate', 
        `Activity Type` == 'Quality Control Sample-Lab Blank' ~ NA_character_, 
        `Activity Type` == 'Quality Control Sample-Lab Spike' ~ 'Quality Control Sample-Reference Sample' 
      ),
      `QC Reference Value` = gsub('[[:digit:]]+', NA_character_, `QC Reference Value`)
    )
  
  # append new quality control rows, remove values in QC Reference Value
  out <- out %>% 
    mutate(
      `QC Reference Value` = NA_character_
    ) %>% 
    bind_rows(qrws) 
  
  # remove weird symbols from Result Unit and strip trailing/leading white space
  out <- out %>% 
    mutate(
      `Result Unit` = gsub('\\p{So}', 'deg', `Result Unit`, perl = TRUE), 
      `Result Unit` = trimws(`Result Unit`),
      `Result Unit` = gsub('^ppt$', 'ppt', `Result Unit`) ,
      `Result Unit` = case_when(
        `Characteristic Name` == 'pH' & `Result Unit` == 's.u.' ~ NA_character_, 
        T ~ `Result Unit`
      )
    )
  
  return(out)
  
}