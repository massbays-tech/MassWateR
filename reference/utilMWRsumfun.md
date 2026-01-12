# Verify summary function

Verify summary function

## Usage

``` r
utilMWRsumfun(accdat, param, sumfun = "auto")
```

## Arguments

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

## Value

Character indicating the appropriate summary function based on the value
passed to `sumfun`.

## Details

This function verifies appropriate summary functions are passed from
`sumfun`. The mean or geometric mean output is used for
`sumfun = "auto"` based on information in the data quality objective
file for accuracy, i.e., parameters with "log" in any of the columns are
summarized with the geometric mean, otherwise arithmetic. Using `"mean"`
or `"geomean"` for `sumfun` will apply the appropriate function
regardless of information in the data quality objective file for
accuracy.

## Examples

``` r
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

# geomean auto
utilMWRsumfun(accdat, param = 'E.coli')
#> [1] "geomean"

# mean force
utilMWRsumfun(accdat, param = 'E.coli', sumfun = 'mean')
#> [1] "mean"

# mean auto
utilMWRsumfun(accdat, param = 'DO')
#> [1] "mean"

# geomean force
utilMWRsumfun(accdat, param = 'DO', sumfun = 'geomean')
#> [1] "geomean"
```
