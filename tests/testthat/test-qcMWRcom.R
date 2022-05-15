test_that("Checking path input for res and frecom", {
  result <- qcMWRcom(respth, frecompth)
  NULL
})

test_that("Checking data frame input for res and frecom", {
  result <- qcMWRcom(resdat, frecomdat)
  NULL
})

test_that("Checking missing file for path for res", {
  expect_error(qcMWRcom('~/test', frecompth))
})

test_that("Checking missing file for path for frecom", {
  expect_error(qcMWRcom(respth, '~/test'))
})

test_that("Checking warning if parameters from frecom missing in res", {
  expect_warning(qcMWRcom(respth, frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRcom(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
