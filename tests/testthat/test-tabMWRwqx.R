test_that("Verifying message output for wqx table creation", {
  outpth <- tempdir()
  expect_warning(expect_message(tabMWRwqx(respth, accpth, sitpth, wqxpth, warn = TRUE, output_dir = outpth)))
  file.remove(file.path(outpth, 'wqxtab.xlsx'))
})

test_that("Check warning if UQL or MDL missing from accdat", {
  outpth <- tempdir()
  accchk <- accdat %>% 
    mutate(
      MDL = case_when(
        Parameter == 'Ammonia' ~ NA_real_, 
        T ~ MDL
      )
    )
  expect_warning(expect_warning(expect_message(tabMWRwqx(respth, accchk, sitpth, wqxpth, warn = TRUE, output_dir = outpth))))
  file.remove(file.path(outpth, 'wqxtab.xlsx'))
})