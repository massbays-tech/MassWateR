test_that("Missing arguments for input check", {
  expect_error(tabMWRcom())
})

test_that("Missing fset elements for input check", {
  expect_error(tabMWRcom(fset = list(res = resdat)))
})