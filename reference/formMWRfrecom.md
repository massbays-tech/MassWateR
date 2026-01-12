# Format data quality objective frequency and completeness data

Format data quality objective frequency and completeness data

## Usage

``` r
formMWRfrecom(frecomdat)
```

## Arguments

- frecomdat:

  input data frame

## Value

A formatted data frame of the data quality objectives file for frequency
and completeness

## Details

This function is used internally within
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)
to format the input data for downstream analysis. The formatting
includes:

- Convert Parameter: All parameters are converted to `Simple Parameter`
  in
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  as needed

## Examples

``` r
library(dplyr)

frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
     package = 'MassWateR')

frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
      skip = 1, na = c('NA', 'na', ''), 
      col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
    )) %>% 
    rename(`% Completeness` = `...7`)
    
formMWRfrecom(frecomdat)
#> # A tibble: 8 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Water Temp                    10              10            NA          NA
#> 2 pH                            10              10            NA          NA
#> 3 DO                            10              NA            NA          NA
#> 4 Sp Conductance                10              10            NA          10
#> 5 TP                            10               5            10           5
#> 6 Nitrate                       10               5            10           5
#> 7 Ammonia                       10               5            10           5
#> 8 E.coli                        10               5            10           5
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
```
