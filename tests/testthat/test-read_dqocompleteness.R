test_that("Checking dqo completeness output format", {
  result <- read_dqocompleteness(dqocompth)
  expect_type(result, 'list')
})
