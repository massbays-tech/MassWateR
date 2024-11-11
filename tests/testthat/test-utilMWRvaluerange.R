test_that("Error if na in value range", {
  chk <- readxl::read_excel(tst$accpth, na = c('NA', ''), col_types = 'text')
  chk$`Value Range`[1] <- 'na'
  expect_error(utilMWRvaluerange(chk), 'na present in Value Range')
})

test_that("Check all TRUE for complete value range", {
  result <- utilMWRvaluerange(tst$accdatchk)
  result <- sum(result == 'nogap') == length(names(result))
  expect_true(result)
})

test_that("Check incomplete value range returns correct result", {
  chk <- tst$accdatchk
  chk$`Value Range`[4] <- '> 4'
  chk$`Value Range`[8] <- '>= 0.09'
  result <- utilMWRvaluerange(chk)
  result <- names(result)[result %in% 'gap']
  expect_equal(result, c('DO', 'TP'))
})

test_that("Check overlap in value range", {
  chk <- tst$accdatchk
  chk$`Value Range`[4] <- '> 3'
  result <- utilMWRvaluerange(chk)
  result <- names(result)[result %in% 'overlap']
  expect_equal(result, 'DO')
})
