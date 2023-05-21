test_that("Checking output format", {
  skip_on_cran()
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, latlon = FALSE, addwater = "low")
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, one site", {
  skip_on_cran()
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, site = 'ABT-026', addwater = NULL, maptype = 'terrain')
  expect_s3_class(result, 'ggplot')
})

test_that("Checking warning output", {
  skip_on_cran()
  sitdatchk <- sitdat[!sitdat$`Monitoring Location ID` == 'ABT-077', ]
  expect_warning(anlzMWRmap(res = resdat, param = 'E.coli', acc = accdat, sit = sitdatchk, warn = TRUE, addwater = NULL))
})

test_that("Checking error output no sites to map", {
  expect_error(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, site = 'HBS-057P'))
})

test_that("Checking output format, no scale bar or north arrow", {
  skip_on_cran()
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, northloc = NULL, scaleloc = NULL, addwater = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, no label repel", {
  skip_on_cran()
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, repel = FALSE, addwater = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking error for addwater input", { 
  expect_error(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE, addwater = 'xyz'))
})

test_that("Checking missing spatial data", {
  sitdatchk <- sitdat[!sitdat$`Monitoring Location ID` == 'ABT-144', ]
  expect_error(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdatchk, site = 'ABT-144'))
})

