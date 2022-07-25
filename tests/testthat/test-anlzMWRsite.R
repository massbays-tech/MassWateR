test_that("Checking output format jittered boxplot", {
  result <- anlzMWRsite(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", type = 'jitterbox')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered barplot", {
  result <- anlzMWRsite(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", type = 'jitterbar', confint = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered barplot, log scale", {
  result <- anlzMWRsite(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", type = 'jitterbar', yscl = 'log')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking param is a fecal indicator if fecalgrp is TRUE", {
  expect_error(anlzMWRsite(res = resdat, param = 'DO', acc = accdat, thresh = "fresh", fecalgrp = TRUE))
})

test_that("Checking output format jittered boxplot, fecalgrp", {
  result <- anlzMWRsite(res = resdat, param = 'E.coli', acc = accdat, thresh = "fresh", type = 'jitterbox', 
                        site = c('ABT-077', 'ABT-162', 'CND-009', 'CND-110', 'HBS-016', 'HBS-031'),
                        fecalgrp = TRUE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format jittered barplot, fecalgrp", {
  result <- anlzMWRsite(res = resdat, param = 'E.coli', acc = accdat, thresh = "fresh", type = 'jitterbar', 
                        site = c('ABT-077', 'ABT-162', 'CND-009', 'CND-110', 'HBS-016', 'HBS-031'),
                        fecalgrp = TRUE, confint = TRUE)
  expect_s3_class(result, 'ggplot')
})
