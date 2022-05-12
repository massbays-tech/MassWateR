library(lubridate)
library(readxl)
library(dplyr)

# results data
respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
resdat <- read_excel(respth, na = c('NA', 'na', ''), 
                             col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text',
                                           'text', 'text', 'text', 'text'))

# dqo accuracy data
accpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
accdat <- read_excel(accpth, na = c('NA', 'na', ''))

# dqo completeness data
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness_final.xlsx', package = 'MassWateR')
frecomdat <- suppressMessages(read_excel(frecompth, 
                          skip = 1, na = c('NA', 'na', ''), 
                          col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
)) %>% 
  rename(`% Completeness` = `...7`)

# site metadata
sitpth <- system.file('extdata/ExampleSites_final.xlsx', package = 'MassWateR')
sitdat <- read_excel(sitpth, na = c('NA', 'na', ''))
