test_that("Checking warning if parameters from res missing in frecom", {
  tst$frecomdatchk <- readMWRfrecom(tst$frecompth)
  tst$frecomdatchk <- tst$frecomdatchk[-6, ]
  expect_warning(qcMWRcom(tst$respth, tst$frecomdatchk, runchk = F))
})

test_that("Checking warning if parameters from frecom missing in res", {
  tst$resdatchk <- readMWRresults(tst$respth, runchk = F, warn = F)
  tst$resdatchk <- tst$resdatchk %>% filter(!`Characteristic Name` %in% 'Nitrate')
  expect_warning(qcMWRcom(tst$resdatchk, tst$frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRcom(tst$respth, tst$frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
