test_that("Checking form results", {
  chk <- accdat
  chk$`Parameter`[chk$`Parameter` == 'DO'] <- 'Dissolved oxygen (DO)'
  chk$`Parameter`[chk$`Parameter` == 'Water Temp'] <- 'Temperature, water'
  frmchk <- form_acc(chk)
  result <- unique(frmchk$`Parameter`) %in% params$`Simple Parameter`
  result <- any(!result)
  expect_false(result)
})
