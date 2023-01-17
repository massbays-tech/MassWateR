library(readxl)
library(dplyr)

paramsMWR <- read_excel('inst/extdata/ParameterMapping.xlsx')

usethis::use_data(paramsMWR, overwrite = TRUE)
