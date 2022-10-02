#' Create summary tables of the water quality monitoring results
#'
#' Create summary tables of content in the water quality monitoring results to troubleshoot checks with \code{\link{readMWRresults}}
#' 
#' @param respth character string of path to the results file
#' @param table character string indicating which summary table to create, see details
#'
#' @return A summary table of counts of observations in the water quality monitoring result for the selected table
#' 
#' @details Acceptable options for the \code{table} argument include \code{'parameter, unit'} or \code{'activity type, parameter'}.  Both options return summarized tables that show the unique counts of observations for the column combination provied by \code{table}.  For example, \code{table = 'parameter, unit'} will return a table where the rows are the unique parameters (\code{"Characteristic Name"}) and the columns are the unique units (\code{"Result Unit"}) found in the results file. The numbers in the table show the unique observations that correspond to each parameter and result unit combination. Similarly, \code{table = 'activity type, parameter'} will return a table where the rows are the unique activity types (\code{"Activity Type"}) and the columns for the unique parameters (\code{"Characteristic Name"}).  
#' 
#' These tables can be useful to troubleshoot the checks when importing the water quality monitoring result file with \code{readMWRresults}, e.g., by seeing which units apply to a parameter and if they correspond to the acceptable values for the package (see \href{https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks}{https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks}). 
#' 
#' @export
#'
#' @examples
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # parameters and units
#' readMWRresultspivot(respth, table = c('parameter, unit'))
#' 
#' # activity types and parameters
#' readMWRresultspivot(respth, table = c('activity type, parameter'))
readMWRresultspivot <- function(respth, table){
  
  table <- match.arg(table, choices = c('parameter, unit', 'activity type, parameter'))
  
  resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), 
                                                col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text', 
                                                              'text', 'text', 'text', 'text')))
  
  # parameters and units
  if(table == 'parameter, unit')
    out <- table(resdat[, c('Characteristic Name', 'Result Unit')])
  
  # activity types and parameters
  if(table == 'activity type, parameter')
    out <- table(resdat[, c('Activity Type', 'Characteristic Name')])
  
  return(out)
  
}
