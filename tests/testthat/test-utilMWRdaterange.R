test_that("Check output as tibble", {
  result <- utilMWRdaterange(resdat, dtrng = c('2021-06-01', '2021-06-30'))
  expect_s3_class(result, 'tbl_df')
})

test_that("Check error if one date provided", {
  expect_error(utilMWRdaterange(resdat, dtrng = c('2021-06-01')), 'Must supply two dates for dtrng')
})

test_that("Check error if dates formatted wrong", {
  expect_error(utilMWRdaterange(resdat, dtrng = c('06-01-2021', '06-30-2021')), 
               'Dates not entered as YYYY-mm-dd: 06-01-2021, 06-30-2021')
})

test_that("Check error if no data availble", {
  expect_error(utilMWRdaterange(resdat, dtrng = c('2022-06-01', '2022-06-30')), 
               'No data available for date range')
})