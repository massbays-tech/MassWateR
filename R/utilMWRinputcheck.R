#' Check if required inputs are present for a function
#'
#' @param inputs list of arguments passed from the parent function
#'
#' @return NULL if all inputs are present, otherwise an error message indicating which inputs are missing
#' @export
#'
#' @examples
#' inputchk <- formals(tabMWRcom)
#' \dontrun{
#' utilMWRinputcheck(inputchk)
#' }
utilMWRinputcheck <- function(inputs){
  
  # names of required inputs from the function
  inpchk <- names(inputs)
  inpchk <- inpchk[inpchk %in% c('res', 'acc', 'frecom', 'sit')]

  fset <- inputs$fset

  # check fset inputs
  if(!is.null(fset)){
    
    inpmsg <- inpchk[unlist(lapply(fset[inpchk], is.null))]
    inpmsg <- paste(inpmsg, collapse = ', ')
    
    if(nchar(inpmsg) > 0)
      stop(inpmsg, ' missing from fset list', call. = FALSE)
  
  }
  
  # check regular inputs
  if(is.null(fset)){
    
    inpmsg <- inpchk[unlist(lapply(inputs[inpchk], is.null))]
    
    inpmsg <- paste(inpmsg, collapse = ', ')
    
    if(nchar(inpmsg) > 0)
      stop(inpmsg, ' missing from inputs', call. = FALSE)
    
  }

  return()
  
}
