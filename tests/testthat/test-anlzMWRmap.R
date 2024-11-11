test_that("Checking output format", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, latlon = FALSE, addwater = "low")
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, one site", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, site = 'ABT-026', addwater = NULL, maptype = 'CartoDB.Positron', zoom = 5)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking warning output", {
  skip_on_cran()
  tst$sitdatchk <- tst$sitdat[!tst$sitdat$`Monitoring Location ID` == 'ABT-077', ]
  expect_warning(anlzMWRmap(res = tst$resdat, param = 'E.coli', acc = tst$accdat, sit = tst$sitdatchk, warn = TRUE, addwater = NULL))
})

test_that("Checking error output no sites to map", {
  expect_error(anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, site = 'HBS-057P'))
})

test_that("Checking output format, no scale bar or north arrow", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, northloc = NULL, scaleloc = NULL, addwater = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, no label repel", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, repel = FALSE, addwater = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking error for addwater input", { 
  expect_error(anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, addwater = 'xyz'))
})

test_that("Checking missing spatial data", {
  tst$sitdatchk <- tst$sitdat[!tst$sitdat$`Monitoring Location ID` == 'ABT-144', ]
  expect_error(anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdatchk, site = 'ABT-144'))
})

