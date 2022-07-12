test_that("Checking output format by month", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month', jitter = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by site", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by week", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'week')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format log-scale", {
  result <- anlzMWRoutlier(res = resdat, param = 'E.coli', acc = accdat, group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Return outliers only", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month', outliers = TRUE)
  expect_s3_class(result, 'data.frame')
})

test_that("Testing no repel for outliers", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, group = 'month', repel = F)
  expect_s3_class(result, 'ggplot')
})
