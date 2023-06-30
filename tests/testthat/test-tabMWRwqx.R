test_that("Verifying message output for wqx table creation", {
  expect_message(tabMWRwqx(respth, accpth, sitpth, wqxpth, warn = TRUE, runchk = F, output_dir = tempdir()))
})

test_that("Verifying message output for wqx table creation, no QC reference values", {
  reschk <- resdat[is.na(resdat$`QC Reference Value`), ]
  expect_message(tabMWRwqx(reschk, accpth, sitpth, wqxpth, warn = TRUE, runchk = F, output_dir = tempdir()))
})

test_that("Check warning if UQL or MDL missing from accdat", {
  accchk <- accdat %>% 
    mutate(
      MDL = case_when(
        Parameter == 'Ammonia' ~ NA_real_, 
        T ~ MDL
      )
    )
  expect_warning(expect_message(tabMWRwqx(respth, accchk, sitpth, wqxpth, warn = TRUE, runchk = F, output_dir = tempdir())))
})

test_that("Check warning no spatial information for sites", {
  sitchk <- sitdat %>% 
    mutate(
      `Monitoring Location Latitude` = case_when(
        `Monitoring Location ID` == 'ABT-026' ~ NA_real_, 
        T ~ `Monitoring Location Latitude`
      )
    )
  expect_warning(expect_message(tabMWRwqx(respth, accpth, sitchk, wqxpth, warn = TRUE, runchk = F, output_dir = tempdir())))
})