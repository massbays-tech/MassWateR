# Filter results data by parameter, date range, site, result attributes, and/or location group

Filter results data by parameter, date range, site, result attributes,
and/or location group

## Usage

``` r
utilMWRfilter(
  resdat,
  sitdat = NULL,
  param,
  dtrng = NULL,
  site = NULL,
  resultatt = NULL,
  locgroup = NULL,
  alllocgroup = FALSE,
  allresultatt = FALSE
)
```

## Arguments

- resdat:

  results data as returned by
  [`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)

- sitdat:

  site metadata file as returned by
  [`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)

- param:

  character string to filter results by a parameter in
  `"Characteristic Name"`

- dtrng:

  character string of length two for the date ranges as YYYY-MM-DD

- site:

  character string of sites to include, default all

- resultatt:

  character string of result attributes to include, default all

- locgroup:

  character string of location groups to include from the
  `"Location Group"` column in the site metadata file

- alllocgroup:

  logical indicating if results data are filtered by all location groups
  in `"Location Group"` in the site metadata file if `locgroup = NULL`,
  used only in
  [`anlzMWRdate`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRdate.md)

- allresultatt:

  logical indicating if results data are filtered by all result
  attributes if `resultatt = NULL`, used only in
  [`anlzMWRsite`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRsite.md)

## Value

`resdat` filtered by `param`, `dtrng`, `site`, `resultatt`, and/or
`locgroup`, otherwise `resdat` filtered only by `param` if other
arguments are `NULL`

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

# site data path
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')

# site data
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

# filter by parameter, date range
utilMWRfilter(resdat, param = 'DO', dtrng = c('2022-06-01', '2022-06-30'))
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
utilMWRfilter(resdat, param = 'DO', site = c('ABT-026', 'ABT-062', 'ABT-077'))
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
utilMWRfilter(resdat, param = 'DO', resultatt = 'DRY')
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
utilMWRfilter(resdat, param = 'DO', sitdat = sitdat, 
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
