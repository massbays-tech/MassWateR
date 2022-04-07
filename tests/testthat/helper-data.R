library(lubridate)

respth <- system.file('extdata/ExampleResults_final.xlsx', package = 'MassWateR')
resdat <- readxl::read_excel(respth,
                             col_types = c('text', 'text', 'date', 'date', 'text', 'text', 'text', 'text', 'text', 'text',
                                           'text', 'text', 'text', 'text'))
