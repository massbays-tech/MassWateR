test_that("title with parameter only", {
  result <- utilMWRtitle(param = 'DO')
  expect_equal(result, 'DO')
})

test_that("title with parameter, date filter only", {
  result <- utilMWRtitle(param = 'DO', dtrng = 'test')
  expect_equal(result, 'DO, data filtered by date')
})

test_that("title with parameter and all filters", {
  result <- utilMWRtitle(param = 'DO', dtrng = 'test', resultatt = 'test', locgroup = 'test')
  expect_equal(result, 'DO, data filtered by date, result attributes, location groups')
})