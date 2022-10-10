test_that("Verifying message output for report creation", {
  expect_message(qcMWRreview(resdat, accdat, frecomdat, warn = FALSE))
  file.remove(file.path(getwd(), 'qcreview.docx'))
})

test_that("Verifying warning if missing DQO info", {
  resin <- resdat
  resin <- resin %>% 
    dplyr::filter(`Activity Type` != 'Quality Control Sample-Field Blank')
  accin <- accdat
  accin[[8]] <- NA_character_
  frecomin <- frecomdat
  frecomin[[4]] <- NA_real_
  expect_warning(
    expect_warning(
    expect_warning(
      expect_warning(
        expect_warning(
          expect_warning(
            qcMWRreview(resin, accin, frecomin, warn = TRUE, rawdata = FALSE)
            )
          )
        )
      )
    )
  )
  file.remove(file.path(getwd(), 'qcreview.docx'))
})
