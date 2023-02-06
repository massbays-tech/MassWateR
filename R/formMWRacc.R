#' Format data quality objective accuracy data
#'
#' @param accdat input data fram
#'
#' @details This function is used internally within \code{\link{readMWRacc}} to format the input data for downstream analysis.  The formatting includes:
#' 
#' \itemize{
#'   \item{Minor formatting for units: }{For conformance to WQX, e.g., ppt is changed to ppth, s.u. is changed to NA in \code{uom}}
#'   \item{Convert Parameter: }{All parameters are converted to \code{Simple Parameter} in \code{\link{paramsMWR}} as needed}
#'   \item{Remove unicode: }{Remove or replace unicode characters with those that can be used in logical expressions in \code{\link{qcMWRacc}}, e.g., replace \eqn{\geq} with \eqn{>=}}
#' }
#' 
#' @return A formatted data frame of the data quality objectives file for accuracy
#' 
#' @export
#'
#' @examples
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' accdat <- readxl::read_excel(accpth, na = c('NA', 'na', '')) 
#' 
#' formMWRacc(accdat)
formMWRacc <- function(accdat){
  
  # convert ph s.u. to NA, salinity ppt to ppth 
  out <- accdat %>% 
    dplyr::mutate(
      uom = trimws(uom),
      uom = gsub('^ppt$', 'ppth', uom),
      uom = ifelse(Parameter == 'pH' & uom == 's.u.', NA_character_, uom)
    )

  # convert all parameters to simple
  out <- out %>% 
    dplyr::mutate( 
      `Parameter` = ifelse(
        `Parameter` %in% paramsMWR$`WQX Parameter`, 
        paramsMWR$`Simple Parameter`[match(`Parameter`, paramsMWR$`WQX Parameter`)], 
        `Parameter`
      )
    ) %>% 
    dplyr::mutate_at(vars(-Parameter, -uom, -MDL, -UQL), function(x) gsub('\u00b1', '', x)) %>%
    dplyr::mutate_at(vars(-Parameter, -uom, -MDL, -UQL), function(x) gsub('\u2264', '<=', x)) %>%
    dplyr::mutate_at(vars(-Parameter, -uom, -MDL, -UQL), function(x) gsub('\u2265', '>=', x))
  
  return(out)
  
}
