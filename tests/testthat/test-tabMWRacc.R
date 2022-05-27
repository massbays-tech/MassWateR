test_that("Checking output format type error if summary and more than one table type", {
  expect_error(tabMWRacc(resdat, accdat, runchk = F, warn = F, type = 'summary'))
})

test_that("Checking output format type error if summary and no table", {
  chk <- resdat %>% 
    filter(!`Activity Type` == 'Quality Control Sample-Field Blank')
  expect_error(tabMWRacc(chk, accdat, runchk = F, warn = F, type = 'summary', accchk = 'Field Blanks'))
})

test_that("Checking output format type as sumary", {
  result <- tabMWRacc(resdat, accdat, runchk = F, warn = F, type = 'summary', accchk = 'Field Blanks')
  expect_s3_class(result, 'flextable')
})

# test_that("Checking output format type as percent", {
#   result <- tabMWRacc(respth, accpth, runchk = F, warn = F, type = 'percent')
#   expect_s3_class(result, 'flextable')
# })