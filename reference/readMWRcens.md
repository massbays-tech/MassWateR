# Read censored data from an external file

Read censored data from an external file

## Usage

``` r
readMWRcens(censpth, runchk = TRUE, warn = TRUE)
```

## Arguments

- censpth:

  character string of path to the censored file

- runchk:

  logical to run data checks with
  [`checkMWRcens`](https://massbays-tech.github.io/MassWateR/reference/checkMWRcens.md)

- warn:

  logical to return warnings to the console (default)

## Value

A formatted censored data frame that can be used for downstream analysis

## Details

Data are imported with
[`read_excel`](https://readxl.tidyverse.org/reference/read_excel.html),
checked with
[`checkMWRcens`](https://massbays-tech.github.io/MassWateR/reference/checkMWRcens.md),
and formatted with
[`formMWRcens`](https://massbays-tech.github.io/MassWateR/reference/formMWRcens.md).
The input file includes rows for each parameter and two columns
indicating the parameter name and number of missed or censored records
for that parameter. The data are used to complete the number of missed
and censored records column for the completeness table created with
[`tabMWRcom`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
and is an optional input. The parameters in this file must match those
in the data quality objectives file for frequency and completeness.

## Examples

``` r
censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')

censdat <- readMWRcens(censpth)
#> Running checks on censored data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric or empty values in Missed and Censored Records... OK
#>  Checking for negative values in Missed and Censored Records... OK
#>  Checking Parameter Name formats... OK
#> 
#> All checks passed!
head(censdat)
#> # A tibble: 6 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <int>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
```
