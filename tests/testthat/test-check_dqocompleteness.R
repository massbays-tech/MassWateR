test_that("Checking column name spelling", {
  chk <- dqocomdat
  names(chk)[c(1, 3)] <- c('Variables', 'Lab Duplciate')
  expect_error(check_dqocompleteness(chk))
})

test_that("Checking required column names are present", {
  chk <- dqocomdat
  chk <- chk[, -7]
  expect_error(check_dqocompleteness(chk))
})

test_that("Checking non-numeric values", {
  chk <- dqocomdat
  chk$`Lab Duplicate` <- as.character(chk$`Lab Duplicate`)
  chk$`Lab Blank` <- as.character(chk$`Lab Blank`)
  expect_error(check_dqocompleteness(chk))
})

test_that("Checking values outside of 0 - 100", {
  chk <- dqocomdat
  chk[2, 4] <- -10
  chk[2, 6] <- 101
  expect_error(check_dqocompleteness(chk))
})