test_that("Checking sites output format", {
  result <- readMWRsites(tst$sitpth)
  expect_s3_class(result, 'tbl_df')
})
