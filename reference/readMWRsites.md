# Read site metadata from an external file

Read site metadata from an external file

## Usage

``` r
readMWRsites(sitpth, runchk = TRUE)
```

## Arguments

- sitpth:

  character string of path to the site metadata file

- runchk:

  logical to run data checks with
  [`checkMWRsites`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md)

## Value

A formatted data frame of site metadata that can be used for downstream
analysis

## Details

Data are imported with
[`read_excel`](https://readxl.tidyverse.org/reference/read_excel.html)
and checked with
[`checkMWRsites`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md).

## Examples

``` r
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')

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
head(sitdat)
#> # A tibble: 6 × 5
#>   `Monitoring Location ID` `Monitoring Location Name` Monitoring Location Lati…¹
#>   <chr>                    <chr>                                           <dbl>
#> 1 ABT-026                  Rte 2, Concord                                   42.5
#> 2 ABT-062                  Rte 62, Acton                                    42.4
#> 3 ABT-077                  Rte 27/USGS, Maynard                             42.4
#> 4 ABT-144                  Rte 62, Stow                                     42.4
#> 5 ABT-162                  Cox Street bridge                                42.4
#> 6 ABT-237                  Robin Hill Rd, Marlboro                          42.3
#> # ℹ abbreviated name: ¹​`Monitoring Location Latitude`
#> # ℹ 2 more variables: `Monitoring Location Longitude` <dbl>,
#> #   `Location Group` <chr>
```
