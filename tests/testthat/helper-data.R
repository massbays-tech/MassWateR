library(lubridate)
library(dplyr)

# results data
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
resdat <- readxl::read_excel(respth, na = c('NA', 'na', ''), 
                             col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text',
                                           'text', 'text', 'text', 'text', 'text', 'text', 'text'))

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
