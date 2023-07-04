test_that("Checking column name spelling", {
  chk <- accdatchk
  names(chk)[c(1, 4)] <- c('Variables', 'AQL')
  expect_error(checkMWRacc(chk))
})

test_that("Checking required column names are present", {
  chk <- accdatchk
  chk <- chk[, -10]
  expect_error(checkMWRacc(chk))
})

test_that("Checking column types", {
  chk <- accdatchk
  chk$`MDL` <- as.character(chk$`MDL`)
  chk$`UQL`[5] <- 'a'
  chk$`Spike/Check Accuracy` <- suppressWarnings(as.numeric(chk$`Spike/Check Accuracy`))
  expect_error(checkMWRacc(chk), regexp = '\tChecking column types...\n\tIncorrect column type found in columns: UQL-character, Spike/Check Accuracy-numeric', fixed = T)
})

test_that("Checking for text other than <=, \u2264, <, >=, \u2265, >, \u00b1, %, AQL, BQL, log, or all", {
  chk <- accdatchk
  chk$`Value Range`[4] <- '+'
  chk$`Field Duplicate` <- 'alll'
  expect_error(checkMWRacc(chk), regexp = 'Unrecognized text in columns: Value Range, Field Duplicate', fixed = T)
})

test_that("Checking missing entries in uom", {
  chk <- accdatchk
  chk[5, 2] <- NA
  chk[8, 2] <- NA
  chk[2, 2] <- NA # pH, will not trigger
  expect_error(checkMWRacc(chk), regexp = 'Missing unit (uom) in rows 5, 8', fixed = T)
})

test_that("Checking more than one unit type per parameter", {
  chk <- accdatchk
  chk[4, 2] <- 'ug/l'
  expect_error(checkMWRacc(chk))
})

test_that("Checking correct Parameters", {
  chk <- accdatchk
  chk[7, 1] <- 'tss'
  chk[5, 1] <- 'sp-conductivity'
  expect_error(checkMWRacc(chk))
})

test_that("Checking incorrect unit type per parameter", {
  chk <- accdatchk
  chk[chk$`Parameter` == 'Chl a', 2] <- 'micrograms/L'
  chk[chk$`Parameter` == 'TP', 2] <- 'mg/L'
  expect_error(checkMWRacc(chk))
})

test_that("Checking empty column", {
  chk <- accdatchk
  chk[[4]] <- NA
  expect_warning(checkMWRacc(chk))
})

test_that("Checking na in Value Range", {
  chk <- accdatchk
  chk$`Value Range`[c(3, 7)] <- 'na'
  expect_error(checkMWRacc(chk), fixed = T, regexp = '\tChecking no "na" in Value Range...\n\tReplace "na" in Value Range with "all" for row(s): 3, 7')
})

