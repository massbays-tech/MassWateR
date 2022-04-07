pth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')

dat <- readxl::read_excel(pth,
  col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text',
             'text', 'text', 'text', 'text'))

test_that("Checking column name spelling", {
  chk <- dat
  names(chk)[c(1, 3)] <- c('Result', 'Date')
  expect_error(check_results(chk))
})

test_that("Checking required column names are present", {
  chk <- dat
  chk <- chk[, -10]
  expect_error(check_results(chk))
})

test_that("Checking correct Activity Types", {
  chk <- dat
  chk[3, 2] <- 'Sample'
  chk[4, 2] <- 'Sample'
  chk[135, 2] <- 'Field'
  expect_error(check_results(chk))
})

test_that("Checking date formats", {
  chk <- dat
  chk[4, 3] <- NA
  chk[5, 3] <- NA
  expect_error(check_results(chk))
})

test_that("Checking time formats", {
  chk <- dat
  chk[120, 4] <- NA
  chk[125, 4] <- NA
  expect_error(check_results(chk))
})

test_that("Checking Relative Depth Catogery entries", {
  chk <- dat
  chk[6, 7] <- 'Surf'
  chk[387, 7] <- '1m'
  expect_error(check_results(chk))
})

test_that("Checking correct Characteristic Names", {
  chk <- dat
  chk[12, 8] <- 'chla'
  chk[200, 8] <- 'chla'
  chk[2500, 8] <- 'nitrogne'
  expect_error(check_results(chk))
})

test_that("Checking entires in Result Value", {
  chk <- dat
  chk[23, 9] <- '1.a09'
  chk[1103, 9] <- 'MDL'
  chk[1204, 9] <- 'MDL'
  expect_error(check_results(chk))
})

