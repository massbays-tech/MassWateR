test_that("Checking ouput format by month", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', type = 'month')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking ouput format by site", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', type = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Error if parameter not found", {
  expect_error(anlzMWRoutlier(res = resdat, param = 'notfound', type = 'month'))
})

test_that("Return outliers only", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', type = 'month', outliers = TRUE)
  expect_s3_class(result, 'data.frame')
})

test_that("Testing no repel for outliers", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', type = 'month', repel = F)
  expect_s3_class(result, 'ggplot')
})
