# frequency table percent
tabfreper <- tabMWRfre(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'percent',
  warn = FALSE)

# frequency summary table
tabfresum <- tabMWRfre(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'summary',
  warn = FALSE)

# accuracy table percent
tabaccper <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'percent',
  warn = FALSE)

# accuracy table summary
tabaccsum <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'summary',
  warn = FALSE)

# completeness table
tabcom <- tabMWRcom(res = tst$resdat, frecom = tst$frecomdat, cens = tst$censdat, warn = F,
  parameterwd = 1.15, noteswd = 2)

# individual accuracy checks for raw data
indflddup <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'individual',
  accchk = 'Field Duplicates', warn = FALSE, caption = FALSE)
indlabdup <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'individual',
  accchk = 'Lab Duplicates', warn = FALSE, caption = FALSE)
indfldblk <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'individual',
  accchk = 'Field Blanks', warn = FALSE, caption = FALSE)
indlabblk <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'individual',
  accchk = 'Lab Blanks', warn = FALSE, caption = FALSE)
indlabins <- tabMWRacc(res = tst$resdat, acc = tst$accdat, frecom = tst$frecomdat, type = 'individual',
  accchk = 'Lab Spikes / Instrument Checks', warn = FALSE, caption = FALSE)

# input
datin <- list(
  frecomdat = tst$frecomdat,
  accdat = tst$accdat,
  tabfreper = tabfreper,
  tabfresum = tabfresum,
  tabaccper = tabaccper,
  tabaccsum = tabaccsum,
  tabcom = tabcom,
  indflddup = indflddup,
  indlabdup = indlabdup,
  indfldblk = indfldblk,
  indlabblk = indlabblk,
  indlabins = indlabins
)

test_that("Checking output format type as list", {
  result <- utilMWRsheet(datin, rawdata = TRUE)
  expect_type(result, 'list')
  expect_length(result, 12)
})

test_that("Checking output format type as list", {
  result <- utilMWRsheet(datin, rawdata = FALSE)
  expect_type(result, 'list')
  expect_length(result, 7)
})
