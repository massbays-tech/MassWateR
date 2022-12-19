test_that("Verifying message output for wqx table creation", {
  expect_warning(expect_warning(expect_message(tabMWRwqx(respth, accpth, sitpth, wqxpth, warn = TRUE))))
  file.remove(file.path(getwd(), 'wqxtab.xlsx'))
})