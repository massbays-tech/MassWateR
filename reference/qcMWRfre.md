# Run quality control frequency checks for water quality monitoring results

Run quality control frequency checks for water quality monitoring
results

## Usage

``` r
qcMWRfre(
  res = NULL,
  acc = NULL,
  frecom = NULL,
  fset = NULL,
  runchk = TRUE,
  warn = TRUE
)
```

## Arguments

- res:

  character string of path to the results file or `data.frame` for
  results returned by
  [`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)

- acc:

  character string of path to the data quality objectives file for
  accuracy or `data.frame` returned by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- frecom:

  character string of path to the data quality objectives file for
  frequency and completeness or `data.frame` returned by
  [`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)

- fset:

  optional list of inputs with elements named `res`, `acc`, `frecom`,
  `sit`, or `wqx` overrides the other arguments

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)
  and
  [`checkMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md),
  applies only if `res` or `frecom` are file paths

- warn:

  logical to return warnings to the console (default)

## Value

The output shows the frequency checks from the input files. Each row
applies to a frequency check for a parameter. The `Parameter` column
shows the parameter, the `obs` column shows the total records that apply
to regular activity types, the `check` column shows the relevant
activity type for each frequency check, the `count` column shows the
number of records that apply to a check, the `standard` column shows the
relevant percentage required for the quality control check from the
quality control objectives file, and the `met` column shows if the
standard was met by comparing if `percent` is greater than or equal to
`standard`.

## Details

The function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
and
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`. In the latter
case, downstream analyses may not work if data are formatted
incorrectly. For convenience, a named list with the input arguments as
paths or data frames can be passed to the `fset` argument instead. See
the help file for
[`utilMWRinput`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinput.md).

Note that frequency is only evaluated on parameters in the `Parameter`
column in the data quality objectives frequency and completeness file. A
warning is returned if there are parameters in `Parameter` in the
frequency and completeness file that are not in `Characteristic Name` in
the results file.

Similarly, parameters in the results file in the `Characteristic Name`
column that are not found in the data quality objectives frequency and
completeness file are not evaluated. A warning is returned if there are
parameters in `Characteristic Name` in the results file that are not in
`Parameter` in the frequency and completeness file.

## Examples

``` r
##
# using file paths

# results path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# dqo accuracy data path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

# frequency and completeness path
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
     package = 'MassWateR')

qcMWRfre(res = respth, acc = accpth, frecom = frecompth)
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
#> Running checks on data quality objectives for frequency and completeness...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric values... OK
#>  Checking for values outside of 0 and 100... OK
#>  Checking Parameter formats... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!
#> # A tibble: 40 × 7
#>    Parameter   obs check                count standard percent met  
#>    <chr>     <int> <chr>                <int>    <dbl>   <dbl> <lgl>
#>  1 Ammonia      43 Field Duplicate          4       10    9.30 FALSE
#>  2 Ammonia      43 Lab Duplicate           10        5   23.3  TRUE 
#>  3 Ammonia      43 Field Blank              7       10   16.3  TRUE 
#>  4 Ammonia      43 Lab Blank                7        5   16.3  TRUE 
#>  5 Ammonia      43 Spike/Check Accuracy     9        5   20.9  TRUE 
#>  6 DO           49 Field Duplicate         11       10   22.4  TRUE 
#>  7 DO           49 Lab Duplicate            0       NA   NA    NA   
#>  8 DO           49 Field Blank              0       NA   NA    NA   
#>  9 DO           49 Lab Blank                0       NA   NA    NA   
#> 10 DO           49 Spike/Check Accuracy     0       NA   NA    NA   
#> # ℹ 30 more rows

##
# using data frames

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

# frequency and completeness data
frecomdat <- readMWRfrecom(frecompth)
#> Running checks on data quality objectives for frequency and completeness...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric values... OK
#>  Checking for values outside of 0 and 100... OK
#>  Checking Parameter formats... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!

qcMWRfre(res = resdat, acc = accdat, frecom = frecomdat)
#> # A tibble: 40 × 7
#>    Parameter   obs check                count standard percent met  
#>    <chr>     <int> <chr>                <int>    <dbl>   <dbl> <lgl>
#>  1 Ammonia      43 Field Duplicate          4       10    9.30 FALSE
#>  2 Ammonia      43 Lab Duplicate           10        5   23.3  TRUE 
#>  3 Ammonia      43 Field Blank              7       10   16.3  TRUE 
#>  4 Ammonia      43 Lab Blank                7        5   16.3  TRUE 
#>  5 Ammonia      43 Spike/Check Accuracy     9        5   20.9  TRUE 
#>  6 DO           49 Field Duplicate         11       10   22.4  TRUE 
#>  7 DO           49 Lab Duplicate            0       NA   NA    NA   
#>  8 DO           49 Field Blank              0       NA   NA    NA   
#>  9 DO           49 Lab Blank                0       NA   NA    NA   
#> 10 DO           49 Spike/Check Accuracy     0       NA   NA    NA   
#> # ℹ 30 more rows
```
