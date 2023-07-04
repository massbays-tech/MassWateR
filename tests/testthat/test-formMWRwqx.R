test_that("Checking form wqx", {
  result <- formMWRwqx(wqxdatchk)
  expect_s3_class(result, 'tbl_df')
})
