test_that("log auto TRUE", {
  expect_true(utilMWRyscale(accdat, param = 'E.coli'))
})

test_that("linear force FALSE", {
  expect_false(utilMWRyscale(accdat, param = 'E.coli', yscl = 'linear'))
})

test_that("linear auto FALSE", {
  expect_false(utilMWRyscale(accdat, param = 'DO'))
})

test_that("log force TRUE", {
  expect_true(utilMWRyscale(accdat, param = 'DO', yscl = 'log'))
})