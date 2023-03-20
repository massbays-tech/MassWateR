test_that("Checking 404 message", {
  expect_message(utilMWRhttpgrace('http://httpbin.org/status/404'))
})

test_that("Checking sf output",{
  fl <- 'https://github.com/massbays-tech/MassWateRdata/raw/main/data/streamsMWR.RData'
  resp <- utilMWRhttpgrace(fl)
  expect_s3_class(resp, 'sf')
})
