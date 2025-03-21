test_that("Checking output format", {
  result <- tabMWRcom(tst$respth, tst$frecompth, tst$censpth, runchk = F, warn = F)
  expect_s3_class(result, 'flextable')
})

test_that("Checking footer note if censored data not provided", {
  result <- tabMWRcom(tst$respth, tst$frecompth, runchk = F, warn = F)
  expect_equal(result$footer$dataset$Parameter, "No Censored file submitted. Percent Completeness calculated assuming zero missed/censored records.")
})
