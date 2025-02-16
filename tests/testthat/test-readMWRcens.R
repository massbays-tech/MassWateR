test_that("Checking readMWRcens output format", {
  result <- suppressWarnings(readMWRcens(tst$censpth))
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking column length from readMWRcens", {
  result <- suppressWarnings(ncol(readMWRcens(tst$censpth)))
  expect_equal(result, 2)
})
