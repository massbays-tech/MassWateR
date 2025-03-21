#' Check if required inputs are present for a function
#'
#' @param inputs list of arguments passed from the parent function
#' @param nocheck optional character vector of inputs not to check, allows for optional inputs
#'
#' @return NULL if all inputs are present, otherwise an error message indicating which inputs are missing
#' @export
#'
#' @examples
#' inputchk <- formals(tabMWRcom)
#' inputchk$res <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' inputchk$frecom <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'   package = 'MassWateR')
#' inputchk$cens <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')
#' 
#' utilMWRinputcheck(inputchk)
utilMWRinputcheck <- function(inputs, nocheck = NULL){
  
  # names of required inputs from the function
  inpchk <- names(inputs)
  inpchk <- inpchk[inpchk %in% c('res', 'acc', 'frecom', 'sit', 'wqx', 'cens')]

  if(!is.null(nocheck))
    inpchk <- inpchk[!inpchk %in% nocheck]
  
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
