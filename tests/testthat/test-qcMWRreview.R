test_that("multiplication works", {
  expect_message(qcMWRreview(resdat, accdat, frecomdat, output_dir = getwd()))
})
