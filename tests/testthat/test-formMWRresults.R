test_that("Checking form results", {
  frmchk <- formMWRresults(resdatchk)
  result <- unique(frmchk$`Result Unit`) %in% 's.u.'
  result <- any(result)
  expect_false(result)
})

test_that("Checking form results for time as time input from Excel", {
  reschk <- resdatchk[1,]
  frmchk <- formMWRresults(reschk)
  result <- frmchk$`Activity Start Time`
  expected <- "08:15"
  expect_equal(result, expected)
  
  reschk <- resdatchk[1,]
  reschk$`Activity Start Time` <- structure(-2209042000, class = c("POSIXct", "POSIXt"), tzone = "UTC")
  frmchk <- formMWRresults(reschk)
  result <- frmchk$`Activity Start Time`
  expected <- "09:13"
  expect_equal(result, expected)
})

test_that("Checking form results for time as text input from Excel", {
  reschk <- resdatchk[1, ]
  reschk$`Activity Start Time` <- structure(-2209042000, class = c("POSIXct", "POSIXt"), tzone = "UTC")
  reschk$`Activity Start Time` <- gsub('^.*\\s', '', as.character(reschk$`Activity Start Time`))
  reschk$`Activity Start Time` <- paste(reschk$`Activity Start Time`, 'PM')
  frmchk <- formMWRresults(reschk)
  result <- frmchk$`Activity Start Time`
  expected <- "21:13"
  expect_equal(result, expected)
})

test_that("Checking form results for time as time input from Excel", {
  reschk <- resdatchk[1:10,]
  reschk$`Activity Start Time` <- c(0.1, 0.5, '08:23:00', '16:22:00', '21:00:00PM', '09:15:00PM', '9:21', '07:56AM', '07:56 PM', '07:56PM')
  frmchk <- formMWRresults(reschk)
  result <- frmchk$`Activity Start Time`
  expected <- c("02:24", "12:00", "08:23", "16:22", "21:00", "21:15", "09:21", "07:56", "19:56", "19:56")
  expect_equal(result, expected)
})