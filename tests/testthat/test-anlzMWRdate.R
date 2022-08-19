test_that("Checking output format group as site", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as site, repel = FALSE", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", group = 'site', repel = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as all", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", group = 'all', confint = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as all, log scale", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", group = 'all', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as location", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, sit = sitdat, group = 'locgroup', 
                        thresh = 'fresh', locgroup = c('Lower Assabet', 'Upper Assabet'), confint = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as location no location group specified", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, sit = sitdat, group = 'locgroup', 
                        thresh = 'fresh', confint = TRUE, repel = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as location, repel = FALSE", {
  result <- anlzMWRdate(res = resdat, param = 'DO', acc = accdat, sit = sitdat, group = 'locgroup', 
                        thresh = 'fresh', locgroup = c('Lower Assabet', 'Upper Assabet'), repel = F)
  expect_s3_class(result, 'ggplot')
})