library(lubridate)
library(dplyr)

# results data
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
resdatchk <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), guess_max = Inf)) %>% 
  dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character)
resdat <- readMWRresults(respth, runchk = F, warn = F)

# dqo accuracy data
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
accdatchk <- readxl::read_excel(accpth, na = c('NA', ''), col_types = 'text')
accdatchk <- mutate(accdatchk, across(-c(`Value Range`), ~ na_if(.x, 'na')))
accdat <- readMWRacc(accpth, runchk = F, warn = F)

# dqo completeness data
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR')
frecomdatchk <- suppressMessages(readxl::read_excel(frecompth, 
                          skip = 1, na = c('NA', 'na', ''), 
                          col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
)) %>% 
  rename(`% Completeness` = `...7`)
frecomdat <- readMWRfrecom(frecompth, runchk = F, warn = F)

# site metadata
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')
sitdatchk <- readxl::read_excel(sitpth, na = c('NA', 'na', ''))
sitdat <- readMWRsites(sitpth, runchk = F) 

# wqx metadata
wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')
wqxdatchk <- readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text')
wqxdat <- readMWRwqx(wqxpth, runchk = F, warn = F)
