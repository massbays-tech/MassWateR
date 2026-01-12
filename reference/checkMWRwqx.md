# Check water quality exchange (wqx) metadata input

Check water quality exchange (wqx) metadata input

## Usage

``` r
checkMWRwqx(wqxdat, warn = TRUE)
```

## Arguments

- wqxdat:

  input data frame

- warn:

  logical to return warnings to the console (default)

## Value

`wqxdat` is returned as is if no errors are found, otherwise an
informative error message is returned prompting the user to make the
required correction to the raw data before proceeding. Checks with
warnings can be fixed at the discretion of the user before proceeding.

## Details

This function is used internally within
[`readMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md)
to run several checks on the input data for conformance with downstream
functions

The following checks are made:

- Column name spelling: Should be the following: Parameter, Sampling
  Method Context, Method Speciation, Result Sample Fraction, Analytical
  Method, Analytical Method Context

- Columns present: All columns from the previous check should be present

- Unique parameters: Values in `Parameter` should be unique (no
  duplicates)

- Parameter: Should match parameter names in the `Simple Parameter` or
  `WQX Parameter` columns of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data (warning only)

## Examples

``` r
library(dplyr)

wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')

wqxdat <- readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text')
    
checkMWRwqx(wqxdat)
#> Running checks on WQX metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking unique parameters... OK
#>  Checking Parameter formats... OK
#> 
#> All checks passed!
#> # A tibble: 8 × 6
#>   Parameter    Sampling Method Cont…¹ `Method Speciation` Result Sample Fracti…²
#>   <chr>        <chr>                  <chr>               <chr>                 
#> 1 Water Temp   NA                     NA                  NA                    
#> 2 pH           NA                     NA                  NA                    
#> 3 DO           NA                     NA                  NA                    
#> 4 Sp Conducta… NA                     NA                  NA                    
#> 5 TP           MassWateR              as P                Unfiltered            
#> 6 Nitrate      MassWateR              as N                Unfiltered            
#> 7 Ammonia      MassWateR              as N                Unfiltered            
#> 8 E.coli       MassWateR              NA                  NA                    
#> # ℹ abbreviated names: ¹​`Sampling Method Context`, ²​`Result Sample Fraction`
#> # ℹ 2 more variables: `Analytical Method` <chr>,
#> #   `Analytical Method Context` <chr>
```
