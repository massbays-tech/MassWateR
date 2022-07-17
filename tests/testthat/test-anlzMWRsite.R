test_that("Checking output format boxplot", {
  result <- anlzMWRsite(res = resdat, param = 'DO', acc = accdat, type = 'box', jitter = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format barplot", {
  result <- anlzMWRsite(res = resdat, param = 'DO', acc = accdat, type = 'bar')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format barplot, log scale", {
  result <- anlzMWRsite(res = resdat, param = 'DO', acc = accdat, type = 'bar', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})