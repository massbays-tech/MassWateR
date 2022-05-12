test_that("Checking path input for res and frecom", {
  result <- qc_completeness(respth, frecompth)
  NULL
})

test_that("Checking data frame input for res and frecom", {
  result <- qc_completeness(resdat, frecomdat)
  NULL
})

test_that("Checking missing file for path for res", {
  expect_error(qc_completeness('~/test', frecompth))
})

test_that("Checking missing file for path for frecom", {
  expect_error(qc_completeness(respth, '~/test'))
})

test_that("Checking warning if parameters from frecom missing in res", {
  expect_warning(qc_completeness(respth, frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qc_completeness(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
