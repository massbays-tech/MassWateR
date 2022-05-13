test_that("Checking output format", {
  result <- tab_completeness(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'flextable')
})