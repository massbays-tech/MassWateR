# Run quality control completeness checks for water quality monitoring results

Run quality control completeness checks for water quality monitoring
results

## Usage

``` r
qcMWRcom(
  res = NULL,
  frecom = NULL,
  cens = NULL,
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

- frecom:

  character string of path to the data quality objectives file for
  frequency and completeness or `data.frame` returned by
  [`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)

- cens:

  character string of path to the censored data file or `data.frame`
  returned by
  [`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md),
  optional

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

The output shows the completeness checks from the combined files. Each
row applies to a completeness check for a parameter. The `datarec` and
`qualrec` columns show the number of data records and qualified records,
respectively. The `datarec` column specifically shows only records not
for quality control by excluding those as duplicates, blanks, or spikes
in the count. The `standard` column shows the relevant percentage
required for the quality control check from the quality control
objectives file, the `complete` column shows the calculated completeness
taken from the input data, and the `met` column shows if the standard
was met by comparing if `complete` is greater than or equal to
`standard`.

## Details

The function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md),
and
[`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
(optional). For the former, the full suite of data checks can be
evaluated with `runkchk = T` (default) or suppressed with `runchk = F`.
In the latter case, downstream analyses may not work if data are
formatted incorrectly. For convenience, a named list with the input
arguments as paths or data frames can be passed to the `fset` argument
instead. See the help file for
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

A similar warning is returned if there are parameters in the censored
data, if provided, that are not in the results file. However, an error
is returned if there are parameters in the data quality objectives
frequency and completeness file that are not in the censored data file.

All warnings can be suppressed by setting `warn = FALSE`.

## Examples

``` r
##
# using file paths

# results path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# frequency and completeness path
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
     package = 'MassWateR')

# censored path
censpth <- system.file('extdata/ExampleCensored.xlsx', 
     package = 'MassWateR')

qcMWRcom(res = respth, frecom = frecompth, cens = censpth)
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
#> Running checks on data quality objectives for frequency and completeness...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric values... OK
#>  Checking for values outside of 0 and 100... OK
#>  Checking Parameter formats... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!
#> Running checks on censored data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric or empty values in Missed and Censored Records... OK
#>  Checking for negative values in Missed and Censored Records... OK
#>  Checking Parameter Name formats... OK
#> 
#> All checks passed!
#> # A tibble: 8 × 7
#>   Parameter      datarec qualrec standard Missed and Censored R…¹ complete met  
#>   <chr>            <int>   <int>    <dbl>                   <int>    <dbl> <lgl>
#> 1 Ammonia             43       0       90                       0    100   TRUE 
#> 2 DO                  49       0       90                       1     98   TRUE 
#> 3 E.coli              12       0       90                       0    100   TRUE 
#> 4 Nitrate             20       0       90                       0    100   TRUE 
#> 5 Sp Conductance      49       0       90                       0    100   TRUE 
#> 6 TP                  48       5       90                       0     89.6 FALSE
#> 7 Water Temp          49       0       90                       0    100   TRUE 
#> 8 pH                  49       0       90                      12     80.3 FALSE
#> # ℹ abbreviated name: ¹​`Missed and Censored Records`

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

# censored data
censdat <- readMWRcens(censpth)
#> Running checks on censored data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric or empty values in Missed and Censored Records... OK
#>  Checking for negative values in Missed and Censored Records... OK
#>  Checking Parameter Name formats... OK
#> 
#> All checks passed!

qcMWRcom(res = resdat, frecom = frecomdat, cens = censdat)
#> # A tibble: 8 × 7
#>   Parameter      datarec qualrec standard Missed and Censored R…¹ complete met  
#>   <chr>            <int>   <int>    <dbl>                   <int>    <dbl> <lgl>
#> 1 Ammonia             43       0       90                       0    100   TRUE 
#> 2 DO                  49       0       90                       1     98   TRUE 
#> 3 E.coli              12       0       90                       0    100   TRUE 
#> 4 Nitrate             20       0       90                       0    100   TRUE 
#> 5 Sp Conductance      49       0       90                       0    100   TRUE 
#> 6 TP                  48       5       90                       0     89.6 FALSE
#> 7 Water Temp          49       0       90                       0    100   TRUE 
#> 8 pH                  49       0       90                      12     80.3 FALSE
#> # ℹ abbreviated name: ¹​`Missed and Censored Records`
```
