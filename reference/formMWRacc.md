# Format data quality objective accuracy data

Format data quality objective accuracy data

## Usage

``` r
formMWRacc(accdat)
```

## Arguments

- accdat:

  input data fram

## Value

A formatted data frame of the data quality objectives file for accuracy

## Details

This function is used internally within
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
to format the input data for downstream analysis. The formatting
includes:

- Minor formatting for units: For conformance to WQX, e.g., ppt is
  changed to ppth, s.u. is changed to NA in `uom`

- Convert Parameter: All parameters are converted to `Simple Parameter`
  in
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  as needed

- Remove unicode: Remove or replace unicode characters with those that
  can be used in logical expressions in
  [`qcMWRacc`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md),
  e.g., replace \\\geq\\ with \\\>=\\

- Convert limits to numeric: Convert `MDL` and `UQL` columns to numeric

## Examples

``` r
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

accdat <- readxl::read_excel(accpth, na = c('NA', ''))
accdat <- dplyr::mutate(accdat, dplyr::across(-c(`Value Range`), ~ dplyr::na_if(.x, 'na')))

formMWRacc(accdat)
#> # A tibble: 12 × 10
#>    Parameter   uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>    <chr>       <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#>  1 Water Temp  deg C NA       NA all           <= 1.0            <= 1.0         
#>  2 pH          NA    NA       NA all           <= 0.5            <= 0.5         
#>  3 DO          mg/l  NA       NA < 4           < 20%             NA             
#>  4 DO          mg/l  NA       NA >= 4          < 10%             NA             
#>  5 Sp Conduct… uS/cm NA       NA < 250         < 30%             < 30%          
#>  6 Sp Conduct… uS/cm NA    10000 >= 250        < 20%             < 20%          
#>  7 TP          mg/l   0.01    NA < 0.05        <= 0.01           <= 0.01        
#>  8 TP          mg/l   0.01    NA >= 0.05       < 30%             < 20%          
#>  9 Nitrate     mg/l   0.05    NA all           < 30%             < 20%          
#> 10 Ammonia     mg/l   0.1     NA all           < 30%             < 20%          
#> 11 E.coli      MPN/…  1       NA <50           < log30%          < log30%       
#> 12 E.coli      MPN/…  1       NA >=50          < log20%          < log20%       
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
```
