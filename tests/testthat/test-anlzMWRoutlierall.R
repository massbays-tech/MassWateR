# test_that("Verifying message output for Word report creation", {
#   expect_message(anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'word', warn = FALSE))
#   file.remove(file.path(getwd(), 'outlierall.docx'))
# })
# 
# test_that("Verifying message output for png creation", {
#   outpth <- file.path(getwd(), 'figs')
#   expect_message(anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'png', output_dir = outpth, warn = FALSE))
#   system(paste('rm -rf', outpth))
# })
