test_that("Checking output format tibble, logscl FALSE", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  result <- utilMWRconfint(reschk, logscl = FALSE)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format tibble, logscl TRUE", {
  reschk <- utilMWRlimits(resdat, accdat, param = 'DO')
  result <- utilMWRconfint(reschk, logscl = TRUE)
  expect_s3_class(result, 'tbl_df')
})
