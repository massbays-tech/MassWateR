# Create the quality control review report

Create the quality control review report

## Usage

``` r
qcMWRreview(
  res = NULL,
  acc = NULL,
  frecom = NULL,
  cens = NULL,
  fset = NULL,
  output_dir,
  output_file = NULL,
  savesheet = FALSE,
  rawdata = TRUE,
  dqofontsize = 7.5,
  tabfontsize = 9,
  padding = 0,
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

- frecom:

  character string of path to the data quality objectives file for
  frequency and completeness or `data.frame` returned by
  [`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)

- cens:

  character string of path to the censored data file or `data.frame`
  returned by
  [`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)

- fset:

  optional list of inputs with elements named `res`, `acc`, `frecom`,
  and `cens`, overrides the other arguments

- output_dir:

  character string of the output directory for the rendered file

- output_file:

  optional character string for the file name

- savesheet:

  logical indicating if a spreadsheet of the tables in the report is
  also saved (default `FALSE`)

- rawdata:

  logical to include quality control accuracy summaries for raw data,
  e.g., field blanks, etc.

- dqofontsize:

  numeric for font size in the data quality objective tables in the
  first page of the review

- tabfontsize:

  numeric for font size in the review tables

- padding:

  numeric for row padding for table output

- warn:

  logical indicating if warnings from the table functions are included
  in the file output

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md),
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md),
  [`checkMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md),
  applies only if `res`, `acc`, or `frecom` are file paths

## Value

A compiled review report named `qcreview.docx` (or name passed to
`output_file`) will be saved in the directory specified by `output_dir`

## Details

The function compiles a review report as a Word document for all quality
control checks included in the MassWateR package. The report shows
several tables, including the data quality objectives files for
accuracy, frequency, and completeness, summary results for all accuracy
checks, summary results for all frequency checks, summary results for
all completeness checks, and individual results for all accuracy checks.
The report uses the individual table functions (which can be used
separately) to return the results, which include
[`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
[`tabMWRfre`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md),
and
[`tabMWRcom`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md).
The help files for each of these functions can be consulted for a more
detailed explanation of the quality control checks.

The workflow for using this function is to import the required data
(results, data quality objective, and censored files) and to fix any
errors noted on import prior to creating the review report. Additional
warnings that may be of interest as returned by the individual table
functions can be returned in the console by setting `warn = TRUE`.

Optional arguments that can be changed as needed include specifying the
file name with `output_file`, suppressing the raw data summaries at the
end of the report with `rawdata = FALSE`, and changing the table font
sizes (`dqofontsize` for the data quality objectives on the first page,
`tabfontsize` for the remainder). Set `savesheet = TRUE` to also save a
spreadsheet of the tables in the report.

The function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md),
and
[`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
(optional). For the former, the full suite of data checks can be
evaluated with `runkchk = T` (default) or suppressed with `runchk = F`,
as explained in the relevant help files. In the latter case, downstream
analyses may not work if data are formatted incorrectly. For
convenience, a named list with the input arguments as paths or data
frames can be passed to the `fset` argument instead. See the help file
for
[`utilMWRinput`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinput.md).

## Examples

``` r
# results data path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# dqo accuracy data path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

# dqo completeness data path
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR')

# censored data path
censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')

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

# \donttest{
# create report
qcMWRreview(res = resdat, acc = accdat, frecom = frecomdat, cens = censdat, output_dir = tempdir())
#> Report created successfully! File located at /tmp/RtmpDrafhR/qcreview.docx
# }
```
