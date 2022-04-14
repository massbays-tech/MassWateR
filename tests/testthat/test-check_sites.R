test_that("Checking column name spelling", {
  chk <- sitdat
  names(chk)[c(1, 3)] <- c('Site ID', 'latitude')
  expect_error(check_sites(chk))
})

test_that("Checking required column names are present", {
  chk <- sitdat
  chk <- chk[, -5]
  expect_error(check_sites(chk))
})

test_that("Checking missing latitude or longitude", {
  chk <- sitdat
  chk$`Monitoring Location Longitude`[5] <- NA
  chk$`Monitoring Location Latitude`[c(5, 6, 12)] <- NA
  expect_error(check_sites(chk))
})

test_that("Checking non-numeric latitude", {
  chk <- sitdat
  chk$`Monitoring Location Latitude`[5] <- 'a'
  chk$`Monitoring Location Latitude`[6] <- 'b'
  chk$`Monitoring Location Latitude`[12] <- 'a'
  expect_error(check_sites(chk))
})

test_that("Checking non-numeric longitude", {
  chk <- sitdat
  chk$`Monitoring Location Longitude`[4] <- 'a'
  chk$`Monitoring Location Longitude`[12] <- 'b'
  chk$`Monitoring Location Longitude`[22] <- 'a'
  expect_error(check_sites(chk))
})

test_that("Checking positive values in longitude", {
  chk <- sitdat
  chk$`Monitoring Location Longitude`[34] <- 72
  chk$`Monitoring Location Longitude`[25] <- 72
  chk$`Monitoring Location Longitude`[35] <- 73
  expect_error(check_sites(chk))
})

test_that("Checking missing locatoin id", {
  chk <- sitdat
  chk$`Monitoring Location ID`[34] <- NA
  chk$`Monitoring Location ID`[42] <- NA
  expect_error(check_sites(chk))
})