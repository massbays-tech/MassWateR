test_that("Checking output format type error if individual and more than one table type", {
  expect_error(tabMWRacc(resdat, accdat, runchk = F, warn = F, type = 'individual'))
})

test_that("Checking output format type error if individual and no table", {
  chk <- resdat %>% 
    filter(!`Activity Type` == 'Quality Control Sample-Field Blank')
  expect_error(tabMWRacc(chk, accdat, runchk = F, warn = F, type = 'individual', accchk = 'Field Blanks'))
})

test_that("Checking output format type as individual", {
  result <- tabMWRacc(resdat, accdat, runchk = F, warn = F, type = 'individual', accchk = 'Field Blanks')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as summary", {
  result <- tabMWRacc(respth, accpth, runchk = F, warn = F, type = 'summary')
  expect_s3_class(result, 'flextable')
})

test_that("Checking output format type as percent", {
  result <- tabMWRacc(respth, accpth, runchk = F, warn = F, frecom = frecompth, type = 'percent')
  expect_s3_class(result, 'flextable')
})

test_that("Checking error if frecom absent and type as percent", {
  expect_error(tabMWRacc(respth, accpth, runchk = F, warn = F, type = 'percent'))
})