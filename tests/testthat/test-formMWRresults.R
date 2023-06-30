test_that("Checking form results", {
  frmchk <- formMWRresults(resdat)
  result <- unique(frmchk$`Result Unit`) %in% 's.u.'
  result <- any(result)
  expect_false(result)
})

test_that("Checking form results for time as time input from Excel", {
  reschk <- resdat[1,]
  reschk$`Activity Start Time` <- structure(-2209042000, class = c("POSIXct", "POSIXt"), tzone = "UTC")
  frmchk <- formMWRresults(reschk)
  result <- frmchk$`Activity Start Time`
  expected <- "09:13"
  expect_equal(result, expected)
})

test_that("Checking form results for time as text input from Excel", {
  reschk <- resdat[1, ]
  reschk$`Activity Start Time` <- structure(-2209042000, class = c("POSIXct", "POSIXt"), tzone = "UTC")
  reschk$`Activity Start Time` <- gsub('^.*\\s', '', as.character(reschk$`Activity Start Time`))
  reschk$`Activity Start Time` <- paste(reschk$`Activity Start Time`, 'PM')
  frmchk <- formMWRresults(reschk)
  result <- frmchk$`Activity Start Time`
  expected <- "21:13"
  expect_equal(result, expected)
})