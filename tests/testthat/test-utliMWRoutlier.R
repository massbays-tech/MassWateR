test_that("Testing output logscl false", {
  x <- rnorm(20)
  result <- utilMWRoutlier(x, logscl = FALSE)
  expect_type(result, 'logical')
})

test_that("Testing output logscl true", {
  x <- rlnorm(20)
  result <- utilMWRoutlier(x, logscl = TRUE)
  expect_type(result, 'logical')
})
