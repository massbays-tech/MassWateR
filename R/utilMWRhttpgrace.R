#' Load external file from remote source, fail gracefully
#'
#' @param remote_file URL of the external file
#'
#' @return The external file as an RData object
#' @export
#'
#' @examples
#' # fails gracefully
#' utilMWRhttpgrace('http://httpbin.org/status/404')
#' \donttest{
#' # imports data or fails gracefully
#' fl <- 'https://github.com/massbays-tech/MassWateRdata/raw/main/data/streamsMWR.RData'
#' utilMWRhttpgrace(fl)
#' }
utilMWRhttpgrace <- function(remote_file){
  
  try_GET <- function(x, ...) {
    tryCatch(
      httr::GET(url = x, httr::timeout(10), ...),
      error = function(e) conditionMessage(e),
      warning = function(w) conditionMessage(w)
    )
  }
  
  is_response <- function(x) {
    class(x) == "response"
  }
  
  # First check internet connection
  if (!curl::has_internet()) {
    message("No internet connection.")
    return(invisible(NULL))
  }
  # Then try for timeout problems
  resp <- try_GET(remote_file)
  if (!is_response(resp)) {
    message(resp)
    return(invisible(NULL))
  }
  # Then stop if status > 400
  if (httr::http_error(resp)) { 
    httr::message_for_status(resp)
    return(invisible(NULL))
  }
  
  # load if clean
  load(url(resp$url))
  
  out <- get(gsub('\\.RData$', '', basename(resp$url)))
  
  return(out)
  
}
