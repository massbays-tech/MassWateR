#' Create summary spreadsheet of the water quality monitoring results
#'
#' Create summary spreadsheet of unique values for each column in the water quality results file to check for data mistakes prior to running the \code{\link{readMWRresults}} function
#' 
#' @param respth character string of path to the results file
#' @param columns character string indicating which columns to view, defaults to all
#' @param output_dir character string of the output directory for the rendered file, default is the working directory
#' @param output_file optional character string for the name of the .csv file output, must include the file extension
#' @param maxlen numeric to truncate numeric values to the specified length
#'
#' @return Creates a spreadsheet at the location specified by \code{output_dir}, defaults to working directory if none specified. Each column shows the unique values.
#' 
#' @details Acceptable options for the \code{columns} argument include any of the column names in the results file. The default setting (\code{NULL}) will show every column in the results file.
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
readMWRresultsview <- function(respth, columns = NULL, output_dir = NULL, output_file = NULL, maxlen = 8){
  
  resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), guess_max = Inf)) %>% 
    dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character)

  resdat <- resdat %>% 
    dplyr::mutate(
      `Activity Start Date` = format(`Activity Start Date`, '%m/%d/%Y'), 
      `Activity Start Date` = gsub('^0', '', `Activity Start Date`), 
      `Activity Start Time` = gsub('^.*\\s', '', `Activity Start Time`), 
      `Activity Start Time` = gsub('^0', '', `Activity Start Time`), 
      `Activity Start Time` = gsub(':0+$', '', `Activity Start Time`),
      dplyr::across(c(`Activity Depth/Height Measure`, `Result Value`, `Quantitation Limit`, `QC Reference Value`), substring, first = 1, last = maxlen)
    )
  
  if(is.null(columns))
    columns <- names(resdat)
  
  chk <- any(!columns %in% names(resdat))
  if(chk){
    msg <- paste(columns[!columns %in% names(resdat)], collapse = ', ')
    msg <- paste(msg, 'not found in results, can be any of the following column names:', paste(names(resdat), collapse = ', '))
    stop(msg)
  }

  out <- NULL
  for(column in columns){
    
    uni <- resdat %>% 
      dplyr::pull(column) %>% 
      unique %>% 
      sort %>% 
      list()
    
    names(uni) <- column
    
    out <- c(out, uni)
    
  }
  
  # table
  resultsviewtab <- data.frame(lapply(out, `length<-`, max(lengths(out))))
  names(resultsviewtab) <- names(out)

  # default output directory is working directory
  if(is.null(output_dir))
    output_dir <- getwd()
  
  # default output file name
  if(is.null(output_file))
    output_file <- 'resultsview.csv'

  # save file
  write.csv(resultsviewtab, file = paste(output_dir, output_file, sep = '/'), row.names = FALSE , na = '')
  
  file_loc <- list.files(path = output_dir, pattern = output_file, full.names = TRUE)
  msg <- paste("csv created successfully! File located at", file_loc)
  message(msg)

}
