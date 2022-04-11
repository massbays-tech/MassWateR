test_that("Checking dqo accuracy output format", {
  result <- read_dqoaccuracy(dqoaccpth)
  expect_type(result, 'list')
})
