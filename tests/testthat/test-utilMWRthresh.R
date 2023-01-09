test_that("Checking output format", {
  result <- utilMWRthresh(resdat, param = 'TP', thresh = 'fresh')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format, pH exception", {
  result <- utilMWRthresh(resdat, param = 'pH', thresh = 'fresh')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format no marine threshold", {
  expect_null(utilMWRthresh(resdat, param = 'TP', thresh = 'marine'))
})

test_that("Checking output format none", {
  expect_null(utilMWRthresh(resdat, param = 'TP', thresh = 'none'))
})

test_that("Checking output format no parameter", {
  expect_null(utilMWRthresh(resdat, param = 'asdf', thresh = 'marine'))
})

test_that("Checking error if unit mismatch",{
  
  resdatchk <- resdat %>% 
    mutate(
      `Result Unit` = case_when(
        `Characteristic Name` == 'TP' ~ 'mmol/l', 
        TRUE ~ `Result Unit`
      )
    )
  expect_error(utilMWRthresh(resdatchk, param = 'TP', thresh = 'marine'))
  
})

test_that("Checking output numeric", {
  result <- utilMWRthresh(resdat, param = 'TP', thresh = 5, threshlab = 'test')
  expect_s3_class(result, 'data.frame')
})

test_that("Checking error if output numeric and no threshlab", {
  expect_error(utilMWRthresh(resdat, param = 'TP', thresh = 5))
})