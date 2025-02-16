test_that("Checking form cens", {
  result <- formMWRcens(tst$censdatchk)
  expect_s3_class(result, 'tbl_df')
})
