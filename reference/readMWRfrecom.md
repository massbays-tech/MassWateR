# Read data quality objectives for frequency and completeness from an external file

Read data quality objectives for frequency and completeness from an
external file

## Usage

``` r
readMWRfrecom(frecompth, runchk = TRUE, warn = TRUE)
```

## Arguments

- frecompth:

  character string of path to the data quality objectives file for
  frequency and completeness

- runchk:

  logical to run data checks with
  [`checkMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md)

- warn:

  logical to return warnings to the console (default)

## Value

A formatted data frame of data quality objectives for frequency and
completeness that can be used for downstream analysis

## Details

Data are imported with
[`read_excel`](https://readxl.tidyverse.org/reference/read_excel.html)
and checked with
[`checkMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md).

## Examples

``` r
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
     package = 'MassWateR')

frecomdat <- readMWRfrecom(frecompth)
#> Running checks on data quality objectives for frequency and completeness...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric values... OK
#>  Checking for values outside of 0 and 100... OK
#>  Checking Parameter formats... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!
head(frecomdat)
#> # A tibble: 6 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Water Temp                    10              10            NA          NA
#> 2 pH                            10              10            NA          NA
#> 3 DO                            10              NA            NA          NA
#> 4 Sp Conductance                10              10            NA          10
#> 5 TP                            10               5            10           5
#> 6 Nitrate                       10               5            10           5
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
```
