library(readxl)
library(dplyr)

thresholdMWR <- read_excel('inst/extdata/ThresholdMapping.xlsx', na = 'NA') %>%
  rename(
    `Simple Parameter` = Simple_Parameter,
    uom = UOM
  ) %>%
  mutate_if(is.numeric, round, 2)

usethis::use_data(thresholdMWR, overwrite = TRUE)
