test_that("Checking table output", {
  result <- readMWRresultsview(respth, columns = "Characteristic Name")
  expect_s3_class(result, 'table')
})

test_that("Checking error if more than one entry", {
  expect_error(readMWRresultsview(respth, columns = c("Characeristic Name", "Result Unit", "Activity Type")))
})

test_that("Checking error if incorrect value in columns", {
  expect_error(readMWRresultsview(respth, columns = c("Characeristic Name", "Result unit")))
})
