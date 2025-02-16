test_that("Checking column name spelling", {
  chk <- tst$censdatchk
  names(chk)[c(1, 2)] <- c('Parm', 'Num')
  expect_error(checkMWRcens(chk))
})

test_that("Checking required column names are present", {
  chk <- tst$censdatchk
  chk <- chk[, -2]
  expect_error(checkMWRcens(chk))
})

test_that("Checking non-numeric Missed and Censored Records", {
  chk <- tst$censdatchk
  chk$`Missed and Censored Records`[1] <- 'a'
  chk$`Missed and Censored Records`[3] <- 'baa'
  expect_error(checkMWRcens(chk))
})

test_that("Checking negative values in Missed and Censored Records", {
  chk <- tst$censdatchk
  chk$`Missed and Censored Records`[1] <- -1
  expect_error(checkMWRcens(chk))
})

test_that("Checking correct Parameters", {
  chk <- tst$censdatchk
  chk[1, 1] <- 'chla'
  chk[3, 1] <- 'chla'
  chk[2, 1] <- 'nitrogne'
  expect_warning(checkMWRcens(chk))
})
