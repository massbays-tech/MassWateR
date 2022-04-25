test_that("Checking sites output format", {
  result <- read_sites(sitpth)
  expect_s3_class(result, 'tbl_df')
})
