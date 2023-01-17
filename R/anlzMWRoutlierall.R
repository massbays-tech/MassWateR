#' Analyze outliers in results file for all parameters
#' 
#' Analyze outliers in results file for all parameters
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param fig_height numeric for plot heights in inches
#' @param fig_width numeric for plot width in inches
#' @param format character string indicating if results are placed in a word file or as separate png files in \code{output_dir}
#' @param output_dir character string of the output directory for the results
#' @param output_file optional character string for the file name if \code{format = "word"}
#' @param type character indicating \code{"box"}, \code{"jitterbox"}, or \code{"jitter"}, see details
#' @param group character indicating whether the summaries are grouped by month, site, or week of year
#' @param dtrng character string of length two for the date ranges as YYYY-MM-DD, optional
#' @param repel logical indicating if overlapping outlier labels are offset
#' @param outliers logical indicating if outliers are returned to the console instead of plotting
#' @param labsize numeric indicating font size for the outlier labels
#' @param fill numeric indicating fill color for boxplots
#' @param alpha numeric from 0 to 1 indicating transparency of fill color
#' @param width numeric for width of boxplots
#' @param yscl character indicating one of \code{"auto"} (default), \code{"log"}, or \code{"linear"}, see details
#' @param ttlsize numeric value indicating font size of the title relative to other text in the plot
#' @param runchk logical to run data checks with \code{\link{checkMWRresults}} or \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A word document named \code{outlierall.docx} (or name passed to \code{output_file}) if \code{format = "word"} or separate png files for each parameter if \code{format = "png"} will be saved in the directory specified by \code{output_dir}
#' 
#' @details This function is a wrapper to \code{\link{anlzMWRoutlier}} to create plots for all parameters with appropriate data in the water quality monitoring results 
#' @export
#'
#' @examples
#' # results data path
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
#' \donttest{
#' # create word output
#' anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'word', output_dir = tempdir())
#'
#' # create png output
#' anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'png', output_dir = tempdir())
#' }
anlzMWRoutlierall <- function(res = NULL, acc = NULL, fset = NULL, fig_height = 4, fig_width = 8, format = c('word' ,'png'), output_dir, output_file = NULL, type = c('box', 'jitterbox', 'jitter'), group, dtrng = NULL, repel = TRUE, outliers = FALSE, labsize = 3, fill = 'lightgrey', alpha = 0.8, width = 0.8, yscl = c('auto', 'log', 'linear'), ttlsize = 1.2, runchk = TRUE, warn = TRUE){
  
  utilMWRinputcheck(mget(ls()))
  
  format <- match.arg(format)
  
  # inputs
  inp <- utilMWRinput(res = res, acc = acc, fset = fset, runchk = runchk, warn = warn)
  resdat <- inp$resdat
  accdat <- inp$accdat
  
  allparam <- resdat %>% 
    dplyr::filter(`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine')) %>% 
    dplyr::pull(`Characteristic Name`) %>% 
    unique() %>% 
    sort()
  
  # create figures as named list
  pall <- vector('list', length = length(allparam))
  names(pall) <- allparam
  for(param in allparam){
    
    p <- anlzMWRoutlier(res = resdat, param = param, acc = accdat, type = type, group = group, dtrng = dtrng, repel = repel, outliers = outliers, labsize = labsize, fill = fill, alpha = alpha, width = width, yscl = yscl, ttlsize = ttlsize, runchk = FALSE, warn = warn)
    
    pall[[param]] <- p
    
  }
  
  # word output
  if(format == 'word'){
    
    # rmd template
    outlierall <- system.file('rmd', 'outlierall.Rmd', package = 'MassWateR')

    suppressMessages(rmarkdown::render(
      input = outlierall,
      output_dir = output_dir, 
      output_file = output_file, 
      params = list(
        pall = pall,
        fig_width = fig_width, 
        fig_height = fig_height
      ), 
      quiet = TRUE
    ))
    
    if(is.null(output_file))
      output_file <- gsub('\\.Rmd$', '.docx', basename(outlierall))
    file_loc <- list.files(path = output_dir, pattern = output_file, full.names = TRUE)
    msg <- paste("Word document created successfully! File located at", file_loc)
    message(msg)
    
  }
   
  # png output
  if(format == 'png'){
   
    # create directory if it doesn't exist
    if(!file.exists(output_dir))
      dir.create(output_dir)
    
    # save files to directory
    for(nm in names(pall)){
      
      file_name <- file.path(output_dir, paste0(nm, '.png'))
      png(file_name, height = fig_height, width = fig_width, units = 'in', res = 200)   
      print(pall[[nm]])
      dev.off()
      
    }
    
    msg <- paste("PNG files created successfully! Files located at", output_dir)
    message(msg)
    
  }
  
}
  