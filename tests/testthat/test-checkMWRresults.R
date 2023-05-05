test_that("Checking column name spelling", {
  chk <- resdat
  names(chk)[c(1, 3)] <- c('Result', 'Date')
  expect_error(checkMWRresults(chk))
})

test_that("Checking required column names are present", {
  chk <- resdat
  chk <- chk[, -10]
  expect_error(checkMWRresults(chk))
})

test_that("Checking correct Activity Types", {
  chk <- resdat
  chk[3, 2] <- 'Sample'
  chk[4, 2] <- 'Sample'
  chk[135, 2] <- 'Field'
  expect_error(checkMWRresults(chk))
})

test_that("Checking date formats", {
  chk <- resdat
  chk$`Activity Start Date` = as.character(chk$`Activity Start Date`)
  chk[4, 3] <- '12-30-2018'
  chk[5, 3] <- NA
  expect_error(checkMWRresults(chk))
})

test_that("Checking depth data are present", {
  chk <- resdat
  chk[2:3, 'Activity Depth/Height Measure'] <- NA
  chk[2:3, 'Activity Relative Depth Name'] <- NA
  expect_error(checkMWRresults(chk))
})

test_that("Checking non-numeric Activity Depth/Height Measure", {
  chk <- resdat
  chk$`Activity Depth/Height Measure`[5] <- 'a'
  chk$`Activity Depth/Height Measure`[6] <- 'baa'
  chk$`Activity Depth/Height Measure`[12] <- 'a'
  expect_error(checkMWRresults(chk))
})

test_that("Checking Activity Depth/Height Unit", {
  chk <- resdat
  chk$`Activity Depth/Height Unit`[12] <- 'FT'
  chk$`Activity Depth/Height Unit`[100] <- 'FT'
  chk$`Activity Depth/Height Unit`[101] <- 'meters'
  expect_error(checkMWRresults(chk))
})

test_that("Checking Activity Depth/Height Measure range", {
  chk <- resdat
  chk$`Activity Depth/Height Measure`[1] <- 3.4
  chk$`Activity Depth/Height Measure`[3] <- 1.1 
  chk$`Activity Depth/Height Unit`[3] <- 'm' 
  expect_warning(checkMWRresults(chk))
})

test_that("Checking Activity Relative Depth Name entries", {
  chk <- resdat
  chk[6, 7] <- 'Surf'
  chk[387, 7] <- 'nearbottom'
  expect_warning(checkMWRresults(chk))
})

test_that("Checking correct Characteristic Names", {
  chk <- resdat
  chk[12, 8] <- 'chla'
  chk[200, 8] <- 'chla'
  chk[500, 8] <- 'nitrogne'
  expect_warning(checkMWRresults(chk))
})

test_that("Checking entries in Result Value", {
  chk <- resdat
  chk[23, 9] <- '1.a09'
  chk[200, 9] <- 'MDL'
  chk[250, 9] <- 'MDL'
  expect_error(checkMWRresults(chk))
})

test_that("Checking entries in QC Reference Value", {
  chk <- resdat
  chk[27, 12] <- 'a.23'
  chk[200, 12] <- 'MDL'
  chk[250, 12] <- 'MDL'
  expect_error(checkMWRresults(chk))
})

test_that("Checking missing entries in Result Unit", {
  chk <- resdat
  chk[25, 10] <- NA
  chk[200, 10] <- NA
  chk[78, 10] <- NA # pH, will not trigger
  expect_error(checkMWRresults(chk))
})

test_that("Checking more than one unit type per parameter in Characteristic Name", {
  chk <- resdat
  chk[13, 10] <- 'F'
  expect_error(checkMWRresults(chk))
})

test_that("Checking incorrect unit type per parameter in Characteristic Name", {
  chk <- resdat
  chk[chk$`Characteristic Name` == 'Chl a', 10] <- 'micrograms/L'
  chk[chk$`Characteristic Name` == 'TP', 10] <- 'mg/L'
  expect_error(checkMWRresults(chk))
})

test_that("Checking tests if all Characteristic Name is correct", {
  chk <- resdat
  chk <- chk %>% 
    filter(!`Characteristic Name`%in% c('Air Temp', 'Gage')) %>% 
    filter(!`Activity Relative Depth Name` %in% 'Bottom')
  expect_message(checkMWRresults(chk), 'All checks passed!')
})






