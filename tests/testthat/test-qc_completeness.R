test_that("Checking path input for res and dqocom", {
  result <- qc_completeness(respth, dqocompth)
  NULL
})

test_that("Checking data frame input for res and dqocom", {
  result <- qc_completeness(resdat, dqocomdat)
  NULL
})

test_that("Checking missing file for path for res", {
  expect_error(qc_completeness('~/test', dqocompth))
})

test_that("Checking missing file for path for dqocom", {
  expect_error(qc_completeness(respth, '~/test'))
})

test_that("Checking warning if parameters from dqocom missing in res", {
  expect_warning(qc_completeness(respth, dqocompth, runchk = F))
})

test_that("Checking output format", {
  result <- qc_completeness(respth, dqocompth, runchk = F, warn = F)
  expect_type(result, 'list')
})