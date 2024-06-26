test_that("Checking path input for res, acc, frecom, and sit", {
  result <- utilMWRinput(res = respth, acc = accpth, frecom = frecompth, sit = sitpth, wqx = wqxpth, runchk = F)
  expect_type(result, 'list')
})

test_that("Checking data frame input for res, acc, frecom, and sit", {
  result <- utilMWRinput(res = resdat, acc = accdat, frecom = frecomdat, sit = sitdat, wqx = wqxdat)
  expect_type(result, 'list')
})

test_that("Checking fset input", {
  result <- utilMWRinput(fset = list(res = resdat, acc = accdat, frecom = frecomdat, sit = sitdat, wqx = wqxdat))
  expect_type(result, 'list')
})

test_that("Checking missing file for path for res", {
  expect_error(utilMWRinput(res = '~/test'))
})

test_that("Checking missing file for path for acc", {
  expect_error(utilMWRinput(acc = '~/test'))
})

test_that("Checking missing file for path for frecom", {
  expect_error(utilMWRinput(frecom = '~/test'))
})

test_that("Checking missing file for path for sit", {
  expect_error(utilMWRinput(sit = '~/test'))
})

test_that("Checking missing file for path for wqx", {
  expect_error(utilMWRinput(wqx = '~/test'))
})
