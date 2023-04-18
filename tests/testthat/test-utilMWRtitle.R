test_that("title with parameter only", {
  result <- utilMWRtitle(param = 'DO')
  expect_equal(result, 'DO')
})

test_that("title with parameter and summary function", {
  result <- utilMWRtitle(param = 'DO', accdat = accdat, sumfun = "auto")
  expect_equal(result, 'DO (mean)')
})

test_that("title with parameter, date filter only", {
  result <- utilMWRtitle(param = 'DO', dtrng = c('2021-05-01', '2021-07-31'))
  expect_equal(result, 'DO, data filtered by dates (1 May, 2021 to 31 July, 2021)')
})

test_that("title with parameter and all filters", {
  result <- utilMWRtitle(param = 'DO', site = 'test', dtrng = c('2021-05-01', '2021-07-31'), 
                         resultatt = 'test', locgroup = 'test')
  expect_equal(result, 'DO, data filtered by sites, dates (1 May, 2021 to 31 July, 2021), result attributes, location groups')
})