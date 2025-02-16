library(lubridate)
library(dplyr)

tst <- list(
  
  # results data
  respth = system.file('extdata/ExampleResults.xlsx', package = 'MassWateR'),
  resdatchk = suppressWarnings(readxl::read_excel(system.file('extdata/ExampleResults.xlsx', package = 'MassWateR'), na = c('NA', 'na', ''), guess_max = Inf)) %>% 
    dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character),
  resdat = readMWRresults(system.file('extdata/ExampleResults.xlsx', package = 'MassWateR'), runchk = F, warn = F),
  
  # dqo accuracy data
  accpth = system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR'),
  accdatchk = readxl::read_excel(system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR'), na = c('NA', ''), col_types = 'text') %>% 
    mutate(across(-c(`Value Range`), ~ na_if(.x, 'na'))),
  accdat = readMWRacc(system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR'), runchk = F, warn = F),
  
  # dqo completeness data
  frecompth = system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR'),
  frecomdatchk = suppressMessages(readxl::read_excel(system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR'), 
                            skip = 1, na = c('NA', 'na', ''), 
                            col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
  )) %>% 
    rename(`% Completeness` = `...7`),
  frecomdat = readMWRfrecom(system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR'), runchk = F, warn = F),
  
  # site metadata
  sitpth = system.file('extdata/ExampleSites.xlsx', package = 'MassWateR'),
  sitdatchk = readxl::read_excel(system.file('extdata/ExampleSites.xlsx', package = 'MassWateR'), na = c('NA', 'na', '')),
  sitdat = readMWRsites(system.file('extdata/ExampleSites.xlsx', package = 'MassWateR'), runchk = F),
  
  # wqx metadata
  wqxpth = system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR'),
  wqxdatchk = readxl::read_excel(system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR'), na = c('NA', 'na', ''), col_types = 'text'),
  wqxdat = readMWRwqx(system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR'), runchk = F, warn = F),
  
  # censored data
  censpth = system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR'),
  censdatchk = suppressWarnings(readxl::read_excel(system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR'), na = c('NA', 'na', ''), guess_max = Inf)),
  censdat = readMWRcens(system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR'), runchk = F, warn = F)
  
)
