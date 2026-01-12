# MassWateR utility functions

The MassWateR package includes several “utility” functions (using the
`util` prefix) that are used inside other functions to accomplish
routine tasks. Although these functions will typically not be used by
themselves, they may be useful for custom analyses. The full list of
utility functions can be viewed on the
[functions](https://massbays-tech.github.io/MassWateR/reference/index.html#utility-functions)
page. Some of these are described below.

Most of the utility functions require only the results data, data
quality objectives file for accuracy, or the site metadata file. Note
that all of the utility functions require data as input, whereas most of
the primary MassWateR functions can accept a file path or the data. The
`fset` argument also does not apply to the utility functions.

``` r
library(MassWateR)

# import results data
respth <- system.file("extdata/ExampleResults.xlsx", package = "MassWateR")
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

# import accuracy data
accpth <- system.file("extdata/ExampleDQOAccuracy.xlsx", package = "MassWateR")
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

# import site metadata
sitpth <- system.file("extdata/ExampleSites.xlsx", package = "MassWateR")
sitdat <- readMWRsites(sitpth)
#> Running checks on site metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for missing latitude or longitude values... OK
#>  Checking for non-numeric values in latitude... OK
#>  Checking for non-numeric values in longitude... OK
#>  Checking for positive values in longitude... OK
#>  Checking for missing entries for Monitoring Location ID... OK
#> 
#> All checks passed!
```

## Fill data outside of detection or quantitation limit

The
[`utilMWRlimits()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRlimits.md)
function replaces any text qualifiers in the `"Result Value"` column of
the results file that are outside of detection (`"BDL"` or `"AQL"`) with
appropriate numeric values. The values are replaced with those from the
`"Quanitation Limit"` column, if present, otherwise the `"MDL"` or
`"UQL"` columns from the data quality objectives file for accuracy are
used. Values as `"BDL"` use one half of the appropriate limit. The
output only includes rows with the activity type as `"Field Msr/Obs"` or
`"Sample-Routine"` and is filtered by the chosen parameter. The function
can be useful for analysis because the measurements are returned as
numeric values (e.g., for plotting).

``` r
utilMWRlimits(resdat = resdat, accdat = accdat, param = 'TP')
#> # A tibble: 48 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Sample-Routine  2022-05-15 00:00:00  
#>  2 ABT-077                  Sample-Routine  2022-05-15 00:00:00  
#>  3 ABT-301                  Sample-Routine  2022-05-15 00:00:00  
#>  4 ABT-312                  Sample-Routine  2022-05-15 00:00:00  
#>  5 DAN-013                  Sample-Routine  2022-05-15 00:00:00  
#>  6 ELZ-004                  Sample-Routine  2022-05-15 00:00:00  
#>  7 HOP-011                  Sample-Routine  2022-05-15 00:00:00  
#>  8 NSH-002                  Sample-Routine  2022-05-15 00:00:00  
#>  9 ABT-026                  Sample-Routine  2022-06-12 00:00:00  
#> 10 ABT-062                  Sample-Routine  2022-06-12 00:00:00  
#> # ℹ 38 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <dbl>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
```

## Filter results data

The
[`utilMWRfilter()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRfilter.md)
function filters rows in the results data by parameter, date range,
sites, result attributes, and/or location groups. No other changes to
the data are made other than filtering the relevant rows based on the
input. The function is designed to provide informative errors, e.g., the
available result attributes will be shown in the error if the attribute
provided is invalid. Filtering by location group requires the site
metadata file.

``` r
# filter by parameter, date range
utilMWRfilter(resdat = resdat, param = 'DO', dtrng = c('2022-06-01', '2022-06-30'))
#> # A tibble: 11 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#>  2 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#>  3 ABT-077                  Field Msr/Obs   2022-06-12 00:00:00  
#>  4 ABT-144                  Field Msr/Obs   2022-06-12 00:00:00  
#>  5 ABT-237                  Field Msr/Obs   2022-06-12 00:00:00  
#>  6 ABT-301                  Field Msr/Obs   2022-06-12 00:00:00  
#>  7 ABT-312                  Field Msr/Obs   2022-06-12 00:00:00  
#>  8 DAN-013                  Field Msr/Obs   2022-06-12 00:00:00  
#>  9 ELZ-004                  Field Msr/Obs   2022-06-12 00:00:00  
#> 10 HOP-011                  Field Msr/Obs   2022-06-12 00:00:00  
#> 11 NSH-002                  Field Msr/Obs   2022-06-12 00:00:00  
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>,
#> #   `Project ID` <chr>, `Local Record ID` <chr>, `Result Comment` <chr>

# filter by parameter, site
utilMWRfilter(resdat = resdat, param = 'DO', site = c('ABT-026', 'ABT-062', 'ABT-077'))
#> # A tibble: 13 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#>  2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#>  3 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#>  4 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#>  5 ABT-077                  Field Msr/Obs   2022-06-12 00:00:00  
#>  6 ABT-026                  Field Msr/Obs   2022-07-17 00:00:00  
#>  7 ABT-062                  Field Msr/Obs   2022-07-17 00:00:00  
#>  8 ABT-077                  Field Msr/Obs   2022-07-17 00:00:00  
#>  9 ABT-026                  Field Msr/Obs   2022-08-14 00:00:00  
#> 10 ABT-062                  Field Msr/Obs   2022-08-14 00:00:00  
#> 11 ABT-077                  Field Msr/Obs   2022-08-14 00:00:00  
#> 12 ABT-026                  Field Msr/Obs   2022-09-11 00:00:00  
#> 13 ABT-077                  Field Msr/Obs   2022-09-11 00:00:00  
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>,
#> #   `Project ID` <chr>, `Local Record ID` <chr>, `Result Comment` <chr>

# filter by parameter, result attribute
utilMWRfilter(resdat = resdat, param = 'DO', resultatt = 'DRY')
#> # A tibble: 27 × 18
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
#>  9 ABT-026                  Field Msr/Obs   2022-08-14 00:00:00  
#> 10 ABT-062                  Field Msr/Obs   2022-08-14 00:00:00  
#> # ℹ 17 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …

# filter by parameter, location group, date range
utilMWRfilter(resdat = resdat, param = 'DO', sitdat = sitdat,
     locgroup = 'Assabet', dtrng = c('2022-06-01', '2022-06-30'))
#> # A tibble: 7 × 19
#>   `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>   <chr>                    <chr>           <dttm>               
#> 1 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#> 2 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#> 3 ABT-077                  Field Msr/Obs   2022-06-12 00:00:00  
#> 4 ABT-144                  Field Msr/Obs   2022-06-12 00:00:00  
#> 5 ABT-237                  Field Msr/Obs   2022-06-12 00:00:00  
#> 6 ABT-301                  Field Msr/Obs   2022-06-12 00:00:00  
#> 7 ABT-312                  Field Msr/Obs   2022-06-12 00:00:00  
#> # ℹ 16 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>,
#> #   `Project ID` <chr>, `Local Record ID` <chr>, `Result Comment` <chr>, …
```

## Summarize parameters by group

The
[`utilMWRsummary()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRsummary.md)
function summarizes results data for a parameter, either across all rows
or by arbitrary row groups, e.g., mean concentrations for sites across
dates. The
[`utilMWRlimits()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRlimits.md)
function must be used first and a grouping variable can be specified
using
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) from
the [dplyr](https://dplyr.tidyverse.org/) package (included with
MassWateR). The default is to summarize as the mean or geometric mean
based on information in the data quality objective file for accuracy.

``` r
library(dplyr)

# fill BDL, AQL
resdat <- utilMWRlimits(resdat = resdat, accdat = accdat, param = "DO")

# identify site as grouping variable
dat <- resdat %>% 
  group_by(`Monitoring Location ID`)

# arithmetic means   
utilMWRsummary(dat = dat, accdat = accdat, param = "DO", confint = TRUE)
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

# geometric means
utilMWRsummary(dat = dat, accdat = accdat, param = "E.coli", confint = TRUE)
#> # A tibble: 11 × 4
#>    `Monitoring Location ID`   lov   hiv `Result Value`
#>    <chr>                    <dbl> <dbl>          <dbl>
#>  1 ABT-026                   6.61  8.03           7.29
#>  2 ABT-062                   6.19  9.71           7.75
#>  3 ABT-077                   7.89  9.38           8.60
#>  4 ABT-144                   7.27  8.89           8.04
#>  5 ABT-237                   4.34  9.68           6.48
#>  6 ABT-301                   6.01  8.15           7.00
#>  7 ABT-312                   6.34  8.18           7.20
#>  8 DAN-013                   2.71 11.8            5.67
#>  9 ELZ-004                   3.64  6.60           4.90
#> 10 HOP-011                   4.48 10.4            6.83
#> 11 NSH-002                   4.08  9.20           6.13
```

Alternative summary options can be used with the `sumfun` argument and
include `"mean"`, `"geomean"`, `"median"`, `"min"`, or `"max"`. Using
`"mean"` or `"geomean"` will override any information in the accuracy
file. Additionally, confidence intervals can only be returned if
`sumfun` is `"auto"`, `"mean"`, or `"geomean"`. Here, the median is
returned.

``` r
# median E. coli
utilMWRsummary(dat = dat, accdat = accdat, param = "E.coli", confint = FALSE, sumfun = 'median')
#> # A tibble: 11 × 4
#>    `Monitoring Location ID` `Result Value` lov   hiv  
#>    <chr>                             <dbl> <lgl> <lgl>
#>  1 ABT-026                            7.58 NA    NA   
#>  2 ABT-062                            7.59 NA    NA   
#>  3 ABT-077                            8.94 NA    NA   
#>  4 ABT-144                            7.85 NA    NA   
#>  5 ABT-237                            5.92 NA    NA   
#>  6 ABT-301                            7.07 NA    NA   
#>  7 ABT-312                            7.42 NA    NA   
#>  8 DAN-013                            8    NA    NA   
#>  9 ELZ-004                            4.46 NA    NA   
#> 10 HOP-011                            7.8  NA    NA   
#> 11 NSH-002                            7.06 NA    NA
```

## Get surface measurements only

The
[`utilMWRfiltersurface()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRfiltersurface.md)
function returns only surface measurements from the results data. The
function will filter the results where `"Activity Depth/Height Measure"`
is less than or equal to 1 meter or 3.3 feet or the
`"Activity Relative Depth Name"` is `"Surface"`, where the latter takes
precedent.

``` r
utilMWRfiltersurface(resdat = resdat)
#> # A tibble: 49 × 18
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
#> # ℹ 39 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <dbl>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
```
