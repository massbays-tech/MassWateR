# test_that("Verifying message output for Word report creation", {
#   outpth <- tempdir()
#   expect_message(anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'word', output_dir = outpth, warn = FALSE))
#   file.remove(file.path(outpth, 'outlierall.docx'))
# })
# 
# test_that("Verifying message output for png creation", {
#   outpth <- tempdir()
#   expect_message(anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'png', output_dir = outpth, warn = FALSE))
#   system(paste('rm -rf', outpth))
# })
