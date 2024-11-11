test_that("Verifying message output for report creation", {
  expect_message(readMWRresultsview(tst$respth, output_dir = tempdir()))
})

test_that("Checking error if incorrect value in columns", {
  expect_error(readMWRresultsview(tst$respth, columns = c("Characeristic Name"), output_dir = tempdir()))
})
