# Read water quality exchange (wqx) metadata input from an external file

Read water quality exchange (wqx) metadata input from an external file

## Usage

``` r
readMWRwqx(wqxpth, runchk = TRUE, warn = TRUE)
```

## Arguments

- wqxpth:

  character string of path to the wqx metadata file

- runchk:

  logical to run data checks with
  [`checkMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/checkMWRwqx.md)

- warn:

  logical to return warnings to the console (default)

## Value

A formatted data frame that can be used for downstream analysis

## Details

Date are imported with
[`read_excel`](https://readxl.tidyverse.org/reference/read_excel.html),
checked with
[`checkMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/checkMWRwqx.md).

## Examples

``` r
wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')

wqxdat <- readMWRwqx(wqxpth)
#> Running checks on WQX metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking unique parameters... OK
#>  Checking Parameter formats... OK
#> 
#> All checks passed!
head(wqxdat)
#> # A tibble: 6 × 6
#>   Parameter    Sampling Method Cont…¹ `Method Speciation` Result Sample Fracti…²
#>   <chr>        <chr>                  <chr>               <chr>                 
#> 1 Water Temp   NA                     NA                  NA                    
#> 2 pH           NA                     NA                  NA                    
#> 3 DO           NA                     NA                  NA                    
#> 4 Sp Conducta… NA                     NA                  NA                    
#> 5 TP           MassWateR              as P                Unfiltered            
#> 6 Nitrate      MassWateR              as N                Unfiltered            
#> # ℹ abbreviated names: ¹​`Sampling Method Context`, ²​`Result Sample Fraction`
#> # ℹ 2 more variables: `Analytical Method` <chr>,
#> #   `Analytical Method Context` <chr>
```
