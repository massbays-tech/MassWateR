# Check if incomplete range in `Value Range` column

Check if incomplete range in `Value Range` column

## Usage

``` r
utilMWRvaluerange(accdat)
```

## Arguments

- accdat:

  `data.frame` for data quality objectives file for accuracy as returned
  by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

## Value

A named vector of `"gap"`, `"nogap"`, or `"overlap"` indicating if a gap
is present, no gap is present, or an overlap is present in the ranges
provided by the value range for each parameter. The names correspond to
the parameters.

## Details

The function evaluates if an incomplete or overlapping range is present
in the `Value Range` column of the data quality objectives file for
accuracy

## Examples

``` r
# accuracy path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
     package = 'MassWateR')

# accuracy data with no checks
accdat <- readxl::read_excel(accpth, na = c('NA', ''), col_types = 'text')
accdat <- dplyr::mutate(accdat, dplyr::across(-c(`Value Range`), ~ dplyr::na_if(.x, 'na'))) 

utilMWRvaluerange(accdat)
#>        Ammonia             DO         E.coli        Nitrate Sp Conductance 
#>        "nogap"        "nogap"        "nogap"        "nogap"        "nogap" 
#>             TP     Water Temp             pH 
#>        "nogap"        "nogap"        "nogap" 
```
