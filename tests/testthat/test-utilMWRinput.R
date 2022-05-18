test_that("Checking path input for res and frecom", {
  result <- utilMWRinput(respth, frecompth)
  expect_type(result, 'list')
})

test_that("Checking data frame input for res and frecom", {
  result <- utilMWRinput(resdat, frecomdat)
  expect_type(result, 'list')
})

test_that("Checking missing file for path for res", {
  expect_error(utilMWRinput('~/test', frecompth))
})

test_that("Checking missing file for path for frecom", {
  expect_error(utilMWRinput(respth, '~/test'))
})
