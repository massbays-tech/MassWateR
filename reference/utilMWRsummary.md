# Summarize a results data frame by a grouping variable

Summarize a results data frame by a grouping variable

## Usage

``` r
utilMWRsummary(dat, accdat, param, sumfun = "auto", confint)
```

## Arguments

- dat:

  input data frame

- accdat:

  `data.frame` for data quality objectives file for accuracy as returned
  by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- param:

  character string for the parameter to evaluate as provided in the
  `"Parameter"` column of `"accdat"`

- sumfun:

  character indicating one of `"auto"` (default), `"mean"`, `"geomean"`,
  `"median"`, `"min"`, or `"max"`, see details

- confint:

  logical if user expects a confidence interval to be returned with the
  summary

## Value

A summarized data frame, a warning will be returned if the confidence
interval cannot be estimated and `confint = TRUE`

## Details

This function summarizes a results data frame by an existing grouping
variable using the function supplied to `sumfun`. The mean or geometric
mean is used for `sumfun = "auto"` based on information in the data
quality objective file for accuracy, i.e., parameters with "log" in any
of the columns are summarized with the geometric mean, otherwise
arithmetic. Using `"mean"` or `"geomean"` for `sumfun` will apply the
appropriate function regardless of information in the data quality
objective file for accuracy.

## Examples

``` r
library(dplyr)

# results data path
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

# fill BDL, AQL
resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = "DO")

dat <- resdat %>% 
  group_by(`Monitoring Location ID`)
 
# summarize sites by mean 
utilMWRsummary(dat, accdat, param = 'DO', sumfun = 'auto', confint = TRUE)
#> # A tibble: 11 × 4
#>    `Monitoring Location ID`   lov   hiv `Result Value`
#>    <chr>                    <dbl> <dbl>          <dbl>
#>  1 ABT-026                   6.62  7.99           7.31
#>  2 ABT-062                   6.00  9.54           7.77
#>  3 ABT-077                   7.88  9.36           8.62
#>  4 ABT-144                   7.22  8.86           8.04
#>  5 ABT-237                   3.81  9.27           6.54
#>  6 ABT-301                   6.00  8.08           7.04
#>  7 ABT-312                   6.36  8.10           7.23
#>  8 DAN-013                   2.89  9.83           6.36
#>  9 ELZ-004                   3.48  6.56           5.02
#> 10 HOP-011                   4.43  9.83           7.13
#> 11 NSH-002                   4.00  8.77           6.38

# summarize sites by minimum
utilMWRsummary(dat, accdat, param = 'DO', sumfun = 'min', confint = FALSE)
#> # A tibble: 11 × 4
#>    `Monitoring Location ID` `Result Value` lov   hiv  
#>    <chr>                             <dbl> <lgl> <lgl>
#>  1 ABT-026                            6.39 NA    NA   
#>  2 ABT-062                            7.17 NA    NA   
#>  3 ABT-077                            7.96 NA    NA   
#>  4 ABT-144                            7.85 NA    NA   
#>  5 ABT-237                            5.89 NA    NA   
#>  6 ABT-301                            5.78 NA    NA   
#>  7 ABT-312                            6.05 NA    NA   
#>  8 DAN-013                            2.13 NA    NA   
#>  9 ELZ-004                            3.83 NA    NA   
#> 10 HOP-011                            4.1  NA    NA   
#> 11 NSH-002                            3.93 NA    NA   
```
