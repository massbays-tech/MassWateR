test_that("Checking output format for type = 'summary'", {
  result <- tab_completeness(respth, frecompth, runchk = F, warn = F, type = 'summary')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format for type = 'percent'", {
  result <- tab_completeness(respth, frecompth, runchk = F, warn = F, type = 'percent')
  expect_s3_class(result, 'flextable')
})
