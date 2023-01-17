test_that("Verifying message output for report creation", {
  outpth <- tempdir()
  expect_message(readMWRresultsview(respth, output_dir = outpth))
  file.remove(file.path(outpth, 'resultsview.csv'))
})

test_that("Checking error if incorrect value in columns", {
  expect_error(readMWRresultsview(respth, columns = c("Characeristic Name")))
})