test_that("geomean auto", {
  result <- utilMWRsumfun(tst$accdat, param = 'E.coli')
  expect_equal(result, 'geomean')
})

test_that("mean force", {
  result <- utilMWRsumfun(tst$accdat, param = 'E.coli', sumfun = 'mean')
  expect_equal(result, 'mean')
})

test_that("mean auto", {
  result <- utilMWRsumfun(tst$accdat, param = 'DO')
  expect_equal(result, 'mean')
})

test_that("geomean force", {
  result <- utilMWRsumfun(tst$accdat, param = 'DO', sumfun = 'geomean')
  expect_equal(result, 'geomean')
})
