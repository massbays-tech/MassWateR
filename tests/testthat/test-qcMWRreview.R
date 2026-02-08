test_that("qcMWRreview creates word output", {
  mock_render <- mock(NULL)
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', mock_render)
  stub(qcMWRreview, 'list.files', "output_dir/qcreview.docx")
  
  expect_message(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, 
                cens = tst$censdat, output_dir = 'output_dir', warn = FALSE),
    "Report created successfully"
  )
  
  expect_called(mock_render, 1)
})

test_that("qcMWRreview creates spreadsheet when savesheet = TRUE", {
  mock_render <- mock(NULL)
  mock_write <- mock(NULL)
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', mock_render)
  stub(qcMWRreview, 'list.files', c("output_dir/qcreview.docx", "output_dir/qcreview.xlsx"))
  stub(qcMWRreview, 'writexl::write_xlsx', mock_write)
  
  expect_message(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, 
                output_dir = 'output_dir', savesheet = TRUE, warn = FALSE),
    "Spreadsheet created successfully"
  )
  
  expect_called(mock_write, 1)
})

test_that("qcMWRreview works without rawdata tables", {
  mock_render <- mock(NULL)
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', mock_render)
  stub(qcMWRreview, 'list.files', "output_dir/qcreview.docx")
  
  expect_message(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, 
                output_dir = 'output_dir', rawdata = FALSE, warn = FALSE),
    "Report created successfully"
  )
})

test_that("qcMWRreview warns about empty frecomdat columns", {
  # Create frecomdat with empty column
  mockfrecom <- tst$frecomdat
  mockfrecom$`Field Blacnk` <- NA_real_
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', NULL)
  stub(qcMWRreview, 'list.files', "output_dir/qcreview.docx")
  
  expect_warning(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = mockfrecom, 
                output_dir = 'output_dir', rawdata = FALSE, warn = TRUE),
    "No data quality obectives in frequency and completeness file"
  )
})

test_that("qcMWRreview warns about empty accdat columns", {
  # Create accdat with empty column
  mockacc <- tst$accdat 
  mockacc$`Field Duplicate` <- NA_character_

  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', NULL)
  stub(qcMWRreview, 'list.files', "output_dir/qcreview.docx")
  
  expect_warning(
    qcMWRreview(res = tst$resdat, acc = mockacc, frecom = tst$frecomdat, 
                output_dir = 'output_dir', rawdata = FALSE, warn = TRUE),
    "No data quality obectives in accuracy file"
  )
})

test_that("qcMWRreview handles custom output_file", {
  mock_render <- mock(NULL)
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', mock_render)
  stub(qcMWRreview, 'list.files', "output_dir/custom.docx")
  
  expect_message(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, 
                output_dir = 'output_dir', output_file = 'custom.docx', 
                rawdata = FALSE, warn = FALSE),
    "File located at output_dir/custom.docx"
  )
  
  expect_called(mock_render, 1)
})

test_that("qcMWRreview works with rawdata = TRUE", {
  mock_render <- mock(NULL)
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', mock_render)
  stub(qcMWRreview, 'list.files', "output_dir/qcreview.docx")
  
  expect_message(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, 
                output_dir = 'output_dir', rawdata = TRUE, warn = FALSE),
    "Report created successfully"
  )
})

test_that("qcMWRreview works without censored data", {
  mock_render <- mock(NULL)
  
  stub(qcMWRreview, 'system.file', 'qcreview.Rmd')
  stub(qcMWRreview, 'rmarkdown::render', mock_render)
  stub(qcMWRreview, 'list.files', "output_dir/qcreview.docx")
  
  expect_message(
    qcMWRreview(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, 
                cens = NULL, output_dir = 'output_dir', warn = FALSE),
    "Report created successfully"
  )
})