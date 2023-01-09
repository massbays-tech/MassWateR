test_that("Checking warning if parameters from acc missing in res", {
  accdatchk <- readMWRacc(accpth)
  accdatchk <- accdatchk[-9, ]
  expect_warning(qcMWRacc(respth, accdatchk, frecompth, runchk = F))
})

test_that("Checking error if unit mismatch between results and accuracy file", {
  resdatchk <- resdat %>% 
    mutate(
      `Result Unit` = case_when(
        `Characteristic Name` == 'Chl a' ~ 'mg/l', 
        TRUE ~ `Result Unit`
      )
    )
  accdatchk <- accdat %>% 
    mutate(
      uom = case_when(
        Parameter == 'Nitrate' ~ 'umol/l', 
        TRUE ~ uom
      )
    )
  expect_error(qcMWRacc(resdatchk, accdatchk, frecomdat, warn = F))
})

test_that("Checking output format", {
  result <- qcMWRacc(respth, accpth, frecompth, runchk = F, warn = F)
  expect_type(result, 'list')
})
