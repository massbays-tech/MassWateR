test_that("Checking warning if parameters from frecom missing in res", {
  expect_warning(qcMWRcom(respth, frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRcom(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
