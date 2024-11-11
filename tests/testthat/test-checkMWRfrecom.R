test_that("Checking column name spelling", {
  chk <- tst$frecomdatchk
  names(chk)[c(1, 3)] <- c('Variables', 'Lab Duplciate')
  expect_error(checkMWRfrecom(chk), 'Please correct the column names or remove: Variables, Lab Duplciate', fixed = T)
})

test_that("Checking required column names are present", {
  chk <- tst$frecomdatchk
  chk <- chk[, -7]
  expect_error(checkMWRfrecom(chk), 'Missing the following columns: % Completeness', fixed = T)
})

test_that("Checking non-numeric values", {
  chk <- tst$frecomdatchk
  chk$`Lab Duplicate` <- as.character(chk$`Lab Duplicate`)
  chk$`Lab Blank` <- as.character(chk$`Lab Blank`)
  expect_error(checkMWRfrecom(chk), 'Non-numeric values found in columns: Lab Duplicate, Lab Blank', fixed = T)
})

test_that("Checking values outside of 0 - 100", {
  chk <- tst$frecomdatchk
  chk[2, 4] <- -10
  chk[2, 6] <- 101
  expect_error(checkMWRfrecom(chk), 'Values less than 0 or greater than 100 found in columns: Field Blank, Spike/Check Accuracy', fixed = T)
})

test_that("Checking correct Parameters", {
  chk <- tst$frecomdatchk
  chk[4, 1] <- 'chla'
  chk[7, 1] <- 'ortho-p'
  expect_error(checkMWRfrecom(chk), 'Incorrect Parameter found: chla, ortho-p in row(s) 4, 7', fixed = T)
})

test_that("Checking empty column", {
  chk <- tst$frecomdatchk
  chk[[4]] <- NA
  expect_warning(checkMWRfrecom(chk), 'Empty or all na columns found: Field Blank')
})
