test_that("Checking dqo completeness output format", {
  result <- read_dqocompleteness(dqocompth)
  expect_s3_class(result, 'tbl_df')
})
