test_that("Checking output format type error if individual and more than one table type", {
  expect_error(tabMWRacc(resdat, accdat, frecomdat, runchk = F, warn = F, type = 'individual'),
               'accchk must have only one entry for type = "individual"')
})

test_that("Checking output format type error if individual and incorrect accchk", {
  expect_error(tabMWRacc(resdat, accdat, frecomdat, runchk = F, warn = F, type = 'individual', accchk = 'asdf'),
               'accchk must be one of Field Blanks, Lab Blanks, Field Duplicates, Lab Duplicates, Lab Spikes / Instrument Checks')
})

test_that("Checking output format type warning if individual and no table", {
  chk <- resdat %>% 
    filter(!`Activity Type` == 'Quality Control Sample-Field Blank')
  expect_warning(
    expect_null(
      tabMWRacc(chk, accdat, frecomdat, runchk = F, warn = T, type = 'individual', accchk = 'Field Blanks'),
      'No data to check for Field Blanks, valid accchk entries include Lab Blanks, Field Duplicates, Lab Duplicates, Lab Spikes / Instrument Checks'
    )
  )
})

test_that("Checking output format type as individual", {
  result <- tabMWRacc(resdat, accdat, frecomdat, runchk = F, warn = F, type = 'individual', accchk = 'Lab Spikes / Instrument Checks')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as summary", {
  result <- tabMWRacc(respth, accpth, frecompth, runchk = F, warn = F, type = 'summary')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as percent", {
  expect_s3_class(tabMWRacc(respth, accpth, frecompth, runchk = F, warn = T, type = 'percent'), 
                  'flextable')
})

test_that("Checking output warning if missing completeness data and format type as percent", {
  chk <- frecomdat
  chk$`% Completeness`[8] <- NA
  expect_warning(tabMWRacc(respth, accpth, chk, runchk = F, warn = T, type = 'percent'))
})

test_that("Checking error if no QC records or reference values and type as percent", {
  chk <- readMWRacc(accpth, runchk = F, warn = F) %>% 
    mutate_at(vars(matches('Duplicate|Blank|Accuracy')), function(x) NA)
  
  expect_error(tabMWRacc(respth, chk, frecompth, runchk = F, warn = T, type = 'percent'), 'No QC records or reference values for parameters with defined DQOs. Cannot create QC tables.')
})

test_that("Checking error if no QC records or reference values and type as individual", {
  chk <- readMWRacc(accpth, runchk = F, warn = F) %>% 
    mutate_at(vars(matches('Duplicate|Blank|Accuracy')), function(x) NA)
  
  expect_error(tabMWRacc(respth, chk, frecompth, runchk = F, warn = T, type = 'individual', accchk = 'Field Blanks'), 'No QC records or reference values for parameters with defined DQOs. Cannot create QC tables.')
})