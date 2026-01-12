# Format water quality monitoring results

Format water quality monitoring results

## Usage

``` r
formMWRresults(resdat, tzone = "America/Jamaica")
```

## Arguments

- resdat:

  input data frame for results

- tzone:

  character string for time zone

## Value

A formatted data frame of the water quality monitoring results file

## Details

This function is used internally within
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
to format the input data for downstream analysis. The formatting
includes:

- Fix date and time inputs: Activity Start Date is converted to
  YYYY-MM-DD as a date object, Actvity Start Time is convered to HH:MM
  as a character to fix artifacts from Excel import

- Minor formatting for Result Unit: For conformance to WQX, e.g., ppt is
  changed to ppth, s.u. is changed to NA

- Convert characteristic names: All parameters in `Characteristic Name`
  are converted to `Simple Parameter` in
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  as needed

## Examples

``` r
library(dplyr)

respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), guess_max = Inf)) %>% 
  dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character)
  
formMWRresults(resdat)
#> # A tibble: 571 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#>  2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#>  3 ABT-301                  Field Msr/Obs   2022-05-15 00:00:00  
#>  4 ABT-312                  Field Msr/Obs   2022-05-15 00:00:00  
#>  5 DAN-013                  Field Msr/Obs   2022-05-15 00:00:00  
#>  6 ELZ-004                  Field Msr/Obs   2022-05-15 00:00:00  
#>  7 HOP-011                  Field Msr/Obs   2022-05-15 00:00:00  
#>  8 NSH-002                  Field Msr/Obs   2022-05-15 00:00:00  
#>  9 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#> 10 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#> # ℹ 561 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
```
