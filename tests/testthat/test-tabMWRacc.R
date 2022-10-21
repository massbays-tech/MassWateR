test_that("Checking output format type error if individual and more than one table type", {
  expect_error(tabMWRacc(resdat, accdat, runchk = F, warn = F, type = 'individual'))
})

test_that("Checking output format type warning if individual and no table", {
  chk <- resdat %>% 
    filter(!`Activity Type` == 'Quality Control Sample-Field Blank')
  expect_warning(
    expect_null(
      tabMWRacc(chk, accdat, runchk = F, warn = T, type = 'individual', accchk = 'Field Blanks')
    )
  )
})

test_that("Checking output format type as individual", {
  result <- tabMWRacc(resdat, accdat, runchk = F, warn = F, type = 'individual', accchk = 'Instrument Checks')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as summary", {
  result <- tabMWRacc(respth, accpth, runchk = F, warn = F, type = 'summary', frecom = frecompth)
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as percent", {
  expect_warning(expect_warning(expect_warning(expect_s3_class(tabMWRacc(respth, accpth, runchk = F, warn = T, frecom = frecompth, type = 'percent'), 
                  'flextable'))))
})