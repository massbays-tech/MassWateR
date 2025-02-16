test_that("Checking path input for res, acc, frecom, sit, wqx, and cens", {
  result <- utilMWRinput(res = tst$respth, acc = tst$accpth, frecom = tst$frecompth, sit = tst$sitpth, wqx = tst$wqxpth, tst$censpth, runchk = F)
  expect_type(result, 'list')
})

test_that("Checking data frame input for res, acc, frecom, sit, wqx, and cens", {
  result <- utilMWRinput(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, sit = tst$sitdat, wqx = tst$wqxdat, cens = tst$censdat)
  expect_type(result, 'list')
})

test_that("Checking fset input", {
  result <- utilMWRinput(fset = list(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, sit = tst$sitdat, wqx = tst$wqxdat, cens = tst$censdat))
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

test_that("Checking missing file for path for cens", {
  expect_error(utilMWRinput(cens = '~/test'))
})

