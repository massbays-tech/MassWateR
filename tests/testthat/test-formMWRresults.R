test_that("Checking form results", {
  chk <- resdat
  chk$`Characteristic Name`[chk$`Characteristic Name` == 'DO'] <- 'Dissolved oxygen (DO)'
  chk$`Characteristic Name`[chk$`Characteristic Name` == 'Air Temp'] <- 'Temperature, air'
  frmchk <- formMWRresults(chk)
  result <- unique(frmchk$`Characteristic Name`) %in% paramsMWR$`Simple Parameter`
  result <- any(!result)
  expect_false(result)
})
