# Get threshold lines from thresholdMWR

Get threshold lines from thresholdMWR

## Usage

``` r
utilMWRthresh(resdat, param, thresh, threshlab = NULL)
```

## Arguments

- resdat:

  results data as returned by
  [`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)

- param:

  character string to first filter results by a parameter in
  `"Characteristic Name"`

- thresh:

  character indicating if relevant freshwater or marine threshold lines
  are included, one of `"fresh"`, `"marine"`, or `"none"`, or a single
  numeric value to override the values included with the package

- threshlab:

  optional character string indicating legend label for the threshold,
  required only if `thresh` is numeric

## Value

If `thresh` is not numeric and thresholds are available for `param`, a
`data.frame` of relevant marine or freshwater thresholds, otherwise
`NULL`. If `thresh` is numeric, a `data.frame` of the threshold with the
appropriate label from `threshlabel`.

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

# get threshold lines
utilMWRthresh(resdat = resdat, param = 'E.coli', thresh = 'fresh')
#> # A tibble: 2 × 5
#>   num   thresh label                          size linetype
#>   <chr>  <dbl> <fct>                         <dbl> <chr>   
#> 1 2       1260 STV Secondary contact (MADEP)  0.75 dashed  
#> 2 1        235 BAV Primary contact (EPA)      0.73 longdash

# user-defined numeric threshold line
utilMWRthresh(resdat = resdat, param = 'TP', thresh = 5, threshlab = 'My threshold')
#>   num thresh        label size linetype
#> 1   1      5 My threshold 0.73 longdash
```
