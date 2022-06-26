#' Create the quality control review report
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param output_dir character string of the output directory for the rendered file
#' @param output_file optional character string for the file name
#' @param dqofontsize numeric for font size in the data quality objective tables in the first page of the review
#' @param tabfontsize numeric for font size in the review tables
#' @param warn logical indicating if warnings from the table functions are included in the file output
#'
#' @return A compiled review report named \code{qcreview.docx} will be saved in the directory specified by \code{output_dir}
#' @export
#'
#' @details 
#' 
#' The function compiles a review report as a Word document for all quality control checks included in the MassWateR package.  The report shows several tables, including the data quality objectives files for accuracy, frequency, and completeness, summary results for all accuracy checks, summary results for all frequency checks, summary results for all completeness checks, and individual results for all accuracy checks.  The report uses the individual table functions (which can be used separately) to return the results, which include \code{\link{tabMWRacc}}, \code{\link{tabMWRfre}}, and \code{\link{tabMWRcom}}.  The help files for each of these functions can be consulted for a more detailed explanation of the quality control checks. 
#' 
#' The workflow for using this function is to import the required data (results and data quality objective files) and to fix any errors noted on import prior to creating the review report.  Additional warnings that may be of interest as returned by the individual table functions can be included in the report by setting \code{warn = TRUE}.  
#' 
#' The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}}, \code{\link{readMWRacc}}, and \code{\link{readMWRfrecom}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}, as explained in the relevant help files.  In the latter case, downstream analyses may not work if data are formatted incorrectly. 
#' 
#' @examples
#' # results data
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # dqo accuracy data
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
#' 
#' # dqo completeness data
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR')
#' 
#' # create report in working directory
#' qcMWRreview(res = respth, acc = accpth, frecom = frecompth, output_dir = getwd())
#' 
#' # remove file when done
#' file.remove(list.files(getwd(), 'qcreview'))
qcMWRreview <- function(res, acc, frecom, output_dir, output_file = NULL, dqofontsize = 7.5, tabfontsize = 9, warn = FALSE) {

  qcreview <- system.file('rmd', 'qcreview.Rmd', package = 'MassWateR')
  
  suppressMessages(rmarkdown::render(
    input = qcreview,
    output_dir = output_dir, 
    output_file = output_file, 
    params = list(
      warn = warn,
      dqofontsize = dqofontsize, 
      tabfontsize = tabfontsize,
      res = res, 
      acc = acc, 
      frecom = frecom
    ), 
    quiet = TRUE
  ))
  
  msg <- paste("Report created successfully! View the file qcreview.docx at", output_dir)
  message(msg)

}
