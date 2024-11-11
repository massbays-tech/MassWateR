test_that("Checking dqo accuracy output format", {
  result <- readMWRacc(tst$accpth)
  expect_s3_class(result, 'tbl_df')
})
