# Check censored data

Check censored data

## Usage

``` r
checkMWRcens(censdat, warn = TRUE)
```

## Arguments

- censdat:

  input data frame for results

- warn:

  logical to return warnings to the console (default)

## Value

`censdat` is returned as is if no errors are found, otherwise an
informative error message is returned prompting the user to make the
required correction to the raw data before proceeding. Checks with
warnings can be fixed at the discretion of the user before proceeding.

## Details

This function is used internally within
[`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
to run several checks on the input data for completeness and
conformance.

The following checks are made:

- Column name spelling: Should be the following: Parameter, Missed and
  Censored Records

- Columns present: All columns from the previous check should be present

- Non-numeric or empty entries in Missed and Censored Records: All
  values should be numbers

- Negative Missed and Censored Records: All values should be greater
  than or equal to zero

- Parameter: Should match parameter names in the `Simple Parameter` or
  `WQX Parameter` columns of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data (warning only)

## Examples

``` r
censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')

censdat <- suppressWarnings(readxl::read_excel(censpth, na = c('NA', 'na', ''), guess_max = Inf)) 
             
checkMWRcens(censdat)
#> Running checks on censored data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric or empty values in Missed and Censored Records... OK
#>  Checking for negative values in Missed and Censored Records... OK
#>  Checking Parameter Name formats... OK
#> 
#> All checks passed!
#> # A tibble: 8 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <dbl>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
#> 7 Ammonia                                    0
#> 8 E.coli                                     0
```
