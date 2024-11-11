test_that("Checking output format", {
  result <- tabMWRcom(tst$respth, tst$frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'flextable')
})
