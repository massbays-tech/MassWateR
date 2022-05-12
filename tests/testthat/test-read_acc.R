test_that("Checking dqo accuracy output format", {
  result <- read_acc(accpth)
  expect_s3_class(result, 'tbl_df')
})
