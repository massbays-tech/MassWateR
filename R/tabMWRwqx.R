#' Create and save tables in a single workbook for WQX upload
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param sit character string of path to the site metadata file or \code{data.frame} for site metadata returned by \code{\link{readMWRsites}}
#' @param wqx character string of path to the wqx metadata file or \code{data.frame} for wqx metadata returned by \code{\link{readMWRwqx}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param output_dir character string of the output directory for the results, default is the working directory
#' @param output_file optional character string for the file name, must include .xlsx suffix
#'
#' @return An Excel workbook is saved to location defined in \code{output_dir} with the name \code{output_file} as default
#' @export
#'
#' @examples
tabMWRwqx <- function(res = NULL, acc = NULL, sit = NULL, wqx = NULL, fset = NULL, output_dir = NULL, output_file = NULL){
  
  utilMWRinputcheck(mget(ls()))

  ##
  # Projects
  prjs <- NULL
  
  ##
  # Locations
  locs <- NULL
  
  ##
  # Results
  resu <- NULL
  
  ##
  # save output

  # default output directory is working directory
  if(is.null(output_dir))
    output_dir <- getwd()
  
  if(is.null(output_file))
    output_file <- 'wqxtab.xlsx'
  
  out <- list(
    Projects = prjs,
    Locations = locs,
    Results = resu
  )
  
  # save
  writexl::write_xlsx(out, path = file.patth(output_dir, output_file))
  
  file_loc <- list.files(path = output_dir, pattern = output_file, full.names = TRUE)
  msg <- paste("Excel workbook created successfully! File located at", file_loc)
  message(msg)
  
}