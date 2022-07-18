test_that("Checking output format group as site", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as site, repel = FALSE", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'site', repel = FALSE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as all", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'all')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as all, log scale", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, group = 'all', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})