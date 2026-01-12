# Prep results data for frequency checks

Prep results data for frequency checks

## Usage

``` r
utilMWRfre(resdat, param, accdat, warn = TRUE)
```

## Arguments

- resdat:

  results data as returned by
  [`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)

- param:

  character string to filter results and check if a parameter in the
  `"Characteristic Name"` column in the results file is also found in
  the data quality objectives file for accuracy, see details

- accdat:

  `data.frame` for data quality objectives file for accuracy as returned
  by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- warn:

  logical to return warnings to the console (default)

## Value

`resdat` filtered by `param` with any entries in `"Result Value"` as
`"BDL"` or `"AQL"` replaced with appropriate values in the
`"Quantitation Limit"` column, if present, otherwise the `"MDL"` or
`"UQL"` columns from the data quality objectives file for accuracy are
used. Values as `"BDL"` use one half of the appropriate limit. Values
not in the `"Value Range"` column of the accuracy file are removed from
the output.

## Details

This function is similar to `utilMWRlimits` with some additional
processing appropriate for creating the frequency table in `tabMWRfree`.
The `param` argument is used to identify the appropriate `"MDL"` or
`"UQL"` values in the data quality objectives file for accuracy. A
warning is returned to the console if the accuracy file does not contain
the appropriate information for the parameter. Results will be filtered
by `param` regardless of any warning.

## Examples

``` r
# results file path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# results data
resdat <- readMWRresults(respth)
#> Running checks on results data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking valid Activity Types... OK
#>  Checking Activity Start Date formats... OK
#>  Checking depth data present... OK
#>  Checking for non-numeric values in Activity Depth/Height Measure... OK
#>  Checking Activity Depth/Height Unit... OK
#>  Checking Activity Relative Depth Name formats... OK
#>  Checking values in Activity Depth/Height Measure > 1 m / 3.3 ft... OK
#>  Checking Characteristic Name formats... OK
#>  Checking Result Values... OK
#>  Checking for non-numeric values in Quantitation Limit... OK
#>  Checking QC Reference Values... OK
#>  Checking for missing entries for Result Unit... OK
#>  Checking if more than one unit per Characteristic Name... OK
#>  Checking acceptable units for each entry in Characteristic Name... OK
#> 
#> All checks passed!

# accuracy path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
     package = 'MassWateR')

# accuracy data
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

# apply to total phosphorus
utilMWRfre(resdat, accdat, param = 'TP')
#> # A tibble: 95 × 23
#>    `Monitoring Location ID` `Activity Type`                `Activity Start Date`
#>    <chr>                    <chr>                          <dttm>               
#>  1 NA                       Quality Control Sample-Field … 2022-05-15 00:00:00  
#>  2 NA                       Quality Control Sample-Field … 2022-05-15 00:00:00  
#>  3 NA                       Quality Control Sample-Field … 2022-06-12 00:00:00  
#>  4 NA                       Quality Control Sample-Field … 2022-06-12 00:00:00  
#>  5 NA                       Quality Control Sample-Field … 2022-07-17 00:00:00  
#>  6 NA                       Quality Control Sample-Field … 2022-07-17 00:00:00  
#>  7 NA                       Quality Control Sample-Field … 2022-07-17 00:00:00  
#>  8 NA                       Quality Control Sample-Field … 2022-08-14 00:00:00  
#>  9 NA                       Quality Control Sample-Field … 2022-08-14 00:00:00  
#> 10 NA                       Quality Control Sample-Field … 2022-09-11 00:00:00  
#> # ℹ 85 more rows
#> # ℹ 20 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <dbl>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …

# apply to E.coli
utilMWRfre(resdat, accdat, param = 'E.coli')
#> # A tibble: 20 × 23
#>    `Monitoring Location ID` `Activity Type`                `Activity Start Date`
#>    <chr>                    <chr>                          <dttm>               
#>  1 NA                       Quality Control Sample-Field … 2022-06-13 00:00:00  
#>  2 NA                       Quality Control Sample-Field … 2022-07-18 00:00:00  
#>  3 NA                       Quality Control Sample-Field … 2022-08-01 00:00:00  
#>  4 NA                       Quality Control Sample-Field … 2022-08-29 00:00:00  
#>  5 NA                       Quality Control Sample-Lab Du… 2022-06-13 00:00:00  
#>  6 NA                       Quality Control Sample-Lab Du… 2022-07-18 00:00:00  
#>  7 NA                       Quality Control Sample-Lab Du… 2022-08-01 00:00:00  
#>  8 NA                       Quality Control Sample-Lab Du… 2022-08-29 00:00:00  
#>  9 ABT-077                  Sample-Routine                 2022-06-13 00:00:00  
#> 10 ABT-162                  Sample-Routine                 2022-06-13 00:00:00  
#> 11 ABT-077                  Sample-Routine                 2022-06-27 00:00:00  
#> 12 ABT-162                  Sample-Routine                 2022-06-27 00:00:00  
#> 13 ABT-077                  Sample-Routine                 2022-07-18 00:00:00  
#> 14 ABT-162                  Sample-Routine                 2022-07-18 00:00:00  
#> 15 ABT-077                  Sample-Routine                 2022-08-01 00:00:00  
#> 16 ABT-162                  Sample-Routine                 2022-08-01 00:00:00  
#> 17 ABT-077                  Sample-Routine                 2022-08-15 00:00:00  
#> 18 ABT-162                  Sample-Routine                 2022-08-15 00:00:00  
#> 19 ABT-077                  Sample-Routine                 2022-08-29 00:00:00  
#> 20 ABT-162                  Sample-Routine                 2022-08-29 00:00:00  
#> # ℹ 20 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <dbl>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>,
#> #   `Project ID` <chr>, `Local Record ID` <chr>, `Result Comment` <chr>, …
```
