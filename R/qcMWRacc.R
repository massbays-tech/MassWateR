#' Run quality control accuracy checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#' @param accchk character string indicating which accuracy check to return, one to any of \code{"Field Blanks"}, \code{"Lab Blanks"}, \code{"Field Duplicates"}, \code{"Lab Duplicates"}, \code{"Lab Spikes"}, or \code{"Instrument Checks (post sampling)"}
#' @param digits numeric indicating number of significant digits to report for percentages
#' @param suffix character string indicating suffix to append to percentage values
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly.
#' 
#' Note that accuracy is only evaluated on parameters in the \code{Parameter} column in the data quality objectives accuracy file.  A warning is returned if there are parameters in \code{Parameter} in the accuracy file that are not in \code{Characteristic Name} in the results file. 
#' 
#' Similarly, parameters in the results file in the \code{Characteristic Name} column that are not found in the data quality objectives accuracy file are not evaluated.  A warning is returned if there are parameters in \code{Characteristic Name} in the results file that are not in \code{Parameter} in the accuracy file.
#' 
#' @return The output shows the accuracy checks from the input files returned as a list, with each element of the list corresponding to a specific accuracy check specified with \code{accchk}.  
#' 
#' @export
#'
#' @examples
#' ##
#' # using file paths
#' 
#' # results path
#' respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
#' 
#' # accuracy path
#' accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
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
qcMWRacc <- function(res, acc, runchk = TRUE, warn = TRUE, accchk = c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes', 'Instrument Checks (post sampling)'), digits = 0, suffix = '%'){
  
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, acc = acc, runchk = runchk)
  resdat <- inp$resdat
  accdat <- inp$accdat
  
  ##
  # check parameter matches between results and accuracy
  accprm <- sort(unique(accdat$Parameter))
  resdatprm <- sort(unique(resdat$`Characteristic Name`))
  
  # check parameters in accuracy can be found in results  
  chk <- accprm %in% resdatprm
  if(any(!chk) & warn){
    tochk <- accprm[!chk]
    warning('Parameters in quality control objectives for accuracy not found in results data: ', paste(tochk, collapse = ', '))
  }

  # check parameters in results can be found in accuracy
  chk <- resdatprm %in% accprm
  if(any(!chk) & warn){
    tochk <- resdatprm[!chk]
    warning('Parameters in results not found in  quality control objectives for accuracy: ', paste(tochk, collapse = ', '))
  }
  
  # parameters for accuracy checks
  prms <- accprm[chk]
  
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
  
  ##
  # accuracy checks
  
  # NULL if relevant activity types not found
  fldblk <- NULL
  labblk <- NULL
  flddup <- NULL
  labdup <- NULL
  labspk <- NULL
  inschk <- NULL
  
  # field and lab blank
  blktyp <- c('Quality Control Sample-Field Blank', 'Quality Control Sample-Lab Blank')
  if(any(blktyp %in% resdat$`Activity Type`) & any(c('Field Blanks', 'Lab Blanks') %in% accchk)){
    
    # get MDL and uom info from accuracy file
    acctmp <- accdat %>%
      select(Parameter, MDL, uom) %>% 
      unique
    
    # field and lab blanks, can do together 
    blk <- resdat %>% 
      dplyr::filter(`Activity Type` %in% blktyp) %>% 
      dplyr::inner_join(acctmp, by = c('Characteristic Name' = 'Parameter')) %>% 
      dplyr::select(
        `Activity Type`,
        Parameter = `Characteristic Name`,
        Date = `Activity Start Date`,
        `Sample ID` = `Result Attribute`,
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
    if('Quality Control Sample-Field Blank' %in% blk$`Activity Type` & 'Field Blanks' %in% accchk)
      fldblk <- blk %>%
        dplyr::filter(`Activity Type` == 'Quality Control Sample-Field Blank') %>% 
        dplyr::select(-`Activity Type`) %>% 
        dplyr::select(-`Sample ID`)
      
    # lab blank
    if('Quality Control Sample-Lab Blank' %in% blk$`Activity Type` & 'Lab Blanks' %in% accchk)
      labblk <- blk %>%
        dplyr::filter(`Activity Type` == 'Quality Control Sample-Lab Blank') %>% 
        dplyr::select(-`Activity Type`) %>% 
        dplyr::select(-`Site`)
  
  }

  # lab and field lab duplicates
  # first create a field duplicate entry in activity types, this will never be entered on the user side
  # field duplicates are those where activity type is Field Msr/Obs or Sample-Routine, with entries in QC Reference Value
  # then proceed as normal
  # steps include replacing any initial or duplicates as BDL/AQL with MDL/UQL for comparison
  # joining one to many of results to accuracy, then filtering results by range values in accuracy
  # comparing initial and duplicates to standard in accuracy file, handling percent/log and non-percent differently
  
  resdat_dup <- resdat %>% 
    dplyr::mutate(
      `Activity Type` = dplyr::case_when(
        `Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine') & !is.na(`QC Reference Value`) ~ 'Field Duplicate', 
        T ~ `Activity Type`
      )
    )
  
  duptyp <- c('Field Duplicate', 'Quality Control Sample-Lab Duplicate')
  if(any(duptyp %in% resdat_dup$`Activity Type`) & any(c('Field Duplicates', 'Lab Duplicates') %in% accchk)){
 
    dup <- resdat_dup %>% 
      dplyr::filter(`Activity Type` %in% duptyp) %>% 
      dplyr::mutate(ind = 1:n()) %>% 
      inner_join(accdat, by = c('Characteristic Name' = 'Parameter')) %>% 
      dplyr::select(
        ind, 
        `Activity Type`,
        Parameter = `Characteristic Name`, 
        Date = `Activity Start Date`, 
        `Sample ID` = `Result Attribute`,
        Site = `Monitoring Location ID`, 
        `Result Unit`,
        `Initial Result` = `Result Value`, 
        `Dup. Result` = `QC Reference Value`, 
        `Value Range`, 
        `Field Duplicate`,
        `Lab Duplicate`, 
        MDL, 
        UQL
      ) %>%
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
        ), 
        `Initial Result2` = as.numeric(`Initial Result2`),
        `Dup. Result2` = as.numeric(`Dup. Result2`), 
        `Avg. Result` = (`Initial Result2` + `Dup. Result2`) / 2
      ) %>% 
      dplyr::rowwise() %>% 
      dplyr::mutate( 
        `Initial Result` = ifelse(
          `Initial Result` %in% c('BDL', 'AQL'), 
          `Initial Result`,
          paste(round(as.numeric(`Initial Result`), 2), `Result Unit`)
        ),
        `Dup. Result` = ifelse(
          `Dup. Result` %in% c('BDL', 'AQL'),
          `Dup. Result`,
          paste(round(as.numeric(`Dup. Result`), 2), `Result Unit`)
        )
      ) %>%
      tidyr::unite('flt', `Avg. Result`, `Value Range`, sep = ' ', remove = FALSE) %>% 
      dplyr::rowwise() %>%
      dplyr::mutate(
        flt = ifelse(grepl('all', flt), T, eval(parse(text = flt)))
      ) %>% 
      dplyr::filter(flt) %>% 
      dplyr::group_by(ind) %>% 
      dplyr::mutate(
        `rngflt` = as.numeric(gsub(paste(colsym, collapse = '|'), '', `Value Range`))
      ) %>% 
      dplyr::filter(ifelse(is.na(rngflt), T, max(rngflt) == rngflt)) %>% 
      dplyr::ungroup()

    # field duplicates
    if('Field Duplicate' %in% dup$`Activity Type` & 'Field Duplicates' %in% accchk)
      flddup <- dup %>% 
        dplyr::filter(`Activity Type` %in% 'Field Duplicate') %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          diffv = dplyr::case_when(
            grepl('log', `Field Duplicate`) ~ abs(log(`Dup. Result2`) - log(`Initial Result2`)),
            T ~ abs(`Dup. Result2` - `Initial Result2`)
          ),
          percv = dplyr::case_when(
            grepl('log', `Field Duplicate`) ~ 100 * diffv / ((log(`Initial Result2`) + log(`Dup. Result2`)) / 2),
            T ~ 100 * diffv / ((`Initial Result2` + `Dup. Result2`) / 2)
          ),
          `Field Duplicate2` = gsub('%|log', '', `Field Duplicate`),
          `Hit/Miss` = dplyr::case_when(
            grepl('%|log', `Field Duplicate`) ~ eval(parse(text = paste(percv, `Field Duplicate2`))), 
            !grepl('%|log', `Field Duplicate`) ~ diffv <= `Field Duplicate`
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'), 
          percv = paste0(round(percv, digits), suffix, ' RPD'), 
          diffv = paste(round(diffv, 2), `Result Unit`), 
          `Diff./RPD` = ifelse(grepl('%', `Field Duplicate`), percv, diffv)
        ) %>% 
        dplyr::ungroup() %>% 
        dplyr::select(
          Parameter, Date, Site, `Initial Result`, `Dup. Result`, `Diff./RPD`, `Hit/Miss` 
        ) 

    # lab duplicates
    if('Quality Control Sample-Lab Duplicate' %in% dup$`Activity Type` & 'Lab Duplicates' %in% accchk)
      labdup <- dup %>% 
        dplyr::filter(`Activity Type` %in% 'Quality Control Sample-Lab Duplicate') %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          diffv = dplyr::case_when(
            grepl('log', `Lab Duplicate`) ~ abs(log(`Dup. Result2`) - log(`Initial Result2`)),
            T ~ abs(`Dup. Result2` - `Initial Result2`)
          ),
          percv = dplyr::case_when(
            grepl('log', `Lab Duplicate`) ~ 100 * diffv / ((log(`Initial Result2`) + log(`Dup. Result2`)) / 2),
            T ~ 100 * diffv / ((`Initial Result2` + `Dup. Result2`) / 2)
          ),
          `Lab Duplicate2` = gsub('%|log', '', `Lab Duplicate`),
          `Hit/Miss` = dplyr::case_when(
            grepl('%|log', `Lab Duplicate`) ~ eval(parse(text = paste(percv, `Lab Duplicate2`))), 
            !grepl('%|log', `Lab Duplicate`) ~ diffv <= `Lab Duplicate`
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          percv = paste0(round(percv, digits), suffix, ' RPD'),
          diffv = paste(round(diffv, 2), `Result Unit`),
          `Diff./RPD` = ifelse(grepl('%', `Lab Duplicate`), percv, diffv)
        ) %>% 
        dplyr::ungroup() %>% 
        dplyr::select(
          Parameter, Date, `Sample ID`, `Initial Result`, `Dup. Result`, `Diff./RPD`, `Hit/Miss` 
        ) 
      
  }
  
  # lab spikes and instrument checks
  # steps include replacing any recovered or standards as BDL/AQL with MDL/UQL for comparison
  # joining one to many of results to accuracy, then filtering results by range values in accuracy
  # comparing recovered and standards to accepted range in accuracy file
  labinstyp <- c('Quality Control Sample-Lab Spike', 'Quality Control Field Calibration Check')
  if(any(labinstyp %in% resdat$`Activity Type`) & any(c('Lab Spikes', 'Instrument Checks (post sampling)') %in% accchk)){
 
    labins <- resdat %>% 
      dplyr::filter(`Activity Type` %in% labinstyp) %>% 
      dplyr::mutate(ind = 1:n()) %>% 
      inner_join(accdat, by = c('Characteristic Name' = 'Parameter')) %>% 
      dplyr::select(
        ind,
        `Activity Type`,
        Parameter = `Characteristic Name`, 
        Date = `Activity Start Date`, 
        `Sample ID` = `Result Attribute`,
        Recovered = `Result Value`, 
        Standard = `QC Reference Value`, 
        `Result Unit`, 
        `Value Range`, 
        `Spike/Check Accuracy`, 
        MDL, 
        UQL
      ) %>% 
      dplyr::filter(!is.na(`Spike/Check Accuracy`)) %>% 
      dplyr::mutate(
        `Result Unit` = ifelse(Parameter == 'pH', 's.u.', `Result Unit`),
        `Recovered2` = dplyr::case_when(
          `Recovered` == 'BDL' ~ as.character(MDL), 
          `Recovered` == 'AQL' ~ as.character(UQL), 
          T ~ `Recovered`
        ), 
        `Standard2` = dplyr::case_when(
          `Standard` == 'BDL' ~ as.character(MDL), 
          `Standard` == 'AQL' ~ as.character(UQL), 
          T ~ `Standard`
        ),        
        `Recovered2` = as.numeric(`Recovered2`),
        `Standard2` = as.numeric(`Standard2`), 
        `Avg. Result` = (`Recovered2` + `Standard2`) / 2
      ) %>% 
      dplyr::rowwise() %>% 
      dplyr::mutate( 
        `Recovered` = ifelse(
          `Recovered` %in% c('BDL', 'AQL'), 
          `Recovered`,
          paste(round(as.numeric(`Recovered`), 2), `Result Unit`)
        ),
        `Standard` = ifelse(
          `Standard` %in% c('BDL', 'AQL'), 
          `Standard`, 
          paste(round(as.numeric(`Standard`), 2), `Result Unit`)
        )
      ) %>% 
      tidyr::unite('flt', `Avg. Result`, `Value Range`, sep = ' ', remove = FALSE) %>% 
      dplyr::rowwise() %>% 
      dplyr::mutate(
        flt = ifelse(grepl('all', flt), T, eval(parse(text = flt)))
      ) %>% 
      dplyr::filter(flt) %>% 
      dplyr::group_by(ind) %>% 
      dplyr::mutate(
        `rngflt` = as.numeric(gsub(paste(colsym, collapse = '|'), '', `Value Range`))
      ) %>% 
      dplyr::filter(ifelse(is.na(rngflt), T, max(rngflt) == rngflt)) %>% 
      dplyr::ungroup() %>% 
      mutate(
        diffv = abs(Recovered2 - Standard2),
        percv = 100 * diffv / Standard2,
        recov = 100 * Recovered2 / Standard2,
        per = grepl('%', `Spike/Check Accuracy`), 
        numref = as.numeric(gsub('%', '', `Spike/Check Accuracy`))
      ) 
    
    # lab spike
    if('Quality Control Sample-Lab Spike' %in% labins$`Activity Type` & 'Lab Spikes' %in% accchk){

      # get parameters relevant for lab spikes
      labpar <- paramsMWR %>% 
        dplyr::filter(Method == 'Lab') %>% 
        dplyr::pull(`Simple Parameter`) %>% 
        unique
      
      labspk <- labins %>% 
        dplyr::filter(`Activity Type` %in% 'Quality Control Sample-Lab Spike') %>% 
        dplyr::filter(`Parameter` %in% labpar) %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          `Hit/Miss` = dplyr::case_when(
            per ~ eval(parse(text = paste(percv, '<=', numref))), 
            !per ~ diffv <= numref
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          recov = paste0(round(recov, digits), suffix)
        ) %>% 
        dplyr::select(
          Parameter, 
          Date, 
          `Sample ID`, 
          Spike = Standard, 
          `Amt Recovered` = Recovered, 
          `% Recovery` = recov, 
          `Hit/Miss`
        ) %>% 
        dplyr::ungroup()
      
    }
    
    # instrument checks
    if('Quality Control Field Calibration Check' %in% labins$`Activity Type` & 'Instrument Checks (post sampling)' %in% accchk){
      
      # get parameters relevant for instrument checks
      inspar <- paramsMWR %>% 
        dplyr::filter(Method == 'InSitu') %>% 
        dplyr::pull(`Simple Parameter`) %>% 
        unique
      
      inschk <- labins %>% 
        dplyr::filter(`Activity Type` %in% 'Quality Control Field Calibration Check') %>% 
        dplyr::filter(Parameter %in% inspar) %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          `Hit/Miss` = dplyr::case_when(
            per ~ eval(parse(text = paste(percv, '<=', numref))), 
            !per ~ diffv <= numref
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          diffv = paste(round(diffv, 2), `Result Unit`)
        ) %>% 
        dplyr::select(
          Parameter, 
          Date, 
          `Sample ID`, 
          `Calibration Standard` = Standard, 
          `Instrument Reading` = Recovered, 
          `Accuracy` = diffv, 
          `Hit/Miss`
        ) %>% 
        dplyr::ungroup()
      
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
  out <- out[accchk]
  
  return(out)
  
}
