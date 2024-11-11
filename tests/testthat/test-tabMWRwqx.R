test_that("Verifying message output for wqx table creation", {
  expect_message(tabMWRwqx(tst$respth, tst$accpth, tst$sitpth, tst$wqxpth, warn = TRUE, runchk = F, output_dir = tempdir()))
})

test_that("Verifying message output for wqx table creation, no QC reference values", {
  reschk <- tst$resdat[is.na(tst$resdat$`QC Reference Value`), ]
  expect_message(tabMWRwqx(reschk, tst$accpth, tst$sitpth, tst$wqxpth, warn = TRUE, runchk = F, output_dir = tempdir()))
})

test_that("Check warning if UQL or MDL missing from tst$accdat", {
  accchk <- tst$accdat %>% 
    mutate(
      MDL = case_when(
        Parameter == 'Ammonia' ~ NA_real_, 
        T ~ MDL
      )
    )
  expect_warning(expect_message(tabMWRwqx(tst$respth, accchk, tst$sitpth, tst$wqxpth, warn = TRUE, runchk = F, output_dir = tempdir())))
})

test_that("Check warning no spatial information for sites", {
  sitchk <- tst$sitdat %>% 
    mutate(
      `Monitoring Location Latitude` = case_when(
        `Monitoring Location ID` == 'ABT-026' ~ NA_real_, 
        T ~ `Monitoring Location Latitude`
      )
    )
  expect_warning(expect_message(tabMWRwqx(tst$respth, tst$accpth, sitchk, tst$wqxpth, warn = TRUE, runchk = F, output_dir = tempdir())))
})
