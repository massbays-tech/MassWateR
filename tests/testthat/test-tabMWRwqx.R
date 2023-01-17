test_that("Verifying message output for wqx table creation", {
  expect_warning(expect_message(tabMWRwqx(respth, accpth, sitpth, wqxpth, warn = TRUE, output_dir = tempdir())))
})

test_that("Check warning if UQL or MDL missing from accdat", {
  accchk <- accdat %>% 
    mutate(
      MDL = case_when(
        Parameter == 'Ammonia' ~ NA_real_, 
        T ~ MDL
      )
    )
  expect_warning(expect_warning(expect_message(tabMWRwqx(respth, accchk, sitpth, wqxpth, warn = TRUE, output_dir = tempdir()))))
})