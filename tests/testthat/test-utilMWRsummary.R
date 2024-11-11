test_that("Checking output format tibble, mean", {
  reschk <- utilMWRlimits(tst$resdat, tst$accdat, param = 'DO')
  result <- utilMWRsummary(reschk, tst$accdat, param = 'DO', confint = T)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format tibble, geomean", {
  reschk <- utilMWRlimits(tst$resdat, tst$accdat, param = 'DO')
  result <- utilMWRsummary(reschk, tst$accdat, param = 'DO', confint = T, sumfun = 'geomean')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format tibble, min", {
  reschk <- utilMWRlimits(tst$resdat, tst$accdat, param = 'DO')
  result <- utilMWRsummary(reschk, tst$accdat, param = 'DO', confint = F, sumfun = 'min')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking warning if CI is not calculated", {
  reschk <- utilMWRlimits(tst$resdat, tst$accdat, param = 'DO')
  expect_warning(utilMWRsummary(reschk[1, ], tst$accdat, param = 'DO', confint = TRUE))
})

test_that("Checking warning if CI not possible for sumfun", {
  reschk <- utilMWRlimits(tst$resdat, tst$accdat, param = 'DO')
  expect_warning(utilMWRsummary(reschk, tst$accdat, param = 'DO', sumfun = 'min', confint = TRUE))
})
