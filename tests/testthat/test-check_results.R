test_that("Checking column name spelling", {
  chk <- resdat
  names(chk)[c(1, 3)] <- c('Result', 'Date')
  expect_error(check_results(chk))
})

test_that("Checking required column names are present", {
  chk <- resdat
  chk <- chk[, -10]
  expect_error(check_results(chk))
})

test_that("Checking correct Activity Types", {
  chk <- resdat
  chk[3, 2] <- 'Sample'
  chk[4, 2] <- 'Sample'
  chk[135, 2] <- 'Field'
  expect_error(check_results(chk))
})

test_that("Checking date formats", {
  chk <- resdat
  chk[4, 3] <- NA
  chk[5, 3] <- NA
  expect_error(check_results(chk))
})

test_that("Checking time formats", {
  chk <- resdat
  chk[120, 4] <- NA
  chk[125, 4] <- NA
  expect_error(check_results(chk))
})

test_that("Checking Relative Depth Catogery entries", {
  chk <- resdat
  chk[6, 7] <- 'Surf'
  chk[387, 7] <- '1m'
  expect_error(check_results(chk))
})

test_that("Checking correct Characteristic Names", {
  chk <- resdat
  chk[12, 8] <- 'chla'
  chk[200, 8] <- 'chla'
  chk[2500, 8] <- 'nitrogne'
  expect_error(check_results(chk))
})

test_that("Checking entries in Result Value", {
  chk <- resdat
  chk[23, 9] <- '1.a09'
  chk[1103, 9] <- 'MDL'
  chk[1204, 9] <- 'MDL'
  expect_error(check_results(chk))
})

test_that("Checking entries in QC Reference Value", {
  chk <- resdat
  chk[27, 12] <- 'a.23'
  chk[1099, 12] <- 'MDL'
  chk[1333, 12] <- 'MDL'
  expect_error(check_results(chk))
})


