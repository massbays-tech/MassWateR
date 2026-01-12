# Format censored data

Format censored data

## Usage

``` r
formMWRcens(censdat)
```

## Arguments

- censdat:

  input data frame

## Value

A formatted data frame of the censored data

## Details

This function is used internally within
[`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
to format the input data for downstream analysis. The formatting
includes:

- Convert Parameter: All parameters are converted to `Simple Parameter`
  in
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  as needed,

- Convert Missed and Censored Records: All values are converted to
  numeric

## Examples

``` r
library(dplyr)

censpth <- system.file('extdata/ExampleCensored.xlsx', 
     package = 'MassWateR')

censdat <- suppressMessages(readxl::read_excel(censpth, 
      na = c('NA', 'na', '')
    )) 
    
formMWRcens(censdat)
#> # A tibble: 8 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <int>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
#> 7 Ammonia                                    0
#> 8 E.coli                                     0
```
