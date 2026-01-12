# Read data quality objectives for accuracy from an external file

Read data quality objectives for accuracy from an external file

## Usage

``` r
readMWRacc(accpth, runchk = TRUE, warn = TRUE)
```

## Arguments

- accpth:

  character string of path to the data quality objectives file for
  accuracy

- runchk:

  logical to run data checks with
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)

- warn:

  logical to return warnings to the console (default)

## Value

A formatted data frame of data quality objectives for completeness that
can be used for downstream analysis

## Details

Data are imported with
[`read_excel`](https://readxl.tidyverse.org/reference/read_excel.html)
and checked with
[`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md).

## Examples

``` r
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

accdat <- readMWRacc(accpth)
#> Running checks on data quality objectives for accuracy...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking column types... OK
#>  Checking no "na" in Value Range... OK
#>  Checking for text other than <=, ≤, <, >=, ≥, >, ±, %, AQL, BQL, log, or all... OK
#>  Checking overlaps in Value Range... OK
#>  Checking gaps in Value Range... OK
#>  Checking Parameter formats... OK
#>  Checking for missing entries for unit (uom)... OK
#>  Checking if more than one unit (uom) per Parameter... OK
#>  Checking acceptable units (uom) for each entry in Parameter... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!
head(accdat)
#> # A tibble: 6 × 10
#>   Parameter    uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>   <chr>        <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#> 1 Water Temp   deg C    NA    NA all           <= 1.0            <= 1.0         
#> 2 pH           NA       NA    NA all           <= 0.5            <= 0.5         
#> 3 DO           mg/l     NA    NA < 4           < 20%             NA             
#> 4 DO           mg/l     NA    NA >= 4          < 10%             NA             
#> 5 Sp Conducta… uS/cm    NA    NA < 250         < 30%             < 30%          
#> 6 Sp Conducta… uS/cm    NA 10000 >= 250        < 20%             < 20%          
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
```
