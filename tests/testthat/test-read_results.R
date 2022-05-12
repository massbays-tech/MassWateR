test_that("Checking read_results output format", {
  result <- read_results(respth)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking row length from read_results", {
  
  # form_results adds extra rows if values in QC Reference Value 
  result <- nrow(read_results(respth))
  expect_equal(result, 2586)
})