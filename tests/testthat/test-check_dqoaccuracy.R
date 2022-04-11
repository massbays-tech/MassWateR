test_that("Checking column name spelling", {
  chk <- dqoaccdat
  names(chk)[c(1, 4)] <- c('Variables', 'AQL')
  expect_error(check_dqoaccuracy(chk))
})

test_that("Checking non-numeric values in MDL, UQL", {
  chk <- dqoaccdat
  chk$`MDL` <- as.character(chk$`MDL`)
  chk$`UQL`[5] <- 'a'
  expect_error(check_dqoaccuracy(chk))
})

test_that("Checking for text other than <=, <, >=, >, ±, %, AQL, BQL, log, or all", {
  chk <- dqoaccdat
  chk$`Value Range`[4] <- '+'
  chk$`Field Duplicate` <- 'alll'
  expect_error(check_dqoaccuracy(chk))
})
