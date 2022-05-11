test_that("Checking form results", {
  chk <- resdat
  chk$`Characteristic Name`[chk$`Characteristic Name` == 'DO'] <- 'Dissolved oxygen (DO)'
  chk$`Characteristic Name`[chk$`Characteristic Name` == 'Air Temp'] <- 'Temperature, air'
  frmchk <- form_results(chk)
  result <- unique(frmchk$`Characteristic Name`) %in% params$`Simple Parameter`
  result <- any(!result)
  expect_false(result)
})
