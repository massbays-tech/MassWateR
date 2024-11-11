# test_that("Verifying message output for report creation", {
#   outpth <- tempdir()
#   expect_message(qcMWRreview(tst$resdat, tst$accdat, tst$frecomdat, warn = FALSE, output_dir = outpth))
#   file.remove(file.path(outpth, 'qcreview.docx'))
# })
# 
# test_that("Verifying warning if missing DQO info", {
#   outpth <- tempdir()
#   resin <- tst$resdat
#   resin <- resin %>% 
#     dplyr::filter(`Activity Type` != 'Quality Control Sample-Field Blank')
#   accin <- tst$accdat
#   accin[[8]] <- NA_character_
#   frecomin <- tst$frecomdat
#   frecomin[[4]] <- NA_real_
#   expect_warning(
#     expect_warning(
#     expect_warning(
#       expect_warning(
#         expect_warning(
#           expect_warning(
#             qcMWRreview(resin, accin, frecomin, warn = TRUE, rawdata = FALSE, output_dir = outpth)
#             )
#           )
#         )
#       )
#     )
#   )
#   file.remove(file.path(outpth, 'qcreview.docx'))
# })
