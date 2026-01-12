# Check site metadata file

Check site metadata file

## Usage

``` r
checkMWRsites(sitdat)
```

## Arguments

- sitdat:

  input data frame

## Value

`sitdat` is returned as is if no errors are found, otherwise an
informative error message is returned prompting the user to make the
required correction to the raw data before proceeding.

## Details

This function is used internally within
[`readMWRsites`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md)
to run several checks on the input data for completeness and conformance
to WQX requirements

The following checks are made:

- Column name spelling: Should be the following: Monitoring Location ID,
  Monitoring Location Name, Monitoring Location Latitude, Monitoring
  Location Longitude, Location Group

- Columns present: All columns from the previous check should be present

- Missing longitude or latitude: No missing entries in Monitoring
  Location Latitude or Monitoring Location Longitude

- Non-numeric latitude values: Values entered in Monitoring Location
  Latitude must be numeric

- Non-numeric longitude values: Values entered in Monitoring Location
  Longitude must be numeric

- Positive longitude values: Values in Monitoring Location Longitude
  must be negative

- Missing Location ID: No missing entries for Monitoring Location ID

## Examples

``` r
library(dplyr)

sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')

sitdat <- readxl::read_excel(sitpth, na = c('NA', 'na', ''))
    
checkMWRsites(sitdat)
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
#> # A tibble: 12 × 5
#>    `Monitoring Location ID` `Monitoring Location Name`    Monitoring Location …¹
#>    <chr>                    <chr>                                          <dbl>
#>  1 ABT-026                  Rte 2, Concord                                  42.5
#>  2 ABT-062                  Rte 62, Acton                                   42.4
#>  3 ABT-077                  Rte 27/USGS, Maynard                            42.4
#>  4 ABT-144                  Rte 62, Stow                                    42.4
#>  5 ABT-162                  Cox Street bridge                               42.4
#>  6 ABT-237                  Robin Hill Rd, Marlboro                         42.3
#>  7 ABT-301                  Rte 9, Westboro                                 42.3
#>  8 ABT-312                  Mill Road, Westboro                             42.3
#>  9 DAN-013                  Danforth Br, Hudson                             42.4
#> 10 ELZ-004                  Elizabeth Br, Stow                              42.4
#> 11 HOP-011                  Hop Br, Northboro                               42.3
#> 12 NSH-002                  Nashoba, Commonwealth, W. Co…                   42.5
#> # ℹ abbreviated name: ¹​`Monitoring Location Latitude`
#> # ℹ 2 more variables: `Monitoring Location Longitude` <dbl>,
#> #   `Location Group` <chr>
```
