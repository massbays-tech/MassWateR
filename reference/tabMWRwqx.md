# Create and save tables in a single workbook for WQX upload

Create and save tables in a single workbook for WQX upload

## Usage

``` r
tabMWRwqx(
  res = NULL,
  acc = NULL,
  sit = NULL,
  wqx = NULL,
  fset = NULL,
  output_dir,
  output_file = NULL,
  listout = FALSE,
  warn = TRUE,
  runchk = TRUE
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

- sit:

  character string of path to the site metadata file or `data.frame` for
  site metadata returned by
  [`readMWRsites`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md)

- wqx:

  character string of path to the wqx metadata file or `data.frame` for
  wqx metadata returned by
  [`readMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md)

- fset:

  optional list of inputs with elements named `res`, `acc`, `frecom`,
  `sit`, or `wqx` overrides the other arguments

- output_dir:

  character string of the output directory for the results

- output_file:

  optional character string for the file name, must include .xlsx suffix

- listout:

  logical to return a list of the output for each sheet of the workbook
  (default is `FALSE`)

- warn:

  logical to return warnings to the console (default)

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md),
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md),
  [`checkMWRsites`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md),
  [`checkMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/checkMWRwqx.md),
  applies only if `res`, `acc`, `sit`, or `wqx` are file paths

## Value

An Excel workbook named `wqxtab.xlsx` (or name passed to `output_file`)
will be saved in the directory specified by `output_dir`. The workbook
will include three sheets names "Projects", "Locations", and "Results".

## Details

This function will export a single Excel workbook with three sheets,
named "Project", "Locations", and "Results". The output is populated
with as much content as possible based on information in the input
files. The remainder of the information not included in the output will
need to be manually entered before uploading the data to WQX. All
required columns are present, but individual rows will need to be
verified for completeness. It is the responsibility of the user to
verify this information is complete and correct before uploading the
data.

The workflow for using this function is to import the required data
(results, data quality objectives file for accuracy, site metadata, and
wqx metadata) and to fix any errors noted on import prior to creating
the output. The function can be used with inputs as paths to the
relevant files or as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
[`readMWRsites`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md),
and
[`readMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`, as explained in
the relevant help files. In the latter case, downstream analyses may not
work if data are formatted incorrectly. For convenience, a named list
with the input arguments as paths or data frames can be passed to the
`fset` argument instead. See the help file for
[`utilMWRinput`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinput.md).

The name of the output file can also be changed using the `output_file`
argument, the default being `wqxtab.xlsx`. Warnings can also be turned
off or on (default) using the `warn` argument. This returns any warnings
when data are imported and only applies if the file inputs are paths.

## Examples

``` r
# results data path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# dqo accuracy data path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

# site data path
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')

# wqx data path
wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')

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

# wqx data
wqxdat <- readMWRwqx(wqxpth)
#> Running checks on WQX metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking unique parameters... OK
#>  Checking Parameter formats... OK
#> 
#> All checks passed!

# create workbook
tabMWRwqx(res = resdat, acc = accdat, sit = sitdat, wqx = wqxdat, output_dir = tempdir())
#> Excel workbook created successfully! File located at /tmp/RtmpRcP5ip/wqxtab.xlsx
```
