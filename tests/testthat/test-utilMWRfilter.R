test_that("Checking output format with date range, site, result attribute, and location group filter", {
  result <- utilMWRfilter(resdat = resdat, sitdat = sitdat, dtrng = c('2021-06-01', '2021-06-30'),
                          param = 'E.coli', site = 'ABT-077', resultatt = c('Dry'), locgroup = 'Lower Assabet')
  expect_s3_class(result, 'tbl_df')
})

test_that("Check error if one date provided", {
  expect_error(utilMWRfilter(resdat, param = 'DO', dtrng = c('2021-06-01')), 'Must supply two dates for dtrng')
})

test_that("Check error if dates formatted wrong", {
  expect_error(utilMWRfilter(resdat, param = 'DO', dtrng = c('06-01-2021', '06-30-2021')), 
               'Dates not entered as YYYY-MM-DD: 06-01-2021, 06-30-2021')
})

test_that("Check error if no data availble", {
  expect_error(utilMWRfilter(resdat, param = 'DO', dtrng = c('2022-06-01', '2022-06-30')), 
               'No data available for date range')
})

test_that("Check error if site not found", {
  expect_error(utilMWRfilter(resdat = resdat, param = 'DO', site = 'notfound'))
})

test_that("Check error if parameter not found", {
  expect_error(utilMWRfilter(resdat = resdat, param = 'notfound'))
})

test_that("Check error if result attribute not found", {
  expect_error(utilMWRfilter(resdat = resdat, param = 'E.coli', resultatt = 'notfound'), 
               'Result attributes not found in results file for E.coli: notfound, should be any of Dry, Wet')
})

test_that("Check error if location group provided with no sitdat", {
  expect_error(utilMWRfilter(resdat = resdat, param = 'DO', locgroup = 'Concord'), 
               'Site metadata file required if filtering by location group')
})

test_that("Check error if location group not found", {
  expect_error(utilMWRfilter(resdat = resdat, param = 'DO', sitdat = sitdat, locgroup = 'notfound'), 
               'Location group not found in site metadata file for DO: notfound, should be any of Concord, Headwater & Tribs, Lower Assabet, Sudbury, Upper Assabet')
})
