test_that("Checking column name spelling", {
  chk <- wqxdat
  names(chk)[c(1, 3)] <- c('vars', 'methspec')
  expect_error(checkMWRwqx(chk))
})

test_that("Checking required column names are present", {
  chk <- wqxdat
  chk <- chk[, -2]
  expect_error(checkMWRwqx(chk))
})

test_that("Checking duplicate parameters", {
  chk <- wqxdat
  chk[1, 1] <- 'DO'
  expect_error(checkMWRwqx(chk))
})

test_that("Checking correct parameters", {
  chk <- wqxdat
  chk[2, 1] <- 'chla'
  chk[5, 1] <- 'nitrogne'
  expect_warning(checkMWRwqx(chk))
})