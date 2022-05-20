test_that("Checking form results", {
  frmchk <- formMWRresults(resdat)
  result <- unique(frmchk$`Result Unit`) %in% 's.u.'
  result <- any(result)
  expect_false(result)
})
