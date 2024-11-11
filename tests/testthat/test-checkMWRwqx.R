test_that("Checking column name spelling", {
  chk <- tst$wqxdatchk
  names(chk)[c(1, 3)] <- c('vars', 'methspec')
  expect_error(checkMWRwqx(chk))
})

test_that("Checking required column names are present", {
  chk <- tst$wqxdatchk
  chk <- chk[, -2]
  expect_error(checkMWRwqx(chk))
})

test_that("Checking duplicate parameters", {
  chk <- tst$wqxdatchk
  chk[1, 1] <- 'DO'
  expect_error(checkMWRwqx(chk))
})

test_that("Checking correct parameters", {
  chk <- tst$wqxdatchk
  chk[2, 1] <- 'chla'
  chk[5, 1] <- 'nitrogne'
  expect_warning(checkMWRwqx(chk))
})
