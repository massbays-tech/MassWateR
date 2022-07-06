test_that("Checking ouput format by month", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, type = 'month')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking ouput format by site", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, type = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking ouput format log-scale", {
  result <- anlzMWRoutlier(res = resdat, param = 'E.coli', acc = accdat, type = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Error if parameter not found", {
  expect_error(anlzMWRoutlier(res = resdat, param = 'notfound', acc = accdat, type = 'month'))
})

test_that("Return outliers only", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, type = 'month', outliers = TRUE)
  expect_s3_class(result, 'data.frame')
})

test_that("Testing no repel for outliers", {
  result <- anlzMWRoutlier(res = resdat, param = 'DO', acc = accdat, type = 'month', repel = F)
  expect_s3_class(result, 'ggplot')
})
