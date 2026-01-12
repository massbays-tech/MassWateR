# Check water quality monitoring results

Check water quality monitoring results

## Usage

``` r
checkMWRresults(resdat, warn = TRUE)
```

## Arguments

- resdat:

  input data frame for results

- warn:

  logical to return warnings to the console (default)

## Value

`resdat` is returned as is if no errors are found, otherwise an
informative error message is returned prompting the user to make the
required correction to the raw data before proceeding. Checks with
warnings can be fixed at the discretion of the user before proceeding.

## Details

This function is used internally within
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
to run several checks on the input data for completeness and conformance
to WQX requirements.

The following checks are made:

- Column name spelling: Should be the following: Monitoring Location ID,
  Activity Type, Activity Start Date, Activity Start Time, Activity
  Depth/Height Measure, Activity Depth/Height Unit, Activity Relative
  Depth Name, Characteristic Name, Result Value, Result Unit,
  Quantitation Limit, QC Reference Value, Result Measure Qualifier,
  Result Attribute, Sample Collection Method ID, Project ID, Local
  Record ID, Result Comment

- Columns present: All columns from the previous check should be present

- Activity Type: Should be one of Field Msr/Obs, Sample-Routine, Quality
  Control Sample-Field Blank, Quality Control Sample-Lab Blank, Quality
  Control Sample-Lab Duplicate, Quality Control Sample-Lab Spike,
  Quality Control-Calibration Check, Quality Control-Meter Lab
  Duplicate, Quality Control-Meter Lab Blank

- Date formats: Should be mm/dd/yyyy and parsed correctly on import

- Depth data present: Depth data should be included in Activity
  Depth/Height Measure or Activity Relative Depth Name for all rows
  where Activity Type is Field Msr/Obs or Sample-Routine

- Non-numeric Activity Depth/Height Measure: All depth values should be
  numbers, excluding missing values

- Activity Depth/Height Unit: All entries should be `ft`, `m`, or blank

- Activity Relative Depth Name: Should be either Surface, Bottom,
  Midwater, Near Bottom, or blank (warning only)

- Activity Depth/Height Measure out of range: All depth values should be
  less than or equal to 1 meter / 3.3 feet or entered as Surface in the
  Activity Relative Depth Name column (warning only)

- Characteristic Name: Should match parameter names in the
  `Simple Parameter` or `WQX Parameter` columns of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data (warning only)

- Result Value: Should be a numeric value or a text value as AQL or BDL

- Non-numeric Quantitation Limit: All values should be numbers,
  excluding missing values

- QC Reference Value: Should be a numeric value or a text value as AQL
  or BDL

- Result Unit: No missing entries in `Result Unit`, except pH which can
  be blank

- Single Result Unit: Each unique parameter in `Characteristic Name`
  should have only one entry in `Result Unit` (excludes entries for lab
  spikes reported as `%` or `% recovery`)

- Correct Result Unit: Each unique parameter in `Characteristic Name`
  should have an entry in `Result Unit` that matches one of the
  acceptable values in the `Units of measure` column of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data (excludes entries for lab spikes reported as `%` or `% recovery`)

## Examples

``` r
library(dplyr)

respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

resdat <- suppressWarnings(readxl::read_excel(respth, na = c('NA', 'na', ''), guess_max = Inf)) %>% 
  dplyr::mutate_if(function(x) !lubridate::is.POSIXct(x), as.character)
             
checkMWRresults(resdat)
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
#> # ℹ 15 more variables: `Activity Start Time` <dttm>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
```
