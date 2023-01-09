test_that("Checking warning if parameters from res missing in frecom", {
  frecomdatchk <- readMWRfrecom(frecompth)
  frecomdatchk <- frecomdatchk[-6, ]
  expect_warning(qcMWRcom(respth, frecomdatchk, runchk = F))
})

test_that("Checking warning if parameters from frecom missing in res", {
  resdatchk <- readMWRresults(respth, runchk = F, warn = F)
  resdatchk <- resdatchk %>% filter(!`Characteristic Name` %in% 'Nitrate')
  expect_warning(qcMWRcom(resdatchk, frecompth, runchk = F))
})

test_that("Checking output format", {
  result <- qcMWRcom(respth, frecompth, runchk = F, warn = F)
  expect_s3_class(result, 'tbl_df')
})
