test_that("Verifying message output for report creation", {
  expect_message(qcMWRreview(resdat, accdat, frecomdat, output_dir = getwd(), warn = FALSE))
})
