test_that("Checking output format with date range, site, result attribute, and location group filter", {
  result <- utilMWRfilter(tst$resdat, tst$sitdat, dtrng = c('2022-06-01', '2022-06-30'),
                          param = 'DO', site = 'ABT-077', resultatt = c('WET'), locgroup = 'Assabet')
  expect_s3_class(result, 'tbl_df')
})

test_that("Check error if one date provided", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', dtrng = c('2021-06-01')), 'Must supply two dates for dtrng')
})

test_that("Check error if dates formatted wrong", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', dtrng = c('06-01-2021', '06-30-2021')),
               'Dates in dtrng not entered as YYYY-MM-DD')
})

test_that("Check error if no data available", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', dtrng = c('2021-06-01', '2021-06-30')),
               'No data available for date range')
})

test_that("Check error if site not found", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', site = 'notfound'))
})

test_that("Check error if parameter not found", {
  expect_error(utilMWRfilter(tst$resdat, param = 'notfound'))
})

test_that("Check error if result attribute not found", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', resultatt = 'notfound'),
               'Result attributes not found in results file for DO: notfound, should be any of DRY, WET')
})

test_that("Check error if location group provided with no tst$sitdat", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', locgroup = 'Assabet'),
               'Site metadata file required if filtering by location group')
})

test_that("Check error if location group not found", {
  expect_error(utilMWRfilter(tst$resdat, param = 'DO', tst$sitdat, locgroup = 'notfound'),
               'Location group not found in site metadata file for DO: notfound, should be any of Assabet, Tributaries')
})
