#' Get threshold lines from thresholdMWR
#'
#' @param resdat results data as returned by \code{\link{readMWRresults}}
#' @param param character string to first filter results by a parameter in \code{"Characteristic Name"}
#' @param thresh character indicating if relevant freshwater or marine threshold lines are included, one of \code{"fresh"}, \code{"marine"}, or \code{"none"}, or a single numeric value to override the values included with the package
#' @param threshlab optional character string indicating legend label for the threshold, required only if \code{thresh} is numeric
#'
#' @return If \code{thresh} is not numeric and thresholds are available for \code{param}, a \code{data.frame} of relevant marine or freshwater thresholds, otherwise \code{NULL}.  If \code{thresh} is numeric, a \code{data.frame} of the threshold with the appropriate label from \code{threshlabel}.
#' 
#' @export
#'
#' @examples
#' # results file path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # get threshold lines
#' utilMWRthresh(resdat = resdat, param = 'E.coli', thresh = 'fresh')
#' 
#' # user-defined numeric threshold line
#' utilMWRthresh(resdat = resdat, param = 'TP', thresh = 5, threshlab = 'My threshold')
utilMWRthresh <- function(resdat, param, thresh, threshlab = NULL){
  
  if(is.numeric(thresh)){
    if(is.null(threshlab))
      stop('threshlab required if thresh is numeric')
    out <- data.frame(num = 1, thresh = thresh, label = threshlab, size = 0.73, linetype = 'longdash')
    return(out)
  }
  
  if(!is.numeric(thresh))
    thresh <- match.arg(thresh, choices = c('fresh', 'marine', 'none'))

  if(thresh == 'none')
    return(NULL)

  # applies only to Field Msr/Obs and Sample-Routine
  resdat <- resdat %>% 
    filter(`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine'))  
  
  # get resdat units
  resuni <- resdat %>% 
    dplyr::filter(`Characteristic Name` %in% param) %>% 
    dplyr::pull(`Result Unit`) %>% 
    unique
  
  if(param == 'pH'){
    if(is.na(resuni) | resuni == 's.u.')
      resuni <- 'blank'
  }
  
  # filter thresholdMWR by param
  out <- thresholdMWR %>% 
    dplyr::filter(`Simple Parameter` == param)

  if(nrow(out) == 0)
    return(NULL)
  
  # threshold units
  thruni <- out %>% 
    dplyr::pull(uom)

  # check if resdat unit in threshold units
  chk <- resuni %in% thruni
  if(!chk){
    msg <- paste(thruni, collapse = ', ')
    msg <- paste0('Unit mismatch for ', param, ' in results and threshold file: results ', resuni, ', threshold file ', msg)
    stop(msg)
  }
  
  out <- out %>% 
    dplyr::filter(uom == resuni) %>% 
    dplyr::select(dplyr::matches(toupper(thresh))) 
  
  names(out) <- c('val_1', 'lab_1', 'val_2', 'lab_2')
  
  out1 <- out %>% 
    dplyr::select_if(is.numeric) %>% 
    tidyr::pivot_longer(cols = dplyr::everything(), values_to = 'thresh') %>% 
    tidyr::separate(col = name, into = c('lab', 'num'), sep = '_')
  
  out2 <- out %>% 
    dplyr::select_if(is.character) %>% 
    tidyr::pivot_longer(cols = dplyr::everything(), values_to = 'label') %>% 
    tidyr::separate(col = name, into = c('lab', 'num'), sep = '_')

  out <- full_join(out1, out2, by = 'num') %>% 
    dplyr::select(num, thresh, label) %>% 
    dplyr::mutate(
      size = c(0.73, 0.75),
      linetype = c('longdash', 'dashed'),
      label = factor(label, levels = rev(label))
      ) %>% 
    dplyr::arrange(label, .locale = 'en')

  if(nrow(na.omit(out)) == 0)
    return(NULL)
  
  return(out)
  
}