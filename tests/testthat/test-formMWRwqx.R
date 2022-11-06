test_that("Checking form wqx", {
  result <- formMWRwqx(wqxdat)
  expect_s3_class(result, 'tbl_df')
})
