test_that("Checking output format", {
  result <- tabMWRcom(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'flextable')
})
