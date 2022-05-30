test_that("Checking path input for res, acc, and frecom", {
  result <- utilMWRinput(res = respth, acc = accpth, frecom = frecompth, runchk = F)
  expect_type(result, 'list')
})

test_that("Checking data frame input for res, acc, and frecom", {
  result <- utilMWRinput(res = resdat, acc = accdat, frecom = frecomdat)
  expect_type(result, 'list')
})

test_that("Checking  NULL inputs for acc and frecom", {
  result <- utilMWRinput(res = resdat, acc = NULL, frecom = NULL)
  expect_type(result, 'list')
})

test_that("Checking missing file for path for res", {
  expect_error(utilMWRinput(res = '~/test', acc = accdat, frecom = frecomdat))
})

test_that("Checking missing file for path for acc", {
  expect_error(utilMWRinput(res = resdat, acc = '~/test', frecom = frecomdat))
})

test_that("Checking missing file for path for frecom", {
  expect_error(utilMWRinput(res = resdat, acc = accdat, frecom = '~/test'))
})
