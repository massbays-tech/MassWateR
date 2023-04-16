test_that("Checking output format tibble, mean", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  result <- utilMWRsummary(reschk, accdat, param = 'DO', confint = T)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format tibble, geomean", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  result <- utilMWRsummary(reschk, accdat, param = 'DO', confint = T, sumfun = 'geomean')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format tibble, min", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  result <- utilMWRsummary(reschk, accdat, param = 'DO', confint = F, sumfun = 'min')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking warning if CI is not calculated", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  expect_warning(utilMWRsummary(reschk[1, ], accdat, param = 'DO', confint = TRUE))
})

test_that("Checking warning if CI not possible for sumfun", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  expect_warning(utilMWRsummary(reschk, accdat, param = 'DO', sumfun = 'min', confint = TRUE))
})