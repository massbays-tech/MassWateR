test_that("Checking dqo completeness output format", {
  result <- read_frecom(frecompth)
  expect_s3_class(result, 'tbl_df')
})
