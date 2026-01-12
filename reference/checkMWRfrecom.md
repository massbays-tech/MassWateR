# Check data quality objective frequency and completeness data

Check data quality objective frequency and completeness data

## Usage

``` r
checkMWRfrecom(frecomdat, warn = TRUE)
```

## Arguments

- frecomdat:

  input data frame

- warn:

  logical to return warnings to the console (default)

## Value

`frecomdat` is returned as is if no errors are found, otherwise an
informative error message is returned prompting the user to make the
required correction to the raw data before proceeding.

## Details

This function is used internally within
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)
to run several checks on the input data for frequency and completeness
and conformance to WQX requirements

The following checks are made:

- Column name spelling: Should be the following: Parameter, Field
  Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check
  Accuracy, % Completeness

- Columns present: All columns from the previous check should be present

- Non-numeric values: Values entered in columns other than the first
  should be numeric

- Values outside of 0 - 100: Values entered in columns other than the
  first should not be outside of 0 and 100

- Parameter: Should match parameter names in the `Simple Parameter` or
  `WQX Parameter` columns of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data

- Empty columns: Columns with all missing or NA values will return a
  warning

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
     package = 'MassWateR')

frecomdat <- suppressMessages(readxl::read_excel(frecompth, 
      skip = 1, na = c('NA', 'na', ''), 
      col_types = c('text', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
    )) %>% 
    rename(`% Completeness` = `...7`)
    
checkMWRfrecom(frecomdat)
#> Running checks on data quality objectives for frequency and completeness...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric values... OK
#>  Checking for values outside of 0 and 100... OK
#>  Checking Parameter formats... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!
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
