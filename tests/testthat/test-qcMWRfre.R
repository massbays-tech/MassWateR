test_that("Checking path input for res and frecom", {
  result <- qcMWRfre(respth, frecompth)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking data frame input for res and frecom", {
  result <- qcMWRfre(resdat, frecomdat)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking missing file for path for res", {
  expect_error(qcMWRfre('~/test', frecompth))
})

test_that("Checking missing file for path for frecom", {
  expect_error(qcMWRfre(respth, '~/test'))
})

test_that("Checking warning if parameters from frecom missing in res", {
  expect_warning(qcMWRfre(respth, frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRfre(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
