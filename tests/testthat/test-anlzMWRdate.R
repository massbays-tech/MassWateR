test_that("Checking output format group as site", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'site')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as site, repel = FALSE", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'site', repel = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as all", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'all', confint = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as all, log scale", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, thresh = "fresh", group = 'all', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as location", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, group = 'locgroup', 
                        thresh = 'fresh', locgroup = c('Assabet', 'Tributaries'), confint = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as location no location group specified", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, group = 'locgroup', 
                        thresh = 'fresh', confint = TRUE, repel = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format group as location, repel = FALSE", {
  result <- anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, group = 'locgroup', 
                        thresh = 'fresh', locgroup = c('Assabet', 'Tributaries'), repel = F)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking palcol error and locgroup < 3", {
  expect_error(anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, palcol = 'asdf', 
                        group = 'locgroup', thresh = 'fresh', 
                        locgroup = c('Assabet', 'Tributaries'), repel = F))
})

test_that("Checking palcol error and site < 3", {
  expect_error(anlzMWRdate(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, palcol = 'asdf', 
                           group = 'site', thresh = 'fresh', site = c("ABT-026", "ABT-077"), 
                           repel = F))
})


