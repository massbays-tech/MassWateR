#' Fill results data as BDL or AQL with appropriate values
#'
#' @param resdat results data as returned by \code{\link{readMWRresults}}
#' @param accdat \code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}
#' @param param character string to first filter results by a parameter in \code{"Characteristic Name"}
#' @param warn logical to return warnings to the console (default)
#'
#' @return \code{resdat} with any entries in \code{"Result Value"} as \code{"BDL"} or \code{"AQL"} replaced with appropriate values in the \code{"Quantitation Limit"} column, if present, otherwise the \code{"MDL"} or \code{"UQL"} columns from the data quality objectives file for accuracy are used.  Values as \code{"BDL"} use one half of the appropriate limit.
#' @export
#'
#' @examples
#' # results file path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' # apply to total phosphorus
#' utilMWRlimits(resdat, accdat, param = 'TP')
#' 
#' # apply to E.coli
#' utilMWRlimits(resdat, accdat, param = 'E.coli')
utilMWRlimits <- function(resdat, param, accdat, warn = TRUE){
  
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')
    
  # check if parameter in accdat, warn if TRUE, then convert to numeric and exit
  chk <- !param %in% accdat$Parameter
  if(chk){
    
    if(warn)
      warning(param, ' in results not found in quality control objectives for accuracy', call. = FALSE)
  
    out <- resdat %>% 
      dplyr::mutate(
        `Result Value` = suppressWarnings(as.numeric(`Result Value`))
      ) %>% 
      dplyr::filter(!is.na(`Result Value`))
    
    return(out)
    
  }
  
  # check units in resdat match those in accuracy file
  accuni <- accdat %>% 
    dplyr::filter(Parameter %in% param) %>% 
    dplyr::select(
      `Characteristic Name` = Parameter, 
      `uom`
    ) %>% 
    unique
  resdatuni <- unique(resdat[, c('Characteristic Name', 'Result Unit')])
  jndat <- inner_join(resdatuni, accuni, by = 'Characteristic Name') %>% 
    dplyr::mutate(
      `Result Unit` = ifelse(is.na(`Result Unit`), 'blank', `Result Unit`),
      uom = ifelse(is.na(uom), 'blank', uom)
    )
  chk <- jndat$`Result Unit` == jndat$uom
  if(any(!chk)){
    tochk <- sort(jndat$`Characteristic Name`[!chk])
    stop('Mis-match between units in result and DQO file: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  
  accdat <- accdat %>% 
    dplyr::select(Parameter, MDL, UQL, `Value Range`)

  # replace BDL with 1/2 quant limit or MDL, replace AQL wiht quant limit or UQL
  # then filter by value range in accdat
  out <- resdat %>% 
    dplyr::mutate(ind = 1:n()) %>% 
    inner_join(accdat, by = c('Characteristic Name' = 'Parameter')) %>% 
    dplyr::mutate(
      `Result Unit` = ifelse(`Characteristic Name` == 'pH', 's.u.', `Result Unit`),
      `Result Value` = dplyr::case_when(
        `Result Value` == 'BDL' & is.na(`Quantitation Limit`) ~ as.character(MDL / 2), 
        `Result Value` == 'BDL' & !is.na(`Quantitation Limit`) ~ as.character(as.numeric(`Quantitation Limit`) / 2), 
        `Result Value` == 'AQL' & is.na(`Quantitation Limit`) ~ as.character(UQL),
        `Result Value` == 'AQL' & !is.na(`Quantitation Limit`) ~ `Quantitation Limit`, 
        T ~ `Result Value`
      ), 
      `Result Value` = as.numeric(`Result Value`)
    ) %>% 
    tidyr::unite('flt', `Result Value`, `Value Range`, sep = ' ', remove = FALSE) %>% 
    dplyr::rowwise() %>%
    dplyr::mutate(
      flt = ifelse(grepl('all', flt), T, eval(parse(text = flt)))
    ) %>% 
    dplyr::filter(flt) %>% 
    dplyr::group_by(ind) %>% 
    dplyr::mutate(
      `rngflt` = as.numeric(gsub(paste(colsym, collapse = '|'), '', `Value Range`))
    ) %>% 
    dplyr::filter(ifelse(is.na(rngflt), T, max(rngflt) == rngflt)) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(-ind, -MDL, -UQL, -flt, -`Value Range`, -rngflt)
  
  return(out)
  
}