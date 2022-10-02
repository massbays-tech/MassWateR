test_that("Checking table output for parameter, unit", {
  result <- readMWRresultspivot(respth, table = c('parameter, unit'))
  expect_s3_class(result, 'table')
})

test_that("Checking table output for activity type, parameter", {
  result <- readMWRresultspivot(respth, table = c('activity type, parameter'))
  expect_s3_class(result, 'table')
})
