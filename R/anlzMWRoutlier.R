#' Analyze outliers in results file
#' 
#' Analyze outliers in results file
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param param character string of the parameter to plot, must conform entries in the \code{"Simple Parameter"} of \code{\link{paramsMWR}}
#' @param type character indicating whether the summaries are grouped by month (default) or site
#' @param jitter logical indicating of non-outlier points are jittered over the boxplots
#' @param repel logical indicating if overlapping outlier labels are offset
#' @param outliers logical indicating if outliers are returned to the console instead of plotting
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}}, \code{\link{checkMWRacc}}, \code{\link{checkMWRfrecom}}, applies only if \code{res}, \code{acc}, or \code{frecom} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @return A \code{\link[ggplot2]{ggplot}} object that can be further modified if \code{outliers = TRUE}, otherwise a data frame of outliers is returned.
#' 
#' @details Outliers are defined following the standard \code{\link[ggplot2]{ggplot}} definition as 1.5 times the inter-quartile range of each boxplot.  The data frame returned if \code{outliers = TRUE} may vary based on the boxplot groupings defined by \code{type}.
#' 
#' @export
#'
#' @examples
#' # results data path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # outliers by month
#' anlzMWRoutlier(res = resdat, param = 'DO', type = 'month')
#' 
#' # outliers by site
#' anlzMWRoutlier(res = resdat, param = 'DO', type = 'site')
#' 
#' # data frame output
#' anlzMWRoutlier(res = resdat, param = 'DO', type = 'month', outliers = TRUE)
anlzMWRoutlier <- function(res, param, type = c('month', 'site'), jitter = TRUE, repel = TRUE, outliers = FALSE, runchk = TRUE, warn = TRUE){
  
  type <- match.arg(type)
  
  # inputs
  inp <- utilMWRinput(res = res, runchk = runchk, warn = warn)
  
  # results data
  resdat <- inp$resdat %>% 
    dplyr::filter(`Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine'))

  # check of param in resdat
  resprms <- resdat %>% 
    dplyr::pull(`Characteristic Name`) %>% 
    unique()
  
  chk <- param %in% resprms
  if(!chk)
    stop(param, ' not found in results data', call. = FALSE)
  
  ##
  # plot prep
  
  thm <- ggplot2::theme_minimal() + 
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(), 
      panel.grid.minor.x = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank(), 
      axis.text.x = ggplot2::element_text(angle = 45, size = 8, hjust = 1)
    )
  
  # outlier function
  is_outlier <- function(x) {
    return(x < quantile(x, 0.25) - 1.5 * IQR(x) | x > quantile(x, 0.75) + 1.5 * IQR(x))
  }
  
  toplo <- resdat %>% 
    dplyr::filter(`Characteristic Name` == param) %>% 
    dplyr::mutate(
      `Result Value` = as.numeric(`Result Value`)
    )

  ylab <- unique(toplo$`Result Unit`)

  # plot by month
  if(type == 'month'){
   
    toplo <- toplo %>% 
      dplyr::mutate(
        Month = lubridate::month(`Activity Start Date`, label = TRUE, abbr = TRUE)
        ) %>% 
      dplyr::group_by(Month) %>% 
      dplyr::mutate(
        outlier = ifelse(is_outlier(`Result Value`), `Monitoring Location ID`, NA_character_)
      ) %>% 
      dplyr::ungroup()

    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = Month, y = `Result Value`))
    
  }
  
  # plot by site
  if(type == 'site'){
    
    toplo <- toplo %>% 
      dplyr::group_by(`Monitoring Location ID`) %>% 
      dplyr::mutate(
        outlier = ifelse(is_outlier(`Result Value`), as.character(`Activity Start Date`), NA_character_)
      ) %>% 
      dplyr::ungroup()
    
    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = `Monitoring Location ID`, y = `Result Value`)) 
    
  }

  # return outliers if TRUE
  if(outliers){
    
    out <- toplo %>% 
      dplyr::filter(!is.na(outlier)) %>% 
      dplyr::select(`Monitoring Location ID`, `Activity Start Date`, `Characteristic Name`, `Result Value`, `Result Unit`)

    return(out)      
    
  }
  
  p <- p + 
    ggplot2::geom_boxplot(outlier.color = 'tomato1')
  
  if(repel)
    p <- p +
      ggrepel::geom_text_repel(ggplot2::aes(label = outlier), na.rm = T, point.size = NA)
    
  if(!repel)
    p <- p + 
      ggplot2::geom_text(ggplot2::aes(label = outlier), na.rm = T)
  
  if(jitter){
    
    jitplo <- toplo %>% 
      dplyr::filter(is.na(outlier))
  
    p <- p + 
      ggplot2::geom_point(data = jitplo, position = ggplot2::position_dodge2(width = 0.7), alpha = 0.5, size = 1)
    
  }
  
  p <- p +  
    thm +
    ggplot2::labs(
      y = ylab, 
      title = param, 
      x = NULL
    )
  
  return(p)
  
}