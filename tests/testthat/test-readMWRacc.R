test_that("Checking dqo accuracy output format", {
  result <- readMWRacc(accpth)
  expect_s3_class(result, 'tbl_df')
})
