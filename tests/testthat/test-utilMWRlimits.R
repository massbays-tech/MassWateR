test_that("Checking output format", {
  result <- utilMWRlimits(resdat, accdat, param = 'TP')
  expect_s3_class(result, 'tbl_df')
})

test_that("Error if parameter not found", {
  expect_error(utilMWRlimits(resdat = resdat, accdat = accdat, param = 'notfound'))
})

test_that("Checking error if unit mismatch between results and accuracy file", {
  accdatchk <- accdat %>% 
    mutate(
      uom = case_when(
        Parameter == 'Nitrate' ~ 'umol/l', 
        TRUE ~ uom
      )
    )
  expect_error(utilMWRlimits(resdat, accdatchk, param = 'Nitrate'))
})

test_that("Checking output format if parameter not in accuracy file", {
  expect_warning(expect_s3_class(utilMWRlimits(resdat = resdat, accdat = accdat, param = 'Air Temp'), 'tbl_df'))
})
