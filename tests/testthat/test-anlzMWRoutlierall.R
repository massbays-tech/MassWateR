test_that("anlzMWRoutlierall creates word output", {
  mock_render <- mock(NULL)
  
  stub(anlzMWRoutlierall, 'system.file', 'outlierall.Rmd')
  stub(anlzMWRoutlierall, 'rmarkdown::render', mock_render)
  stub(anlzMWRoutlierall, 'list.files', "output_dir/outlierall.docx")
  
  expect_message(
    anlzMWRoutlierall(res = tst$resdat, acc = tst$accdat, group = 'month', 
                     format = 'word', output_dir = 'output_dir'),
    "Word document created successfully"
  )
  
  expect_called(mock_render, 1)
})

test_that("anlzMWRoutlierall creates png output", {
  mock_png <- mock(NULL, cycle = TRUE)
  mock_dev_off <- mock(NULL, cycle = TRUE)
  
  stub(anlzMWRoutlierall, 'file.exists', TRUE)
  stub(anlzMWRoutlierall, 'png', mock_png)
  stub(anlzMWRoutlierall, 'dev.off', mock_dev_off)
  
  expect_message(
    anlzMWRoutlierall(res = tst$resdat, acc = tst$accdat, group = 'month',
                     format = 'png', output_dir = 'output_dir'),
    "PNG files created successfully"
  )
})

test_that("anlzMWRoutlierall creates directory if needed for png", {
  mock_dir_create <- mock(NULL)
  mock_png <- mock(NULL, cycle = TRUE)
  mock_dev_off <- mock(NULL, cycle = TRUE)
  
  stub(anlzMWRoutlierall, 'file.exists', FALSE)
  stub(anlzMWRoutlierall, 'dir.create', mock_dir_create)
  stub(anlzMWRoutlierall, 'png', mock_png)
  stub(anlzMWRoutlierall, 'dev.off', mock_dev_off)
  
  expect_message(
    anlzMWRoutlierall(res = tst$resdat, acc = tst$accdat, group = 'site',
                     format = 'png', output_dir = 'output_dir'),
    "PNG files created successfully"
  )
  
  expect_called(mock_dir_create, 1)
})

test_that("anlzMWRoutlierall creates zip output", {
  mock_png <- mock(NULL, cycle = TRUE)
  mock_dev_off <- mock(NULL, cycle = TRUE)
  mock_zip <- mock(NULL)
  mock_file_remove <- mock(NULL)
  
  stub(anlzMWRoutlierall, 'file.exists', TRUE)
  stub(anlzMWRoutlierall, 'png', mock_png)
  stub(anlzMWRoutlierall, 'dev.off', mock_dev_off)
  stub(anlzMWRoutlierall, 'list.files', c("output_dir/DO.png", "output_dir/pH.png"))
  stub(anlzMWRoutlierall, 'utils::zip', mock_zip)
  stub(anlzMWRoutlierall, 'file.remove', mock_file_remove)
  
  expect_message(
    anlzMWRoutlierall(res = tst$resdat, acc = tst$accdat, group = 'week',
                     format = 'zip', output_dir = 'output_dir'),
    "Zipped files located at"
  )
  
  expect_called(mock_zip, 1)
  expect_called(mock_file_remove, 1)
})

test_that("anlzMWRoutlierall handles custom output_file for word", {
  mock_render <- mock(NULL)
  
  stub(anlzMWRoutlierall, 'system.file', 'outlierall.Rmd')
  stub(anlzMWRoutlierall, 'rmarkdown::render', mock_render)
  stub(anlzMWRoutlierall, 'list.files', "output_dir/custom.docx")
  
  expect_message(
    anlzMWRoutlierall(res = tst$resdat, acc = tst$accdat, group = 'month',
                     format = 'word', output_dir = 'output_dir', 
                     output_file = 'custom.docx'),
    "File located at output_dir/custom.docx"
  )
  
  expect_called(mock_render, 1)
})

test_that("anlzMWRoutlierall handles custom output_file for zip", {
  mock_png <- mock(NULL, cycle = TRUE)
  mock_dev_off <- mock(NULL, cycle = TRUE)
  mock_zip <- mock(NULL)
  mock_file_remove <- mock(NULL)
  
  stub(anlzMWRoutlierall, 'file.exists', TRUE)
  stub(anlzMWRoutlierall, 'png', mock_png)
  stub(anlzMWRoutlierall, 'dev.off', mock_dev_off)
  stub(anlzMWRoutlierall, 'list.files', c("output_dir/DO.png"))
  stub(anlzMWRoutlierall, 'utils::zip', mock_zip)
  stub(anlzMWRoutlierall, 'file.remove', mock_file_remove)
  
  expect_message(
    anlzMWRoutlierall(res = tst$resdat, acc = tst$accdat, group = 'month',
                     format = 'zip', output_dir = 'output_dir', 
                     output_file = 'custom.zip'),
    "Zipped files located at"
  )
  
  expect_called(mock_zip, 1)
})
