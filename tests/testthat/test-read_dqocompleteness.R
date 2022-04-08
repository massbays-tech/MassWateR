test_that("Checking dqo completeness output format", {
  result <- read_results(dqocompth)
  expect_type(result, 'list')
})
