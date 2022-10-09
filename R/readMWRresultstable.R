#' Create summary tables of the water quality monitoring results
#'
#' Create summary tables of columns in the water quality monitoring results to troubleshoot checks with \code{\link{readMWRresults}}
#' 
#' @param respth character string of path to the results file
#' @param columns character string indicating which columns to view, can be one or two column names, see details
#'
#' @return A summary table of counts of observations in the water quality monitoring results for the selected column(s)
#' 
#' @details Acceptable options for the \code{columns} argument include one or two of the column names in the results file. An error is returned indicating acceptable values if the column names are not found.  
#' 
#' One or two column names can be provided to the \code{columns} argument.  If one column is provided, a simple table showing the unique number of observations that correspond to all entries in the provided column is returned.  If two column names are provided, a two-dimensional table showing the counts that apply to the unique combinations of the two columns is returned.  For example, using \code{columns = c('Characteristic Name', 'Result Units')} will return a table where the rows are the unique parameters (\code{"Characteristic Name"}) and the columns are the unique units (\code{"Result Unit"}) found in the results file. The numbers in the table show the unique observations that correspond to each parameter and result unit combination. 
#' 
#' These tables can be useful to troubleshoot the checks when importing the water quality monitoring result file with \code{readMWRresults}, e.g., by seeing which units apply to a parameter and if they correspond to the acceptable values for the package (see \href{https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks}{https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks}). 
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # parameters only
#' readMWRresultstable(respth, columns = 'Characteristic Name')
#' 
#' # parameters and units
#' readMWRresultstable(respth, columns = c('Characteristic Name', 'Result Unit'))
#' 
#' # activity types and parameters
#' readMWRresultstable(respth, columns = c('Activity Type', 'Characteristic Name'))
readMWRresultstable <- function(respth, columns){

  # only one or two entires for columns allowed
  chk <- length(columns) > 2
  if(chk)
    stop('columns argument must be one or two values only')
  
  resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), 
                                                col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
                                                              'text', 'text', 'text', 'text')))

  chk <- any(!columns %in% names(resdat))
  if(chk){
    msg <- paste(columns[!columns %in% names(resdat)], collapse = ', ')
    msg <- paste(msg, 'not found in results, must be one or two of the following column names:', paste(names(resdat), collapse = ', '))
    stop(msg)
  }

  out <- table(resdat[, columns])
  
  return(out)
  
}
