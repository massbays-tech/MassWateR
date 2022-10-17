test_that("Verifying message output for report creation", {
  expect_message(readMWRresultsview(respth, columns = 'Characteristic Name'))
  file.remove(file.path(getwd(), 'resultsview.pdf'))
})


test_that("Checking error if incorrect value in columns", {
  expect_error(readMWRresultsview(respth, columns = c("Characeristic Name")))
})
