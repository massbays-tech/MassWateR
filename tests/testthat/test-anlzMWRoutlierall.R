test_that("Verifying message output for Word report creation", {
  expect_message(anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'word', output_dir = getwd(), warn = FALSE))
  file.remove(file.path(getwd(), 'outlierall.docx'))
})

test_that("Verifying message output for png creation", {
  expect_message(anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'png', output_dir = getwd(), warn = FALSE))
  fls <- list.files(pattern = '\\.png$')
  file.remove(fls)
})
