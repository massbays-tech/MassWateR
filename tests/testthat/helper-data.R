library(lubridate)
library(dplyr)

# results data
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), guess_max = Inf)) %>% 
  dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character)

# dqo accuracy data
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
accdat <- readxl::read_excel(accpth, na = c('NA', 'na', ''))

# dqo completeness data
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR')
frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
                          skip = 1, na = c('NA', 'na', ''), 
                          col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
)) %>% 
  rename(`% Completeness` = `...7`)

# site metadata
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')
sitdat <- readxl::read_excel(sitpth, na = c('NA', 'na', ''))

# wqx metadata
wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')
wqxdat <- readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text')
