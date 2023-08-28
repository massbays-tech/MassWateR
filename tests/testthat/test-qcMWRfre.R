test_that("Checking warning if parameters from res missing in frecom", {
  frecomdatchk <- readMWRfrecom(frecompth, runchk = F, warn = F)
  frecomdatchk <- frecomdatchk[-6, ]
  expect_warning(qcMWRfre(respth, accpth, frecomdatchk, runchk = F))
})

test_that("Checking warning if parameters from frecom missing in res", {
  resdatchk <- readMWRresults(respth, runchk = F, warn = F)
  resdatchk <- resdatchk %>% filter(!`Characteristic Name` %in% 'Nitrate')
  expect_warning(qcMWRfre(resdatchk, accpth, frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRfre(respth, accpth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
