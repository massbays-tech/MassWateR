# Read water quality monitoring results from an external file

Read water quality monitoring results from an external file

## Usage

``` r
readMWRresults(respth, runchk = TRUE, warn = TRUE, tzone = "America/Jamaica")
```

## Arguments

- respth:

  character string of path to the results file

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)

- warn:

  logical to return warnings to the console (default)

- tzone:

  character string for time zone, passed to
  [`formMWRresults`](https://massbays-tech.github.io/MassWateR/reference/formMWRresults.md)

## Value

A formatted water quality monitoring results data frame that can be used
for downstream analysis

## Details

Date are imported with
[`read_excel`](https://readxl.tidyverse.org/reference/read_excel.html),
checked with
[`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md),
and formatted with
[`formMWRresults`](https://massbays-tech.github.io/MassWateR/reference/formMWRresults.md).

## See also

[`readMWRresultsview`](https://massbays-tech.github.io/MassWateR/reference/readMWRresultsview.md)
for troubleshooting import checks

## Examples

``` r
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

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
head(resdat)
#> # A tibble: 6 × 18
#>   `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>   <chr>                    <chr>           <dttm>               
#> 1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#> 2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#> 3 ABT-301                  Field Msr/Obs   2022-05-15 00:00:00  
#> 4 ABT-312                  Field Msr/Obs   2022-05-15 00:00:00  
#> 5 DAN-013                  Field Msr/Obs   2022-05-15 00:00:00  
#> 6 ELZ-004                  Field Msr/Obs   2022-05-15 00:00:00  
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>,
#> #   `Project ID` <chr>, `Local Record ID` <chr>, `Result Comment` <chr>
```
