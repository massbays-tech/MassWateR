test_that("Checking readMWRwqz output format", {
  result <- suppressWarnings(readMWRwqx(wqxpth))
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking row length from readMWRwqx", {
  result <- suppressWarnings(nrow(readMWRwqx(wqxpth)))
  expect_equal(result, 5)
})
