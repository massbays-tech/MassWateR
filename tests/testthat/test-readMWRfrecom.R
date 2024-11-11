test_that("Checking dqo frequency and completeness output format", {
  result <- readMWRfrecom(tst$frecompth)
  expect_s3_class(result, 'tbl_df')
})
