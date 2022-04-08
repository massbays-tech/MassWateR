test_that("Checking column name spelling", {
  chk <- dqocomdat
  names(chk)[c(1, 3)] <- c('Variables', 'Lab Duplciate')
  expect_error(check_dqocompleteness(chk))
})

test_that("Checking non-numeric values", {
  chk <- dqocomdat
  chk$`Lab Duplicate` <- as.character(chk$`Lab Duplicate`)
  chk$`Lab Blank` <- as.character(chk$`Lab Blank`)
  expect_error(check_dqocompleteness(chk))
})