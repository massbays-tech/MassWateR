test_that("Checking output format type as summary", {
  result <- tabMWRfre(respth, frecompth, runchk = F, warn = F, type = 'summary')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as percent", {
  result <- tabMWRfre(respth, frecompth, runchk = F, warn = F, type = 'percent')
  expect_s3_class(result, 'flextable')
})