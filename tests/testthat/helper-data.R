library(lubridate)
library(readxl)
library(dplyr)

# results data
respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
resdat <- read_excel(respth, na = c('na', ''), 
                             col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text',
                                           'text', 'text', 'text', 'text'))

# dqo accuracy data
dqoaccpth <- system.file('extdata/ExampleDQOAccuracy_final.xlsx', package = 'MassWateR')
dqoaccdat <- read_excel(dqoaccpth, na = c('na', ''))

# dqo completeness data
dqocompth <- system.file('extdata/ExampleDQOCompleteness_final.xlsx', package = 'MassWateR')
dqocomdat <- suppressMessages(read_excel(dqocompth, 
                          skip = 1, na = c('na', ''), 
                          col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
)) %>% 
  rename(`% Completeness` = `...7`)

# site metadata
sitpth <- system.file('extdata/ExampleSites_final.xlsx', package = 'MassWateR')
sitdat <- read_excel(sitpth, na = c('na', ''))
