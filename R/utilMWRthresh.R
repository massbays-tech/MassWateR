#' Get threshold lines from thresholdMWR
#'
#' @param resdat results data as returned by \code{\link{readMWRresults}}
#' @param param character string to first filter results by a parameter in \code{"Characteristic Name"}
#' @param thresh character indicating if relevant freshwater or marine threshold lines are included, one of \code{"fresh"}, \code{"marine"}, or \code{"none"}
#'
#' @return A logical value indicating \code{TRUE} if a log10-scale should be used, \code{FALSE} for arithmetic (linear)
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
utilMWRthresh <- function(resdat, param, thresh = c('fresh', 'marine', 'none')){
  
  thresh <- match.arg(thresh)
  
  if(thresh == 'none')
    return(NULL)

  # get resdat units
  resuni <- resdat %>% 
    dplyr::filter(`Characteristic Name` %in% param) %>% 
    dplyr::pull(`Result Unit`) %>% 
    unique
  
  # filter thresholdMWR by param
  out <- thresholdMWR %>% 
    dplyr::filter(`Simple Parameter` == param)
    
  if(nrow(out) == 0)
    return(NULL)
  
  # threshold units
  thruni <- out %>% 
    dplyr::mutate(
      uom = dplyr::case_when(
        `Simple Parameter` == 'pH' ~ 's.u.', 
        T ~ uom
      )
    ) %>% 
    dplyr::pull(uom)

  # check if threshold units same as resdat units
  chk <- !resuni == thruni
  if(chk)
    stop('Unit mismatch for ', param, ' in results and threshold file: results ', resuni, ', threshold file ', thruni)
  
  out <- out %>% 
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
      size = c(1.5, 0.5),
      label = factor(label, levels = rev(label))
      ) %>% 
    dplyr::arrange(label)

  if(nrow(na.omit(out)) == 0)
    return(NULL)
  
  return(out)
  
}