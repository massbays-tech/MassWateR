test_that("Checking column name spelling", {
  chk <- frecomdat
  names(chk)[c(1, 3)] <- c('Variables', 'Lab Duplciate')
  expect_error(checkMWRfrecom(chk))
})

test_that("Checking required column names are present", {
  chk <- frecomdat
  chk <- chk[, -7]
  expect_error(checkMWRfrecom(chk))
})

test_that("Checking non-numeric values", {
  chk <- frecomdat
  chk$`Lab Duplicate` <- as.character(chk$`Lab Duplicate`)
  chk$`Lab Blank` <- as.character(chk$`Lab Blank`)
  expect_error(checkMWRfrecom(chk))
})

test_that("Checking values outside of 0 - 100", {
  chk <- frecomdat
  chk[2, 4] <- -10
  chk[2, 6] <- 101
  expect_error(checkMWRfrecom(chk))
})

test_that("Checking correct Parameters", {
  chk <- frecomdat
  chk[4, 1] <- 'chla'
  chk[7, 1] <- 'ortho-p'
  expect_error(checkMWRfrecom(chk))
})

test_that("Checking empty column", {
  chk <- frecomdat
  chk[[4]] <- NA
  expect_warning(checkMWRfrecom(chk))
})
