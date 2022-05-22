#' Run quality control accuracy checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#'
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly.
#' 
#' Note that accuracy is only evaluated on parameters in the \code{Parameter} column in the data quality objectives completeness file.  A warning is returned if there are parameters in that column that are not found in the results file.
#' 
#' @return The output shows the accuracy checks from the input files.  
#' 
#' @export
#'
#' @examples
#' ##
#' # using file paths
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
#' 
#' qcMWRacc(res = respth, acc = accpth)
#' 
#' ##
#' # using data frames
#' 
#' # results data
#' resdat <- readMWRresults(respth)
#' 
#' # accuracy data
#' accdat <- readMWRacc(accpth)
#' 
#' qcMWRacc(res = resdat, acc = accdat)
#' 
qcMWRacc <- function(res, acc, runchk = TRUE, warn = TRUE){
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, acc = acc, runchk = runchk)
  resdat <- inp$resdat
  accdat <- inp$accdat
  
  ##
  # check parameters in accuracy can be found in results
  accprm <- sort(unique(accdat$Parameter))
  resdatprm <- sort(unique(resdat$`Characteristic Name`))
  chk <- accprm %in% resdatprm
  if(any(!chk) & warn){
    tochk <- accprm[!chk]
    warning('Parameters in quality control objectives for accuracy not found in results data: ', paste(tochk, collapse = ', '))
  }
  
  # check units in resdat match those in accuracy file
  accuni <- accdat %>% 
    dplyr::select(
      `Characteristic Name` = Parameter, 
      `uom`
    ) %>% 
    unique
  resdatuni <- unique(resdat[, c('Characteristic Name', 'Result Unit')])
  jndat <- inner_join(resdatuni, accuni, by = 'Characteristic Name') %>% 
    dplyr::mutate(
      `Result Unit` = ifelse(is.na(`Result Unit`), 'blank', `Result Unit`),
      uom = ifelse(is.na(uom), 'blank', uom)
    )
  chk <- jndat$`Result Unit` == jndat$uom
  if(any(!chk)){
    tochk <- sort(jndat$`Characteristic Name`[!chk])
    stop('Mis-match between units in result and DQO file: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  
  # parameters for accuracy checks
  prms <- accprm[chk]

  ##
  # accuracy checks not requiring a loop
  
  # field and lab blanks, can do together 
  blk <- accdat %>% 
    select(`Characteristic Name` = Parameter, MDL, uom) %>% 
    unique %>% 
    left_join(resdat, ., by = 'Characteristic Name') %>%
    dplyr::filter(`Activity Type` %in% c('Quality Control Sample-Field Blank', 'Quality Control Sample-Lab Blank')) %>% 
    dplyr::select(
      `Activity Type`,
      Parameter = `Characteristic Name`,
      Date = `Activity Start Date`,
      Site = `Monitoring Location ID`,
      Result = `Result Value`,
      `Result Unit`, 
      MDL, 
      `MDL Unit` = uom
    ) %>% 
    dplyr::mutate(
      `Hit/Miss` = dplyr::case_when(
        !`Result` %in% c('AQL', 'BDL') & Result >= MDL ~ 'MISS',
        Result %in% 'AQL' ~ 'MISS',
        T ~ NA_character_
      ), 
      `Result Unit` = ifelse(Result %in% c('AQL', 'BDL'), NA, `Result Unit`)
    ) %>% 
    tidyr::unite('Result', Result, `Result Unit`, sep = ' ', na.rm = TRUE) %>% 
    tidyr::unite('MDL', MDL, `MDL Unit`, sep = ' ')
  
  # field blank
  fldblk <- blk %>%
    dplyr::filter(`Activity Type` == 'Quality Control Sample-Field Blank') %>% 
    dplyr::select(-`Activity Type`)
  
  # lab blank
  labblk <- blk %>%
    dplyr::filter(`Activity Type` == 'Quality Control Sample-Lab Blank') %>% 
    dplyr::select(-`Activity Type`)

  # output placeholders
  flddup <- NULL
  labdup <- NULL
  labspk <- NULL
  inschk <- NULL
  
  # remove columns from accdat that we don't need for remaning checks
  accdat <- accdat %>% 
    dplyr::select(-uom, -`Field Blank`, -`Lab Blank`)
  
  # run accuracy checks
  for(prm in prms){
    
    # subset dqo data
    accdattmp <- accdat %>%
      dplyr::filter(Parameter == prm)

    # subset results data
    resdattmp <- resdat %>%
      dplyr::filter(`Characteristic Name` == prm)

    # field duplicates
    flddupsub <- resdattmp %>% 
      dplyr::filter(`Activity Type` == 'Quality Control Sample-Field Duplicate')
    if(nrow(flddupsub) != 0){

      res <- NULL
      flddup <- dplyr::bind_rows(flddup, res) 
      
    }
    
    # lab duplicates
    labdupsub <- resdattmp %>% 
      dplyr::filter(`Activity Type` == 'Quality Control Sample-Lab Duplicate')
    if(nrow(labdupsub) != 0){
    
      res <- labdupsub %>% 
        dplyr::select(
          Parameter = `Characteristic Name`, 
          Date = `Activity Start Date`, 
          Site = `Monitoring Location ID`, 
          `Initial Result` = `Result Value`, 
          `Dup. Result` = `QC Reference Value`
        ) %>%
        dplyr::left_join(accdat, by = 'Parameter') %>% 
        dplyr::mutate(
          `Initial Result2` = dplyr::case_when(
            `Initial Result` == 'BDL' ~ as.character(MDL), 
            `Initial Result` == 'AQL' ~ as.character(UQL), 
            T ~ `Initial Result`
          ), 
          `Dup. Result2` = dplyr::case_when(
            `Dup. Result` == 'BDL' ~ as.character(MDL), 
            `Dup. Result` == 'AQL' ~ as.character(UQL), 
            T ~ `Dup. Result`
          )
        )
      # need to figure out how to handle differing value ranges for the standard
      labdup <- dplyr::bind_rows(labdup, res) 
      
    }
    
    # lab spikes
    labspksub <- resdattmp %>% 
      dplyr::filter(`Activity Type` == 'Quality Control Sample-Lab Spike')
    if(nrow(labspksub) != 0){
      
      res <- NULL
      labspk <- dplyr::bind_rows(labspk, res) 
      
    }
    
    # instrument checks
    inschksub <- resdattmp %>% 
      dplyr::filter(`Activity Type` == 'Quality Control Field Calibration Check')
    if(nrow(inschksub) != 0){
      
      res <- NULL
      inschk <- dplyr::bind_rows(inschk, res) 
      
    }

  }
 
  # compile all as list since columns differ
  out <- list(
    `Field Blanks` = fldblk,
    `Lab Blanks` = labblk,
    `Field Duplicates` = flddup,
    `Lab Duplicates` = labdup, 
    `Lab Spikes` = labspk,
    `Instrument Checks (post sampling)` = inschk
  )
  
  return(out)
  
}