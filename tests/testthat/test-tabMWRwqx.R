test_that("Verifying message output for wqx table creation", {
  expect_message(tabMWRwqx(resdat, accdat, sitdat, wqxdat, warn = FALSE))
  file.remove(file.path(getwd(), 'wqxtab.xlsx'))
})