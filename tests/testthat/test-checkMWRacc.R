test_that("Checking column name spelling", {
  chk <- tst$accdatchk
  names(chk)[c(1, 4)] <- c('Variables', 'AQL')
  expect_error(checkMWRacc(chk), 'Please correct the column names or remove: Variables, AQL', fixed = T)
})

test_that("Checking required column names are present", {
  chk <- tst$accdatchk
  chk <- chk[, -10]
  expect_error(checkMWRacc(chk), 'Missing the following columns: Spike/Check Accuracy', fixed = T)
})

test_that("Checking column types, including NA", {
  chk <- tst$accdatchk
  chk$`UQL` <- NA
  chk$`MDL` <- 'a'
  chk$`Spike/Check Accuracy` <- 5
  chk$`Lab Duplicate` <- NA
  expect_error(checkMWRacc(chk), regexp = '\tChecking column types...\n\tIncorrect column type found in columns: MDL-should be numeric, Spike/Check Accuracy-should be character', fixed = T)
})

test_that("Checking column types with NA values", {
  chk <- tst$accdatchk
  chk$`UQL` <- NA
  chk$`Spike/Check Accuracy` <- NA
  result <- suppressWarnings(checkMWRacc(chk))
  expect_s3_class(result, 'tbl_df')
})

test_that("Checking for text other than <=, \u2264, <, >=, \u2265, >, \u00b1, %, AQL, BQL, log, or all", {
  chk <- tst$accdatchk
  chk$`Value Range`[4] <- 'b'
  chk$`Field Duplicate` <- 'alll'
  expect_error(checkMWRacc(chk), regexp = 'Unrecognized text in columns: Value Range, Field Duplicate', fixed = T)
})

test_that("Checking overlap in value range", {
  chk <- tst$accdatchk
  chk$`Value Range`[11] <- '<60'
  chk$`Value Range`[3] <- '<= 4'
  chk$`Value Range`[7] <- '<= 0.06'
  expect_error(checkMWRacc(chk), regexp = 'Overlap in value range: DO, E.coli, TP', fixed = T)
})

test_that("Checking gap in value range", {
  chk <- tst$accdatchk
  chk$`Value Range`[12] <- '>60'
  chk$`Value Range`[10] <- '>12'
  chk$`Value Range`[3] <- '< 1'
  expect_warning(checkMWRacc(chk), regexp = 'Gap in value range in DQO accuracy file: Ammonia, DO, E.coli', fixed = T)
})

test_that("Checking missing entries in uom", {
  chk <- tst$accdatchk
  chk[5, 2] <- NA
  chk[8, 2] <- NA
  chk[2, 2] <- NA # pH, will not trigger
  expect_error(checkMWRacc(chk), regexp = 'Missing unit (uom) in row(s) 5, 8', fixed = T)
})

test_that("Checking more than one unit type per parameter", {
  chk <- tst$accdatchk
  chk[4, 2] <- 'ug/l'
  expect_error(checkMWRacc(chk), 'More than one unit (uom) found for Parameter: DO: mg/l, ug/l', fixed = T)
})

test_that("Checking correct Parameters", {
  chk <- tst$accdatchk
  chk[7, 1] <- 'tss'
  chk[5, 1] <- 'sp-conductivity'
  expect_warning(expect_error(checkMWRacc(chk), 'Incorrect Parameter found: sp-conductivity, tss in row(s) 5, 7', fixed = T))
})

test_that("Checking incorrect unit type per parameter", {
  chk <- tst$accdatchk
  chk[chk$`Parameter` == 'Water Temp', 2] <- 'celsius'
  chk[chk$`Parameter` == 'TP', 2] <- 'mg/L'
  expect_error(checkMWRacc(chk), 'Incorrect units (uom) found for Parameters: Water Temp: celsius, TP: mg/L', fixed = T)
})

test_that("Checking empty column", {
  chk <- tst$accdatchk
  chk[[7]] <- NA
  expect_warning(checkMWRacc(chk),'Empty or all na columns found: Lab Duplicate')
})

test_that("Checking na in Value Range", {
  chk <- tst$accdatchk
  chk$`Value Range`[c(3, 7)] <- 'na'
  expect_error(checkMWRacc(chk), fixed = T, regexp = '\tChecking no "na" in Value Range...\n\tReplace "na" in Value Range with "all" for row(s): 3, 7')
})

