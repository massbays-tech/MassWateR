test_that("title with parameter only", {
  result <- utilMWRtitle(param = 'DO')
  expect_equal(result, 'DO')
})

test_that("title with parameter, date filter only", {
  result <- utilMWRtitle(param = 'DO', dtrng = 'test')
  expect_equal(result, 'DO, data filtered by dates')
})

test_that("title with parameter and all filters", {
  result <- utilMWRtitle(param = 'DO', site = 'test', dtrng = 'test', resultatt = 'test', 
                         locgroup = 'test')
  expect_equal(result, 'DO, data filtered by sites, dates, result attributes, location groups')
})