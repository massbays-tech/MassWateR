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

test_that("Checking column types, including NA", {
  chk <- accdatchk
  chk$`UQL` <- NA
  chk$`MDL` <- 'a'
  chk$`Spike/Check Accuracy` <- 5
  chk$`Lab Duplicate` <- NA
  expect_error(checkMWRacc(chk), regexp = '\tChecking column types...\n\tIncorrect column type found in columns: MDL-should be numeric, Spike/Check Accuracy-should be character', fixed = T)
})

test_that("Checking column types with NA values", {
  chk <- accdatchk
  chk$`UQL` <- NA
  chk$`Spike/Check Accuracy` <- NA
  result <- suppressWarnings(checkMWRacc(chk))
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking for text other than <=, \u2264, <, >=, \u2265, >, \u00b1, %, AQL, BQL, log, or all", {
  chk <- accdatchk
  chk$`Value Range`[4] <- 'b'
  chk$`Field Duplicate` <- 'alll'
  expect_error(checkMWRacc(chk), regexp = 'Unrecognized text in columns: Value Range, Field Duplicate', fixed = T)
})

test_that("Checking for more than two rows per parameter", {
  chk <- accdatchk
  chk <- bind_rows(accdatchk, accdatchk[8,], accdatchk[6,])
  expect_error(checkMWRacc(chk), regexp = 'More than two rows: Sp Conductance, TP', fixed = T)
})

test_that("Checking overlap in value range", {
  chk <- accdatchk
  chk$`Value Range`[11] <- '<60'
  chk$`Value Range`[3] <- '<= 4'
  chk$`Value Range`[7] <- '<= 0.06'
  expect_error(checkMWRacc(chk), regexp = 'Overlap in value range: DO, E.coli, TP', fixed = T)
})

test_that("Checking gap in value range", {
  chk <- accdatchk
  chk$`Value Range`[12] <- '>60'
  chk$`Value Range`[10] <- '>12'
  chk$`Value Range`[3] <- '< 1'
  expect_warning(checkMWRacc(chk), regexp = 'Gap in value range: Ammonia, DO, E.coli', fixed = T)
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
  chk[[7]] <- NA
  expect_warning(checkMWRacc(chk))
})

test_that("Checking na in Value Range", {
  chk <- accdatchk
  chk$`Value Range`[c(3, 7)] <- 'na'
  expect_error(checkMWRacc(chk), fixed = T, regexp = '\tChecking no "na" in Value Range...\n\tReplace "na" in Value Range with "all" for row(s): 3, 7')
})

