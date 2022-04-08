test_that("Checking dqo accuracy output format", {
  result <- read_results(dqoaccpth)
  expect_type(result, 'list')
})
