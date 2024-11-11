test_that("Checking readMWRresults output format", {
  result <- suppressWarnings(readMWRresults(tst$respth))
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking row length from readMWRresults", {
  result <- suppressWarnings(nrow(readMWRresults(tst$respth)))
  expect_equal(result, 571)
})
