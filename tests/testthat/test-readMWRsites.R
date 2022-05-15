test_that("Checking sites output format", {
  result <- readMWRsites(sitpth)
  expect_s3_class(result, 'tbl_df')
})
