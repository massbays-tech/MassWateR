test_that("Checking readMWRwqz output format", {
  result <- suppressWarnings(readMWRwqx(tst$wqxpth))
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking row length from readMWRwqx", {
  result <- suppressWarnings(nrow(readMWRwqx(tst$wqxpth)))
  expect_equal(result, 8)
})
