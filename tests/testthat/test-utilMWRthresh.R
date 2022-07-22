test_that("Checking output format", {
  result <- utilMWRthresh(resdat, param = 'TP', thresh = 'fresh')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format no marine threshold", {
  expect_null(utilMWRthresh(resdat, param = 'TP', thresh = 'marine'))
})

test_that("Checking output format no threshold", {
  expect_null(utilMWRthresh(resdat, param = 'Air Temp'))
})

test_that("Checking output format none", {
  expect_null(utilMWRthresh(resdat, param = 'TP', thresh = 'none'))
})

test_that("Checking error if unit mismatch",{
  
  resdatchk <- resdat %>% 
    mutate(
      `Result Unit` = case_when(
        `Characteristic Name` == 'Nitrate' ~ 'ug/l', 
        TRUE ~ `Result Unit`
      )
    )
  expect_error(utilMWRthresh(resdatchk, param = 'Nitrate', thresh = 'marine'))
  
})