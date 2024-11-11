test_that("Checking output format by month", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'DO', acc = tst$accdat, group = 'month')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by site and jitterbox", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'DO', type = 'jitterbox', acc = tst$accdat, group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by month and jitter", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'DO', type = 'jitter', acc = tst$accdat, group = 'month')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by week", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'DO', acc = tst$accdat, group = 'week')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format log-scale", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'E.coli', acc = tst$accdat, group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Return outliers only", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'DO', acc = tst$accdat, group = 'month', outliers = TRUE)
  expect_s3_class(result, 'data.frame')
})

test_that("Testing no repel for outliers", {
  result <- anlzMWRoutlier(res = tst$resdat, param = 'DO', acc = tst$accdat, group = 'month', repel = F)
  expect_s3_class(result, 'ggplot')
})
