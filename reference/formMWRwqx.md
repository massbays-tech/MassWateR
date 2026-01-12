# Format WQX metadata input

Format WQX metadata input

## Usage

``` r
formMWRwqx(wqxdat)
```

## Arguments

- wqxdat:

  input data frame for wqx metadata

## Value

A formatted data frame of the WQX metadata file

## Details

This function is used internally within
[`readMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md)
to format the input data for downstream analysis. The formatting
includes:

- Convert characteristic names: All parameters in `Characteristic Name`
  are converted to `Simple Parameter` in
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  as needed

## Examples

``` r
library(dplyr)

wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')

wqxdat <- suppressWarnings(readxl::read_excel(wqxpth, na = c('NA', 'na', ''), col_types = 'text'))
  
formMWRwqx(wqxdat)
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
