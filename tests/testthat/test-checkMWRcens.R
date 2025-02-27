test_that("Checking column name spelling", {
  chk <- tst$censdatchk
  names(chk)[c(1, 2)] <- c('Parm', 'Num')
  expect_error(checkMWRcens(chk), 'Please correct the column names or remove: Parm, Num', fixed = T)
})

test_that("Checking required column names are present", {
  chk <- tst$censdatchk
  chk <- chk[, -2]
  expect_error(checkMWRcens(chk), 'Missing the following columns: Missed and Censored Records', fixed = T)
})

test_that("Checking non-numeric Missed and Censored Records", {
  chk <- tst$censdatchk
  chk$`Missed and Censored Records`[1] <- 'a'
  chk$`Missed and Censored Records`[2] <- NA
  chk$`Missed and Censored Records`[3] <- '%'
  expect_error(checkMWRcens(chk), 'Non-numeric or empty entries in Missed and Censored Records found: a, NA, % in row(s) 1, 2, 3', fixed = T)
})

test_that("Checking negative values in Missed and Censored Records", {
  chk <- tst$censdatchk
  chk$`Missed and Censored Records`[1] <- -1
  expect_error(checkMWRcens(chk), 'Negative entries in Missed and Censored Records found: -1 in row(s) 1', fixed = T)
})

test_that("Checking correct Parameters", {
  chk <- tst$censdatchk
  chk[1, 1] <- 'chla'
  chk[3, 1] <- 'chla'
  chk[2, 1] <- 'nitrogne'
  expect_warning(checkMWRcens(chk), 'Parameter not included in approved parameters: chla, nitrogne', fixed = T)
})
