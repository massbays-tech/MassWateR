#' Create summary views of the water quality monitoring results
#'
#' Create summary views of unique values in columns in the water quality monitoring results to troubleshoot checks with \code{\link{readMWRresults}}
#' 
#' @param respth character string of path to the results file
#' @param columns character string indicating which columns to view, defaults to all
#'
#' @return Data viewers (from \code{\link[utils]{View}}) for the selected columns, one per column showing the unique values in the column.
#' 
#' @details Acceptable options for the \code{columns} argument include any of the column names in the results file. The default setting (\code{NULL}) will open data viewers for every column in the results file (fourteen windows total).
#' 
#' The output of this function can be useful to troubleshoot the checks when importing the water quality monitoring result file with \code{readMWRresults} (see \href{https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks}{https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks}). 
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' \dontrun{
#' # parameters only
#' readMWRresultsview(respth, columns = 'Characteristic Name')
#'
#' # parameters and units
#' readMWRresultsview(respth, columns = c('Characteristic Name', 'Result Unit'))
#' 
#' # all columns
#' readMWRresultsview(respth)
#' }
readMWRresultsview <- function(respth, columns = NULL){
  
  resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), 
                                                col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
                                                              'text', 'text', 'text', 'text')))
  
  if(is.null(columns))
    columns <- names(resdat)
  
  chk <- any(!columns %in% names(resdat))
  if(chk){
    msg <- paste(columns[!columns %in% names(resdat)], collapse = ', ')
    msg <- paste(msg, 'not found in results, can be any of the following column names:', paste(names(resdat), collapse = ', '))
    stop(msg)
  }

  for(column in columns){
    
    uni <- resdat %>% 
      dplyr::pull(column) %>% 
      unique %>% 
      sort %>% 
      data.frame()
    
    names(uni) <- column
 
    utils::View(uni, title = column)
    
  }
  
}
