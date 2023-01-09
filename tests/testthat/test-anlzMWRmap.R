test_that("Checking output format", {
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, latlon = FALSE, addwater = "low")
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, one site", {
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, site = 'ABT-026', addwater = "low", maptype = 'terrain')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking warning output", {
  expect_warning(anlzMWRmap(res = resdat, param = 'E.coli', acc = accdat, sit = sitdat, warn = TRUE))
})

test_that("Checking error output no sites to map", {
  expect_error(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, site = 'HBS-057P'))
})

test_that("Checking output format, no scale bar or north arrow", {
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, northloc = NULL, scaleloc = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, no label repel", {
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, repel = FALSE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking error for addwater input", { 
  expect_error(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, addwater = 'xyz'))
})

test_that("Checking missing spatial data", {
  sitdatchk <- sitdat[-4, ]
  expect_error(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdatchk, site = 'ABT-144'))
})

