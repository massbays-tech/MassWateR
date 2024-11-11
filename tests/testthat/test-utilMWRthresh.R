test_that("Checking output format", {
  result <- utilMWRthresh(tst$resdat, param = 'TP', thresh = 'fresh')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format, pH exception", {
  result <- utilMWRthresh(tst$resdat, param = 'pH', thresh = 'fresh')
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking output format no marine threshold", {
  expect_null(utilMWRthresh(tst$resdat, param = 'TP', thresh = 'marine'))
})

test_that("Checking output format none", {
  expect_null(utilMWRthresh(tst$resdat, param = 'TP', thresh = 'none'))
})

test_that("Checking output format no parameter", {
  expect_null(utilMWRthresh(tst$resdat, param = 'asdf', thresh = 'marine'))
})

test_that("Checking error if unit mismatch",{
  
  tst$resdatchk <- tst$resdat %>% 
    mutate(
      `Result Unit` = case_when(
        `Characteristic Name` == 'TP' ~ 'mmol/l', 
        TRUE ~ `Result Unit`
      )
    )
  expect_error(utilMWRthresh(tst$resdatchk, param = 'TP', thresh = 'marine'))
  
})

test_that("Checking output numeric", {
  result <- utilMWRthresh(tst$resdat, param = 'TP', thresh = 5, threshlab = 'test')
  expect_s3_class(result, 'data.frame')
})

test_that("Checking error if output numeric and no threshlab", {
  expect_error(utilMWRthresh(tst$resdat, param = 'TP', thresh = 5))
})
