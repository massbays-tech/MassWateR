test_that("Checking warning if parameters from frecom missing in res", {
  expect_warning(expect_warning(qcMWRfre(resdat, frecomdat, runchk = F)))
})

test_that("Checking output format", {
  result <- qcMWRfre(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
