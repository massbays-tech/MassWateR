test_that("Checking warning if parameters in res missing from acc", {
  tst$accdatchk <- readMWRacc(tst$accpth, runchk = F, warn = F)
  tst$accdatchk <- tst$accdatchk[-9, ]
  expect_warning(qcMWRacc(tst$respth, tst$accdatchk, tst$frecompth, runchk = F))
})

test_that("Checking warning if parameters in acc missing from res", {
  tst$resdatchk <- readMWRresults(tst$respth, runchk = F, warn = F)
  tst$resdatchk <- tst$resdatchk %>% filter(!`Characteristic Name` %in% 'Nitrate')
  expect_warning(qcMWRacc(tst$resdatchk, tst$accpth, tst$frecompth, runchk = F))
})

test_that("Checking warning if gap in value range", {
  tst$accdatchk <- readMWRacc(tst$accpth, runchk = F, warn = F)
  tst$accdatchk$`Value Range`[12] <- '>60'
  tst$accdatchk$`Value Range`[10] <- '>12'
  tst$accdatchk$`Value Range`[3] <- '< 1'
  expect_warning(qcMWRacc(tst$respth, tst$accdatchk, tst$frecompth, runchk = F), regexp = 'Gap in value range in DQO accuracy file: Ammonia, DO, E.coli', fixed = T)
})

test_that("Checking error if unit mismatch between results and accuracy file", {
  tst$resdatchk <- tst$resdat %>% 
    mutate(
      `Result Unit` = case_when(
        `Characteristic Name` == 'Chl a' ~ 'mg/l', 
        TRUE ~ `Result Unit`
      )
    )
  tst$accdatchk <- tst$accdat %>% 
    mutate(
      uom = case_when(
        Parameter == 'Nitrate' ~ 'umol/l', 
        TRUE ~ uom
      )
    )
  expect_error(qcMWRacc(tst$resdatchk, tst$accdatchk, tst$frecomdat, warn = F))
})

test_that("Checking output format", {
  result <- qcMWRacc(tst$respth, tst$accpth, tst$frecompth, runchk = F, warn = F)
  expect_type(result, 'list')
})

test_that("Checking empty data frame in list output", {
  accchk <- readMWRacc(tst$accpth, runchk = F) %>% 
    mutate(
      `Spike/Check Accuracy` = case_when(
        # Parameter %in% c('Ammonia', 'Nitrate', 'TP', 'pH', 'Sp Conductance', 'Water Temp') ~ NA_character_, 
        Parameter == 'DO' ~ '<= 3',
        T ~ NA_character_
      )
    )
  frecomchk <- readMWRfrecom(tst$frecompth, runchk = F) %>% 
    mutate(
      `Spike/Check Accuracy` = case_when(
        Parameter == 'DO' ~ 10, 
        T ~ NA_real_
      )
    )
  result <- qcMWRacc(tst$respth, accchk, frecomchk, runchk = F, warn = F)
  expect_type(result, 'list')
})

test_that("Checking error if upper value range for spikes/checks is not percent if unit is percent", {
  tst$accdatchk <- tst$accdat %>% 
    mutate(
      `Spike/Check Accuracy` = case_when(
        Parameter == 'TP' & grepl('>', `Value Range`) ~ '<= 15', 
        TRUE ~ `Spike/Check Accuracy`
      )
    )
  expect_error(qcMWRacc(tst$resdat, tst$accdatchk, tst$frecomdat, warn = F), 'Lab Spikes / Instrument Checks with units as % must have DQO accuracy as % for upper value range: TP')
})
