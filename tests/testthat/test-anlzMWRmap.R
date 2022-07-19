test_that("Checking output format", {
  result <- anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = FALSE)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking warning output", {
  expect_warning(anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, warn = TRUE))
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
