test_that("Verifying message output for wqx table creation", {
  expect_message(tabMWRwqx(respth, accpth, sitpth, wqxpth, warn = FALSE))
  file.remove(file.path(getwd(), 'wqxtab.xlsx'))
})