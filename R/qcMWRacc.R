#' Run quality control accuracy checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, or \code{sit}, overrides the other arguments
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#' @param accchk character string indicating which accuracy check to return, one to any of \code{"Field Blanks"}, \code{"Lab Blanks"}, \code{"Field Duplicates"}, \code{"Lab Duplicates"}, \code{"Lab Spikes"}, or \code{"Instrument Checks"}
#' @param suffix character string indicating suffix to append to percentage values
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.
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
qcMWRacc <- function(res = NULL, acc = NULL, fset = NULL, runchk = TRUE, warn = TRUE, accchk = c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes', 'Instrument Checks'), suffix = '%'){
  
  utilMWRinputcheck(mget(ls()))
  
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, acc = acc, fset = fset, runchk = runchk, warn = warn)
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
    warning('Parameters in quality control objectives for accuracy not found in results data: ', paste(tochk, collapse = ', '), call. = FALSE)
  }

  # check parameters in results can be found in accuracy
  chk <- resdatprm %in% accprm
  if(any(!chk) & warn){
    tochk <- resdatprm[!chk]
    warning('Parameters in results not found in  quality control objectives for accuracy: ', paste(tochk, collapse = ', '), call. = FALSE)
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
      select(Parameter, MDL, uom, `Field Blank`, `Lab Blank`) %>% 
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
        `Quantitation Limit`, 
        MDL, 
        `MDL Unit` = uom, 
        `Field Blank`, 
        `Lab Blank`
      ) %>% 
      mutate(
        `Result Unit` = ifelse(Parameter == 'pH', 's.u.', `Result Unit`),
        isnum = suppressWarnings(as.numeric(Result)), 
        isnum = !is.na(isnum)
      ) %>% 
      dplyr::arrange(Parameter, -dplyr::desc(Date))

    # field blank
    if('Quality Control Sample-Field Blank' %in% blk$`Activity Type` & 'Field Blanks' %in% accchk & any(!is.na(blk$`Field Blank`)))
      fldblk <- blk %>%
        dplyr::filter(`Activity Type` == 'Quality Control Sample-Field Blank') %>% 
        dplyr::select(-`Activity Type`) %>% 
        dplyr::select(-`Sample ID`) %>% 
        dplyr::mutate(
          Threshold = ifelse(`Field Blank` != 'BDL', `Field Blank`, MDL), 
          Threshold = dplyr::case_when(
            Result != 'BDL' ~ Threshold, 
            Result == 'BDL' & is.na(`Quantitation Limit`) ~ Threshold,
            TRUE ~ Threshold
          ),
          Threshold = ifelse(Result == 'BDL' & !is.na(`Quantitation Limit`), `Quantitation Limit`, Threshold),
          Threshold = ifelse(grepl('<|=', Threshold), Threshold, paste('<', Threshold)),
          `Hit/Miss` = dplyr::case_when(
            isnum ~ paste(Result, Threshold),
            Result == 'AQL' ~ 'FALSE',
            Result == 'BDL' ~ 'TRUE', 
            T ~ 'TRUE'
          )
        ) %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          `Hit/Miss` = eval(parse(text = `Hit/Miss`)),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          `Result Unit` = ifelse(Result %in% c('AQL', 'BDL'), NA, `Result Unit`), 
          Threshold = as.numeric(gsub('<|=', '', Threshold)), 
          Result = ifelse(isnum, as.character(as.numeric(Result)), Result)
        ) %>% 
        tidyr::unite('Result', Result, `Result Unit`, sep = ' ', na.rm = TRUE) %>%
        tidyr::unite('Threshold', Threshold, `MDL Unit`, sep = ' ') %>% 
        dplyr::ungroup() %>% 
        dplyr::select(-`Field Blank`, -`Lab Blank`, -isnum, -`Quantitation Limit`, -MDL)
      
    # lab blank
    if('Quality Control Sample-Lab Blank' %in% blk$`Activity Type` & 'Lab Blanks' %in% accchk & any(!is.na(blk$`Lab Blank`)))
      labblk <- blk %>%
        dplyr::filter(`Activity Type` == 'Quality Control Sample-Lab Blank') %>% 
        dplyr::select(-`Activity Type`) %>% 
        dplyr::select(-`Site`) %>% 
        dplyr::mutate(
          Threshold = ifelse(`Lab Blank` != 'BDL', `Lab Blank`, MDL), 
          Threshold = dplyr::case_when(
            Result != 'BDL' ~ Threshold, 
            Result == 'BDL' & is.na(`Quantitation Limit`) ~ Threshold,
            TRUE ~ Threshold
          ),
          Threshold = ifelse(Result == 'BDL' & !is.na(`Quantitation Limit`), `Quantitation Limit`, Threshold),
          Threshold = ifelse(grepl('<|=', Threshold), Threshold, paste('<', Threshold)),
          `Hit/Miss` = dplyr::case_when(
            isnum ~ paste(Result, Threshold),
            Result == 'AQL' ~ 'FALSE',
            Result == 'BDL' ~ 'TRUE', 
            T ~ 'TRUE'
          )
        ) %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          `Hit/Miss` = eval(parse(text = `Hit/Miss`)),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          `Result Unit` = ifelse(Result %in% c('AQL', 'BDL'), NA, `Result Unit`), 
          Threshold = as.numeric(gsub('<|=', '', Threshold)), 
          Result = ifelse(isnum, as.character(as.numeric(Result)), Result)
        ) %>% 
        tidyr::unite('Result', Result, `Result Unit`, sep = ' ', na.rm = TRUE) %>%
        tidyr::unite('Threshold', Threshold, `MDL Unit`, sep = ' ') %>% 
        dplyr::ungroup() %>% 
        dplyr::select(-`Field Blank`, -`Lab Blank`, -isnum, -`Quantitation Limit`, -MDL)
    
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
        `Quantitation Limit`, 
        MDL, 
        UQL
      ) %>%
      dplyr::mutate(
        `Result Unit` = ifelse(Parameter == 'pH', 's.u.', `Result Unit`),
        `Initial Result2` = dplyr::case_when(
          `Initial Result` == 'BDL' & is.na(`Quantitation Limit`) ~ as.character(MDL), 
          `Initial Result` == 'BDL' & !is.na(`Quantitation Limit`) ~ as.character(`Quantitation Limit`), 
          `Initial Result` == 'AQL' & is.na(`Quantitation Limit`) ~ as.character(UQL),
          `Initial Result` == 'AQL' & !is.na(`Quantitation Limit`) ~ as.character(`Quantitation Limit`), 
          T ~ `Initial Result`
        ), 
        `Dup. Result2` = dplyr::case_when(
          `Dup. Result` == 'BDL' & is.na(`Quantitation Limit`) ~ as.character(MDL), 
          `Dup. Result` == 'BDL' & !is.na(`Quantitation Limit`) ~ as.character(`Quantitation Limit`), 
          `Dup. Result` == 'AQL' & is.na(`Quantitation Limit`) ~ as.character(UQL), 
          `Dup. Result` == 'AQL' & !is.na(`Quantitation Limit`) ~ as.character(`Quantitation Limit`), 
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
          paste(as.numeric(`Initial Result`), `Result Unit`)
        ),
        `Dup. Result` = ifelse(
          `Dup. Result` %in% c('BDL', 'AQL'),
          `Dup. Result`,
          paste(as.numeric(`Dup. Result`), `Result Unit`)
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
      dplyr::arrange(Parameter, -dplyr::desc(Date))

    # field duplicates
    if('Field Duplicate' %in% dup$`Activity Type` & 'Field Duplicates' %in% accchk & any(!is.na(dup$`Field Duplicate`)))
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
            !grepl('%|log', `Field Duplicate`) ~ eval(parse(text = paste(diffv, `Field Duplicate2`)))
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'), 
          percv = paste0(round(percv, 0), suffix, ' RPD'), 
          percv = ifelse(grepl('log', `Field Duplicate`), gsub('RPD', 'logRPD', percv), percv),
          diffv = paste(round(diffv, 3), `Result Unit`), 
          `Diff./RPD` = ifelse(grepl('%', `Field Duplicate`), percv, diffv)
        ) %>% 
        dplyr::ungroup() %>% 
        dplyr::select(
          Parameter, Date, Site, `Initial Result`, `Dup. Result`, `Diff./RPD`, `Hit/Miss` 
        ) 

    # lab duplicates
    if('Quality Control Sample-Lab Duplicate' %in% dup$`Activity Type` & 'Lab Duplicates' %in% accchk & any(!is.na(dup$`Lab Duplicate`)))
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
            !grepl('%|log', `Lab Duplicate`) ~ eval(parse(text = paste(diffv, `Lab Duplicate2`)))
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          percv = paste0(round(percv, 0), suffix, ' RPD'),
          percv = ifelse(grepl('log', `Field Duplicate`), gsub('RPD', 'logRPD', percv), percv),
          diffv = paste(round(diffv, 3), `Result Unit`),
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
  if(any(labinstyp %in% resdat$`Activity Type`) & any(c('Lab Spikes', 'Instrument Checks') %in% accchk)){
 
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
          paste(as.numeric(`Recovered`), `Result Unit`)
        ),
        `Standard` = ifelse(
          `Standard` %in% c('BDL', 'AQL'), 
          `Standard`, 
          paste(as.numeric(`Standard`), `Result Unit`)
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
        `Spike/Check Accuracy2` = gsub('%|log', '', `Spike/Check Accuracy`),
      ) %>% 
      dplyr::arrange(Parameter, -dplyr::desc(Date))

    # lab spike
    if('Quality Control Sample-Lab Spike' %in% labins$`Activity Type` & 'Lab Spikes' %in% accchk & any(!is.na(labins$`Spike/Check Accuracy`))){

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
            grepl('%|log', `Spike/Check Accuracy`) ~ eval(parse(text = paste(percv, `Spike/Check Accuracy2`))), 
            !grepl('%|log', `Spike/Check Accuracy`) ~ eval(parse(text = paste(diffv, `Spike/Check Accuracy2`)))
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          recov = paste0(round(recov, 0), suffix)
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
    if('Quality Control Field Calibration Check' %in% labins$`Activity Type` & 'Instrument Checks' %in% accchk & any(!is.na(labins$`Spike/Check Accuracy`))){
      
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
            grepl('%|log', `Spike/Check Accuracy`) ~ eval(parse(text = paste(percv, `Spike/Check Accuracy2`))), 
            !grepl('%|log', `Spike/Check Accuracy`) ~ eval(parse(text = paste(diffv, `Spike/Check Accuracy2`)))
          ),
          `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
          diffv = ifelse(Parameter == 'Sp Conductance',
                         paste(round(diffv, 1), `Result Unit`),
                         paste(round(diffv, 3), `Result Unit`)
          )
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
    `Instrument Checks` = inschk
  )
  out <- out[accchk]
  
  return(out)
  
}
