test_that("Verifying message output for report creation", {
  expect_message(qcMWRreview(resdat, accdat, frecomdat, warn = FALSE))
  file.remove(file.path(getwd(), 'qcreview.docx'))
})
