test_that("Checking read_results output format", {
  result <- read_results(respth)
  expect_type(result, 'list')
})

test_that("Checking row length from read_results", {
  
  # form_results adds extra rows if values in QC Reference Value 
  result <- nrow(read_results(respth))
  expect_equal(result, 2653)
})