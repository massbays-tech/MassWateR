test_that("Checking output format", {
  result <- utilMWRfre(tst$resdat, tst$accdat, param = 'TP')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking error if unit mismatch between results and accuracy file", {
  tst$accdatchk <- tst$accdat %>% 
    mutate(
      uom = case_when(
        Parameter == 'Nitrate' ~ 'umol/l', 
        TRUE ~ uom
      )
    )
  expect_error(utilMWRfre(tst$resdat, tst$accdatchk, param = 'Nitrate'))
})

test_that("Checking output format if parameter not in accuracy file", {
  tst$accdatchk <- tst$accdat %>% 
    filter(!Parameter %in% 'TP')
  expect_warning(expect_s3_class(utilMWRfre(resdat = tst$resdat, accdat = tst$accdatchk, param = 'TP'), 'tbl_df'))
})

test_that("Check error if parameter not found", {
  expect_error(utilMWRfre(resdat = tst$resdat, param = 'notfound'))
})
