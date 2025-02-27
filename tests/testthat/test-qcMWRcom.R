test_that("Checking warning if parameters from res missing in frecom", {
  tst$frecomdatchk <- readMWRfrecom(tst$frecompth, runchk = F)
  tst$frecomdatchk <- tst$frecomdatchk[-6, ]
  expect_warning(qcMWRcom(tst$respth, tst$frecomdatchk, tst$censpth, runchk = F))
})

test_that("Checking warning if parameters from frecom missing in res", {
  tst$resdatchk <- readMWRresults(tst$respth, runchk = F, warn = F)
  tst$resdatchk <- tst$resdatchk %>% filter(!`Characteristic Name` %in% 'Nitrate')
  expect_warning(expect_warning(qcMWRcom(tst$resdatchk, tst$frecompth, tst$censpth, runchk = F)))
})

test_that("Checking error if parameters from frecom missing in cens", {
  tst$censdatchk <- readMWRcens(tst$censpth, runchk = F)
  tst$censdatchk <- tst$censdatchk %>% filter(!Parameter %in% 'DO')
  expect_error(qcMWRcom(tst$respth, tst$frecompth, tst$censdatchk, runchk = F))
})

test_that("Checking warning if parameters from cens missing in res", {
  tst$resdatchk <- readMWRresults(tst$respth, runchk = F, warn = F)
  tst$resdatchk <- tst$resdatchk %>% filter(!`Characteristic Name` %in% 'DO')
  expect_warning(expect_warning(qcMWRcom(tst$resdatchk, tst$frecompth, tst$censpth, runchk = F)))
})

test_that("Checking output format", {
  result <- qcMWRcom(tst$respth, tst$frecompth, tst$censpth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
