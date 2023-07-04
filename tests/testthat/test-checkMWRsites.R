test_that("Checking column name spelling", {
  chk <- sitdatchk
  names(chk)[c(1, 3)] <- c('Site ID', 'latitude')
  expect_error(checkMWRsites(chk))
})

test_that("Checking required column names are present", {
  chk <- sitdatchk
  chk <- chk[, -5]
  expect_error(checkMWRsites(chk))
})

test_that("Checking missing latitude or longitude", {
  chk <- sitdatchk
  chk$`Monitoring Location Longitude`[5] <- NA
  chk$`Monitoring Location Latitude`[c(5, 6, 11)] <- NA
  expect_error(checkMWRsites(chk))
})

test_that("Checking non-numeric latitude", {
  chk <- sitdatchk
  chk$`Monitoring Location Latitude`[5] <- 'a'
  chk$`Monitoring Location Latitude`[6] <- 'b'
  chk$`Monitoring Location Latitude`[11] <- 'a'
  expect_error(checkMWRsites(chk))
})

test_that("Checking non-numeric longitude", {
  chk <- sitdatchk
  chk$`Monitoring Location Longitude`[4] <- 'a'
  chk$`Monitoring Location Longitude`[6] <- 'b'
  chk$`Monitoring Location Longitude`[11] <- 'a'
  expect_error(checkMWRsites(chk))
})

test_that("Checking positive values in longitude", {
  chk <- sitdatchk
  chk$`Monitoring Location Longitude`[5] <- 72
  chk$`Monitoring Location Longitude`[6] <- 72
  chk$`Monitoring Location Longitude`[11] <- 73
  expect_error(checkMWRsites(chk))
})

test_that("Checking missing locatoin id", {
  chk <- sitdatchk
  chk$`Monitoring Location ID`[4] <- NA
  chk$`Monitoring Location ID`[7] <- NA
  expect_error(checkMWRsites(chk))
})
