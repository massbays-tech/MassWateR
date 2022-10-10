test_that("Checking column name spelling", {
  chk <- accdat
  names(chk)[c(1, 4)] <- c('Variables', 'AQL')
  expect_error(checkMWRacc(chk))
})

test_that("Checking required column names are present", {
  chk <- accdat
  chk <- chk[, -10]
  expect_error(checkMWRacc(chk))
})

test_that("Checking column types", {
  chk <- accdat
  chk$`MDL` <- as.character(chk$`MDL`)
  chk$`UQL`[5] <- 'a'
  chk$`Spike/Check Accuracy` <- suppressWarnings(as.numeric(chk$`Spike/Check Accuracy`))
  expect_error(checkMWRacc(chk))
})

test_that("Checking for text other than <=, \u2264, <, >=, \u2265, >, \u00b1, %, AQL, BQL, log, or all", {
  chk <- accdat
  chk$`Value Range`[4] <- '+'
  chk$`Field Duplicate` <- 'alll'
  expect_error(checkMWRacc(chk))
})

test_that("Checking missing entries in uom", {
  chk <- accdat
  chk[5, 2] <- NA
  chk[21, 2] <- NA
  chk[2, 2] <- NA # pH, will not trigger
  expect_error(checkMWRacc(chk))
})

test_that("Checking more than one unit type per parameter", {
  chk <- accdat
  chk[4, 2] <- 'ug/l'
  expect_error(checkMWRacc(chk))
})

test_that("Checking correct Parameters", {
  chk <- accdat
  chk[7, 1] <- 'tss'
  chk[5, 1] <- 'sp-conductivity'
  expect_error(checkMWRacc(chk))
})

test_that("Checking incorrect unit type per parameter", {
  chk <- accdat
  chk[chk$`Parameter` == 'Chl a', 2] <- 'micrograms/L'
  chk[chk$`Parameter` == 'TP', 2] <- 'mg/L'
  expect_error(checkMWRacc(chk))
})

test_that("Checking empty column", {
  chk <- accdat
  chk[[4]] <- NA
  expect_warning(checkMWRacc(chk))
})