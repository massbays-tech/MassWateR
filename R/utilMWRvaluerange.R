#' Check if incomplete range in \code{Value Range} column
#' 
#' @param accdat \code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}
#'
#' @return A named vector of \code{"gap"}, \code{"nogap"}, or \code{"overlap"} indicating if a gap is present, no gap is present, or an overlap is present in the ranges provided by the value range for each parameter.  The names correspond to the parameters. 
#' 
#' @export
#' 
#' @details The function evaluates if an incomplete or overlapping range is present in the \code{Value Range} column of the data quality objectives file for accuracy
#' 
#' @examples 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
#'      package = 'MassWateR')
#' 
#' # accuracy data with no checks
#' accdat <- readxl::read_excel(accpth, na = c('NA', ''), col_types = 'text')
#' accdat <- dplyr::mutate(accdat, dplyr::across(-c(`Value Range`), ~ dplyr::na_if(.x, 'na'))) 
#' 
#' utilMWRvaluerange(accdat)
utilMWRvaluerange <- function(accdat){
 
  # 00b1 is plus/minus, 2265 is greater than or equal to, 2264 is less than or equal to 
  colsym <- c('<=', '<', '>=', '>', '\u2265', '\u2264')
  
  vals <- accdat %>% 
    dplyr::select(Parameter, `Value Range`)

  if('na' %in% vals$`Value Range`)
    stop('na present in Value Range')
         
  out <- split(vals, vals$Parameter) %>%
    lapply(pull) %>% 
    lapply(function(x){
      
      if(x[1] == 'all'){
        out <- 'nogap'
        return(out)
      }
      
      if(length(x) == 1){
        out <- 'gap'
        return(out)
      }
      
      nums <- gsub(paste(colsym, collapse = '|'), '', x)
      nums <- sort(as.numeric(nums))
      lims <- c(0.9 * nums[1], 1.1 * nums[2])
      chknum <- unique(seq(nums[1], nums[2], length.out = 3))
      chknum <- c(lims[1], chknum, lims[2])
      
      chk <- sapply(as.list(x), function(var){
          tochk <- paste(chknum, var)
          sapply(as.list(tochk), function(x) eval(parse(text = x)))
        }) %>% 
        rowSums
 
      if(any(chk == 0))
        out <- 'gap'
      
      if(any(chk > 1))
        out <- 'overlap'
      
      if(all(chk == 1))
        out <- 'nogap'
      
      return(out)
      
    }) %>% 
    unlist()
  
  return(out)
  
}