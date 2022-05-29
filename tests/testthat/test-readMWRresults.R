test_that("Checking readMWRresults output format", {
  result <- readMWRresults(respth)
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking row length from readMWRresults", {
  
  # formMWRresults adds extra rows if values in QC Reference Value 
  result <- nrow(readMWRresults(respth))
  expect_equal(result, 2594)
})
