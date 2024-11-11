test_that("Checking warning if parameters from res missing in frecom", {
  tst$frecomdatchk <- readMWRfrecom(tst$frecompth, runchk = F, warn = F)
  tst$frecomdatchk <- tst$frecomdatchk[-6, ]
  expect_warning(qcMWRfre(tst$respth, tst$accpth, tst$frecomdatchk, runchk = F))
})

test_that("Checking warning if parameters from frecom missing in res", {
  tst$resdatchk <- readMWRresults(tst$respth, runchk = F, warn = F)
  tst$resdatchk <- tst$resdatchk %>% filter(!`Characteristic Name` %in% 'Nitrate')
  expect_warning(qcMWRfre(tst$resdatchk, tst$accpth, tst$frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRfre(tst$respth, tst$accpth, tst$frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
