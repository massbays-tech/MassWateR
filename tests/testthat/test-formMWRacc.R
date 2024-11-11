test_that("Checking form results", {
  chk <- tst$accdatchk
  chk$`Parameter`[chk$`Parameter` == 'DO'] <- 'Dissolved oxygen (DO)'
  chk$`Parameter`[chk$`Parameter` == 'Water Temp'] <- 'Temperature, water'
  frmchk <- formMWRacc(chk)
  result <- unique(frmchk$`Parameter`) %in% paramsMWR$`Simple Parameter`
  result <- any(!result)
  expect_false(result)
})
