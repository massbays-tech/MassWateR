test_that("Checking dqo accuracy output format", {
  result <- read_dqoaccuracy(dqoaccpth)
  expect_s3_class(result, 'tbl_df')
})
