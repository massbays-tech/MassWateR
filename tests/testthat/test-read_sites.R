test_that("Checking sites output format", {
  result <- read_sites(sitpth)
  expect_type(result, 'list')
})
