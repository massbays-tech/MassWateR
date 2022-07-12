test_that("Checking output format by month, boxplot", {
  result <- anlzMWRseason(res = resdat, param = 'DO', acc = accdat, group = 'month', type = 'box', jitter = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by week, barplot", {
  result <- anlzMWRseason(res = resdat, param = 'DO', acc = accdat, group = 'week', type = 'bar')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format by month, barplot, log scale", {
  result <- anlzMWRseason(res = resdat, param = 'DO', acc = accdat, group = 'month', type = 'bar', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})