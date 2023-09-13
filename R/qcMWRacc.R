#' Run quality control accuracy checks for water quality monitoring results
#'
#' @param res character string of path to the results file or \code{data.frame} for results returned by \code{\link{readMWRresults}}
#' @param acc character string of path to the data quality objectives file for accuracy or \code{data.frame} returned by \code{\link{readMWRacc}}
#' @param frecom character string of path to the data quality objectives file for frequency and completeness or \code{data.frame} returned by \code{\link{readMWRfrecom}}
#' @param fset optional list of inputs with elements named \code{res}, \code{acc}, \code{frecom}, \code{sit}, or \code{wqx} overrides the other arguments
#' @param runchk  logical to run data checks with \code{\link{checkMWRresults}} and \code{\link{checkMWRacc}}, applies only if \code{res} or \code{acc} are file paths
#' @param warn logical to return warnings to the console (default)
#' @param accchk character string indicating which accuracy check to return, one to any of \code{"Field Blanks"}, \code{"Lab Blanks"}, \code{"Field Duplicates"}, \code{"Lab Duplicates"}, or \code{"Lab Spikes / Instrument Checks"}
#' @param suffix character string indicating suffix to append to percentage values
#' 
#' @details The function can be used with inputs as paths to the relevant files or as data frames returned by \code{\link{readMWRresults}} and \code{\link{readMWRacc}}.  For the former, the full suite of data checks can be evaluated with \code{runkchk = T} (default) or suppressed with \code{runchk = F}.  In the latter case, downstream analyses may not work if data are formatted incorrectly. For convenience, a named list with the input arguments as paths or data frames can be passed to the \code{fset} argument instead. See the help file for \code{\link{utilMWRinput}}.
#' 
#' Note that accuracy is only evaluated on parameters in the \code{Parameter} column in the data quality objectives accuracy file.  A warning is returned if there are parameters in \code{Parameter} in the accuracy file that are not in \code{Characteristic Name} in the results file. 
#' 
#' Similarly, parameters in the results file in the \code{Characteristic Name} column that are not found in the data quality objectives accuracy file are not evaluated.  A warning is returned if there are parameters in \code{Characteristic Name} in the results file that are not in \code{Parameter} in the accuracy file.
#' 
#' The data quality objectives file for frequency and completeness is used to screen parameters in the results file for inclusion in the accuracy tables.  Parameters with empty values in the frequency and completeness table are not returned.
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
#' # frequency and completeness path
#' frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
#'      package = 'MassWateR')
#' 
#' qcMWRacc(res = respth, acc = accpth, frecom = frecompth)
#' 
qcMWRacc <- function(res = NULL, acc = NULL, frecom = NULL, fset = NULL, runchk = TRUE, warn = TRUE, accchk = c('Field Blanks', 'Lab Blanks', 'Field Duplicates', 'Lab Duplicates', 'Lab Spikes / Instrument Checks'), suffix = '%'){
  
  utilMWRinputcheck(mget(ls()))
  
  colsym <- c('<=', '<', '>=', '>', '\u00b1', '\u2265', '\u2264', '%', 'AQL', 'BDL', 'log', 'all')
  
  ##
  # get user inputs
  inp <- utilMWRinput(res = res, acc = acc, frecom = frecom, fset = fset, runchk = runchk, warn = warn)
  resdat <- inp$resdat
  accdat <- inp$accdat
  frecomdat <- inp$frecomdat
  
  # create NA for parameters in accdat that have empty entries in frecomdat
  frecomdatna <- frecomdat %>% 
    select(-`% Completeness`)
  names(frecomdatna) <- paste0(names(frecomdatna), 'na')
  accdat <- accdat %>% 
    dplyr::left_join(frecomdatna, by = c('Parameter' = 'Parameterna')) %>% 
    dplyr::rowwise() %>% 
    dplyr::mutate(
      `Field Duplicate` = ifelse(is.na(`Field Duplicatena`), NA, `Field Duplicate`),
      `Lab Duplicate` = ifelse(is.na(`Lab Duplicatena`), NA, `Lab Duplicate`),
      `Field Blank` = ifelse(is.na(`Field Blankna`), NA, `Field Blank`),
      `Lab Blank` = ifelse(is.na(`Lab Blankna`), NA, `Lab Blank`),
      `Spike/Check Accuracy` = ifelse(is.na(`Spike/Check Accuracyna`), NA, `Spike/Check Accuracy`),
    ) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(-`Field Duplicatena`, -`Lab Duplicatena`, -`Field Blankna`, -`Lab Blankna`, -`Spike/Check Accuracyna`)

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
    warning('Parameters in results not found in quality control objectives for accuracy: ', paste(tochk, collapse = ', '), call. = FALSE)
  }
  
  # parameters for accuracy checks
  prms <- accprm[chk]

  # check units in resdat match those in accuracy file (excludes % or % recovery in spikes for resdat)
  accuni <- accdat %>% 
    dplyr::select(
      `Characteristic Name` = Parameter, 
      `uom`
    ) %>% 
    unique
  resdatuni <- resdat[, c('Characteristic Name', 'Result Unit', 'Activity Type')] %>% 
    dplyr::filter(!(`Activity Type` %in% 'Quality Control Sample-Lab Spike' & `Result Unit` %in% c('%', '% recovery'))) %>% 
    dplyr::select(-`Activity Type`) %>% 
    unique()
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
  
  # ##
  # # warning if value ranges in accdat do not cover complete range
  
  if(warn){
    typ <- utilMWRvaluerange(accdat)
    chk <- !typ %in% 'gap'
    if(any(!chk)){
      nms <- names(typ)[!chk]
      warning('Gap in value range in DQO accuracy file: ', paste(nms, collapse = ', '), call. = FALSE)
    }
  }

  ##
  # accuracy checks
  
  # NULL if relevant activity types not found
  fldblk <- NULL
  labblk <- NULL
  flddup <- NULL
  labdup <- NULL
  labins <- NULL
  
  # field and lab blank
  blktyp <- c('Quality Control Sample-Field Blank', 'Quality Control Sample-Lab Blank', 'Quality Control-Meter Lab Blank')
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
      dplyr::arrange(Parameter, -dplyr::desc(Date), .locale = 'en')

    # field blank
    if('Quality Control Sample-Field Blank' %in% blk$`Activity Type` & 'Field Blanks' %in% accchk & any(!is.na(blk$`Field Blank`)))
      fldblk <- blk %>%
        dplyr::filter(`Activity Type` == 'Quality Control Sample-Field Blank') %>% 
        dplyr::filter(!is.na(`Field Blank`)) %>% 
        dplyr::select(-`Activity Type`) %>% 
        dplyr::select(-`Sample ID`) %>% 
        dplyr::mutate(
          Threshold = ifelse(`Field Blank` != 'BDL', `Field Blank`, MDL), 
          Threshold = ifelse(
            Result != 'BDL', Threshold,
              ifelse(Result == 'BDL' & is.na(`Quantitation Limit`), 
                     Threshold,
                  Threshold
              )
          ),
          Threshold = ifelse(Result == 'BDL' & !is.na(`Quantitation Limit`), `Quantitation Limit`, Threshold),
          Threshold = ifelse(grepl('<|=', Threshold), Threshold, paste('<', Threshold)),
          `Hit/Miss` = ifelse(
            isnum, paste(Result, Threshold),
              ifelse(Result == 'AQL', 'FALSE',
                ifelse(Result == 'BDL', 'TRUE', 
                  'TRUE'
                )
              )
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
    if(any(c('Quality Control Sample-Lab Blank', 'Quality Control-Meter Lab Blank') %in% blk$`Activity Type`) & 'Lab Blanks' %in% accchk & any(!is.na(blk$`Lab Blank`)))
      labblk <- blk %>%
        dplyr::filter(`Activity Type` %in% c('Quality Control Sample-Lab Blank', 'Quality Control-Meter Lab Blank')) %>% 
        dplyr::filter(!is.na(`Lab Blank`)) %>% 
        dplyr::select(-`Activity Type`) %>% 
        dplyr::select(-`Site`) %>% 
        dplyr::mutate(
          Threshold = ifelse(`Lab Blank` != 'BDL', `Lab Blank`, MDL), 
          Threshold = ifelse(
            Result != 'BDL', Threshold,
            ifelse(Result == 'BDL' & is.na(`Quantitation Limit`), Threshold,
            Threshold
            )
          ),
          Threshold = ifelse(Result == 'BDL' & !is.na(`Quantitation Limit`), `Quantitation Limit`, Threshold),
          Threshold = ifelse(grepl('<|=', Threshold), Threshold, paste('<', Threshold)),
          `Hit/Miss` = ifelse(
            isnum, paste(Result, Threshold),
            ifelse(Result == 'AQL', 'FALSE',
                   ifelse(Result == 'BDL', 'TRUE', 
                  'TRUE'
                   )
            )
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
      `Activity Type` = ifelse(
        `Activity Type` %in% c('Field Msr/Obs', 'Sample-Routine') & !is.na(`QC Reference Value`),
        'Field Duplicate', 
        `Activity Type`
      )
    )
  
  duptyp <- c('Field Duplicate', 'Quality Control Sample-Lab Duplicate', 'Quality Control-Meter Lab Duplicate')
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
        `Initial Result2` = ifelse(
          `Initial Result` == 'BDL' & is.na(`Quantitation Limit`), as.character(MDL),
            ifelse(`Initial Result` == 'BDL' & !is.na(`Quantitation Limit`),as.character(`Quantitation Limit`), 
              ifelse(`Initial Result` == 'AQL' & is.na(`Quantitation Limit`), as.character(UQL),
                ifelse(`Initial Result` == 'AQL' & !is.na(`Quantitation Limit`), as.character(`Quantitation Limit`), `Initial Result`
                )
              )
            )
        ), 
        `Dup. Result2` = ifelse(
          `Dup. Result` == 'BDL' & is.na(`Quantitation Limit`), as.character(MDL), 
            ifelse(`Dup. Result` == 'BDL' & !is.na(`Quantitation Limit`), as.character(`Quantitation Limit`), 
              ifelse(`Dup. Result` == 'AQL' & is.na(`Quantitation Limit`), as.character(UQL), 
                ifelse(`Dup. Result` == 'AQL' & !is.na(`Quantitation Limit`), as.character(`Quantitation Limit`), `Dup. Result`
                )
              )
            )
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
      dplyr::arrange(Parameter, -dplyr::desc(Date), .locale = 'en')

    # field duplicates
    if('Field Duplicate' %in% dup$`Activity Type` & 'Field Duplicates' %in% accchk & any(!is.na(dup$`Field Duplicate`)))
      flddup <- dup %>% 
        dplyr::filter(`Activity Type` %in% 'Field Duplicate') %>% 
        dplyr::filter(!is.na(`Field Duplicate`)) %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          diffv = ifelse(
            grepl('log', `Field Duplicate`), abs(log(`Dup. Result2`) - log(`Initial Result2`)),
            abs(`Dup. Result2` - `Initial Result2`)
          ),
          percv = ifelse(
            grepl('log', `Field Duplicate`), 100 * diffv / ((log(`Initial Result2`) + log(`Dup. Result2`)) / 2),
            100 * diffv / ((`Initial Result2` + `Dup. Result2`) / 2)
          ),
          `Field Duplicate2` = gsub('%|log', '', `Field Duplicate`),
          `Hit/Miss` = ifelse(
            grepl('%|log', `Field Duplicate`) & !is.na(`Field Duplicate`), 
            eval(parse(text = paste(percv, `Field Duplicate2`))), 
              ifelse(
                !grepl('%|log', `Field Duplicate`) & !is.na(`Field Duplicate`), 
                eval(parse(text = paste(diffv, `Field Duplicate2`))), 
                NA
              )
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
    if(any(c('Quality Control Sample-Lab Duplicate', 'Quality Control-Meter Lab Duplicate') %in% dup$`Activity Type`) & 'Lab Duplicates' %in% accchk & any(!is.na(dup$`Lab Duplicate`)))
      labdup <- dup %>% 
        dplyr::filter(`Activity Type` %in% c('Quality Control Sample-Lab Duplicate', 'Quality Control-Meter Lab Duplicate')) %>% 
        dplyr::filter(!is.na(`Lab Duplicate`)) %>% 
        dplyr::rowwise() %>% 
        dplyr::mutate(
          diffv = ifelse(
            grepl('log', `Lab Duplicate`), abs(log(`Dup. Result2`) - log(`Initial Result2`)),
            abs(`Dup. Result2` - `Initial Result2`)
          ),
          percv = ifelse(
            grepl('log', `Lab Duplicate`), 100 * diffv / ((log(`Initial Result2`) + log(`Dup. Result2`)) / 2),
            100 * diffv / ((`Initial Result2` + `Dup. Result2`) / 2)
          ),
          `Lab Duplicate2` = gsub('%|log', '', `Lab Duplicate`),
          `Hit/Miss` = ifelse(
            grepl('%|log', `Lab Duplicate`) & !is.na(`Lab Duplicate`), 
            eval(parse(text = paste(percv, `Lab Duplicate2`))), 
            ifelse(
              !grepl('%|log', `Lab Duplicate`) & !is.na(`Lab Duplicate`), 
              eval(parse(text = paste(diffv, `Lab Duplicate2`))), 
              NA
            )
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
  labinstyp <- c('Quality Control Sample-Lab Spike', 'Quality Control-Calibration Check')
  if(any(labinstyp %in% resdat$`Activity Type`) & 'Lab Spikes / Instrument Checks' %in% accchk & any(!is.na(accdat$`Spike/Check Accuracy`))){

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
        `Recovered2` = ifelse(
          `Recovered` == 'BDL', as.character(MDL), 
            ifelse(`Recovered` == 'AQL', as.character(UQL), 
              `Recovered`
            )
        ), 
        `Standard2` = ifelse(
          `Standard` == 'BDL', as.character(MDL), 
            ifelse(`Standard` == 'AQL', as.character(UQL), 
              `Standard`
            )
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
          ifelse(
            Parameter == 'Sp Conductance',
            paste(round(as.numeric(`Recovered`), 1), `Result Unit`),
            paste(round(as.numeric(`Recovered`), 3), `Result Unit`)
          )
        ),
        `Standard` = ifelse(
          `Standard` %in% c('BDL', 'AQL'), 
          `Standard`, 
          ifelse(
            Parameter == 'Sp Conductance',
            paste(round(as.numeric(`Standard`), 1), `Result Unit`),
            paste(round(as.numeric(`Standard`), 3), `Result Unit`)
          )
        )
      ) %>% 
      tidyr::unite('flt', `Avg. Result`, `Value Range`, sep = ' ', remove = FALSE)
    
    # check that upper value range is a percent DQO for QC checks with result unit as %
    chk <- labins %>% 
      dplyr::filter(grepl('%', `Result Unit`)) %>% 
      dplyr::filter(grepl(">|\u2265", `Value Range`)) %>% 
      dplyr::filter(!grepl('%', `Spike/Check Accuracy`))
    
    if(nrow(chk) > 0){
      prms <- sort(unique(chk$Parameter))
      stop('Lab Spikes / Instrument Checks with units as % must have DQO accuracy as % for upper value range: ', paste(prms, collapse = ', '))
    }
    
    # continue  
    labins <- labins %>%  
      dplyr::rowwise() %>% 
      dplyr::mutate(
        flt = ifelse(grepl('all', flt), T, 
          ifelse(grepl('%', `Result Unit`) & grepl('>=|>|\u2265', `Value Range`), T, # handles checks where result unit is % to select upper value range
            ifelse(grepl('%', `Result Unit`) & grepl('<=|<|\u2264', `Value Range`), F, # handles checks where result unit is % to select upper value range
              eval(parse(text = flt))
            )
          )
        )
      ) %>% 
      dplyr::filter(flt) %>% 
      dplyr::group_by(ind) %>% 
      dplyr::mutate(
        `rngflt` = as.numeric(gsub(paste(colsym, collapse = '|'), '', `Value Range`))
      ) %>% 
      dplyr::filter(ifelse(is.na(rngflt), T, max(rngflt) == rngflt)) %>% 
      dplyr::ungroup() %>% 
      mutate(
        diffv = Recovered2 - Standard2,
        percv = 100 * diffv / Standard2,
        recov = 100 * Recovered2 / Standard2,
        `Spike/Check Accuracy2` = gsub('%|log', '', `Spike/Check Accuracy`),
      ) %>% 
      dplyr::arrange(Parameter, -dplyr::desc(Date), .locale = 'en') %>% 
      dplyr::rowwise() %>% 
      dplyr::mutate(
        `Hit/Miss` = ifelse(
          grepl('%|log', `Spike/Check Accuracy`) & !is.na(`Spike/Check Accuracy`), 
          eval(parse(text = paste(abs(percv), `Spike/Check Accuracy2`))), 
          ifelse(
            !grepl('%|log', `Spike/Check Accuracy`) & !is.na(`Spike/Check Accuracy`), 
            eval(parse(text = paste(diffv, `Spike/Check Accuracy`))), 
            NA
          )
        ),
        `Hit/Miss` = ifelse(`Hit/Miss`, NA_character_, 'MISS'),
        recov = paste0(round(recov, 0), suffix),
        signv = ifelse(sign(diffv) %in% c(1,0), '+', ''),
        diffv = ifelse(Parameter == 'Sp Conductance',
                       paste(paste0(signv, round(diffv, 1)), `Result Unit`),
                       paste(paste0(signv, round(diffv, 3)), `Result Unit`)
        ), 
        `Diff./Accuracy` = ifelse(
          grepl('%|log', `Spike/Check Accuracy`) & !is.na(`Spike/Check Accuracy`), 
          recov, 
          ifelse(
            !grepl('%|log', `Spike/Check Accuracy`) & !is.na(`Spike/Check Accuracy`), 
            diffv, 
            NA
          )
        )
      ) %>% 
      dplyr::select(
        Parameter, 
        Date, 
        `Sample ID`, 
        `Spike/Standard` = Standard, 
        Result = Recovered, 
        `Diff./Accuracy` = `Diff./Accuracy`, 
        `Hit/Miss`
      ) %>% 
      dplyr::ungroup() %>% 
      dplyr::arrange(Parameter, .locale = 'en')

  }

  # compile all as list since columns differ
  out <- list(
    `Field Blanks` = fldblk,
    `Lab Blanks` = labblk,
    `Field Duplicates` = flddup,
    `Lab Duplicates` = labdup, 
    `Lab Spikes / Instrument Checks` = labins
  )

  # fill nrow zero as NULL
  out <- lapply(out, function(x){
    if(!is.null(x))
      if(nrow(x) == 0) 
        x <- NULL
    x   
    })
  
  out <- out[accchk]

  return(out)
  
}
