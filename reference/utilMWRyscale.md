# Get logical value for y axis scaling

Get logical value for y axis scaling

## Usage

``` r
utilMWRyscale(accdat, param, yscl = "auto")
```

## Arguments

- accdat:

  `data.frame` for data quality objectives file for accuracy as returned
  by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- param:

  character string for the parameter to evaluate as provided in the
  `"Parameter"` column of `"accdat"`

- yscl:

  character indicating one of `"auto"` (default), `"log"`, or `"linear"`

## Value

A logical value indicating `TRUE` for log10-scale, `FALSE` for
arithmetic (linear)

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

# log auto
utilMWRyscale(accdat, param = 'E.coli')
#> [1] TRUE

# linear force
utilMWRyscale(accdat, param = 'E.coli', yscl = 'linear')
#> [1] FALSE

# linear auto
utilMWRyscale(accdat, param = 'DO')
#> [1] FALSE

# log force
utilMWRyscale(accdat, param = 'DO', yscl = 'log')
#> [1] TRUE
```
