test_that("Checking output format jittered boxplot", {
  result <- anlzMWRsite(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", type = 'jitterbox')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered barplot", {
  result <- anlzMWRsite(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", type = 'jitterbar', confint = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered barplot, log scale", {
  result <- anlzMWRsite(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", type = 'jitterbar', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered boxplot, byresultatt", {
  result <- anlzMWRsite(res = tst$resdat, param = 'Ammonia', acc = tst$accdat, thresh = "fresh", type = 'jitterbox', 
                        byresultatt = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered barplot, byresultatt", {
  result <- anlzMWRsite(res = tst$resdat, param = 'Ammonia', acc = tst$accdat, thresh = "fresh", type = 'jitterbar', 
                        byresultatt = TRUE, confint = TRUE, resultatt = c('DRY', 'WET'))
  expect_s3_class(result, 'ggplot')
})
