test_that("Checking output format by month, boxplot", {
  result <- anlzMWRseason(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'month', type = 'box')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by month, jittered boxplot", {
  result <- anlzMWRseason(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'month', type = 'jitterbox')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by week, barplot, and confint", {
  result <- anlzMWRseason(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'week', type = 'bar', confint = T)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by week, jittered barplot, and confint", {
  result <- anlzMWRseason(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'week', type = 'jitterbar', confint = T)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by week, jittered", {
  result <- anlzMWRseason(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'week', type = 'jitter')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by month, barplot, log scale", {
  result <- anlzMWRseason(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'month', type = 'bar', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})
