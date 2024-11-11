test_that("Checking form wqx", {
  result <- formMWRwqx(tst$wqxdatchk)
  expect_s3_class(result, 'tbl_df')
})
