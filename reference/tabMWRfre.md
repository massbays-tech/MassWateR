# Create a formatted table of quality control frequency checks

Create a formatted table of quality control frequency checks

## Usage

``` r
tabMWRfre(
  res = NULL,
  acc = NULL,
  frecom = NULL,
  fset = NULL,
  runchk = TRUE,
  warn = TRUE,
  type = c("summary", "percent"),
  pass_col = "#57C4AD",
  fail_col = "#DB4325",
  digits = 0,
  suffix = "%"
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

- type:

  character string indicating `summary` or `percent` tabular output, see
  datails

- pass_col:

  character string (as hex code) for the cell color of checks that pass,
  applies only if `type = 'percent'`

- fail_col:

  character string (as hex code) for the cell color of checks that fail,
  applies only if `type = 'percent'`

- digits:

  numeric indicating number of significant digits to report for
  percentages

- suffix:

  character string indicating suffix to append to percentage values

## Value

A
[`flextable`](https://davidgohel.github.io/flextable/reference/flextable.html)
object with formatted results.

## Details

The function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
and
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`, as explained in
the relevant help files. In the latter case, downstream analyses may not
work if data are formatted incorrectly. For convenience, a named list
with the input arguments as paths or data frames can be passed to the
`fset` argument instead. See the help file for
[`utilMWRinput`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinput.md).

Also note that completeness is only evaluated on parameters that are
shared between the results file and data quality objectives file for
frequency and completeness. A warning is returned for parameters that do
not match between the files. This warning can be suppressed by setting
`warn = FALSE`.

The quality control tables for frequency show the number of records that
apply to a given check (e.g., Lab Blank, Field Blank, etc.) relative to
the number of "regular" data records (e.g., field samples or measures)
for each parameter. A summary of all frequency checks for each parameter
is provided if `type = "summary"` or a color-coded table showing similar
information as percentages for each parameter is provided if
`type = "percent"`.

Inputs for the results and data quality objectives for accuracy and
frequency and completeness are processed internally with
[`qcMWRcom`](https://massbays-tech.github.io/MassWateR/reference/qcMWRcom.md)
and the same arguments are accepted for this function, in addition to
others listed above.

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

# table as summary
tabMWRfre(res = respth, acc = accpth, frecom = frecompth, type = 'summary')
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


.cl-fd37c8d8{}.cl-fd2e795e{font-family:'DejaVu Sans';font-size:9pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-fd31a6d8{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:0;padding-top:0;padding-left:0;padding-right:0;line-height: 1;background-color:transparent;}.cl-fd31cbea{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cbfe{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cbff{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc08{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc12{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc1c{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc1d{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc1e{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc26{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc27{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc28{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc30{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc31{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc3a{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc3b{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc44{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc45{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc46{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc4e{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc58{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc59{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc62{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc63{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc6c{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc6d{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc6e{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc76{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc77{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc80{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc81{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc8a{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc8b{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc94{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc95{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc9e{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cc9f{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cca0{width:2.072in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31cca8{width:1.119in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31ccb2{width:1.645in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31ccb3{width:2.028in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31ccbc{width:0.916in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-fd31ccc6{width:0.593in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


Type
```

Parameter

Number of Data Records

Number of Dups/Blanks/Spikes

Frequency %

Hit/Miss

Field Duplicates

Ammonia

43

4

9%

MISS

DO

49

11

22%

E.coli

12

2

17%

Nitrate

20

2

10%

pH

49

11

22%

Sp Conductance

49

11

22%

TP

48

5

10%

Water Temp

49

11

22%

Lab Duplicates

Ammonia

43

10

23%

E.coli

12

4

33%

Nitrate

20

10

50%

pH

49

17

35%

Sp Conductance

49

17

35%

TP

48

16

33%

Water Temp

49

17

35%

Field Blanks

Ammonia

43

7

16%

E.coli

12

4

33%

Nitrate

20

7

35%

TP

48

11

23%

Lab Blanks

Ammonia

43

7

16%

E.coli

12

0

0%

MISS

Nitrate

20

5

25%

Sp Conductance

49

21

43%

TP

48

5

10%

Lab Spikes / Instrument Checks

Ammonia

43

9

21%

Nitrate

20

10

50%

pH

49

20

41%

Sp Conductance

49

21

43%

TP

48

15

31%

Water Temp

49

19

39%

\# table as percent tabMWRfre(res = respth, acc = accpth, frecom =
frecompth, type = 'percent') \#\> Running checks on results data... \#\>
Checking column names... OK \#\> Checking all required columns are
present... OK \#\> Checking valid Activity Types... OK \#\> Checking
Activity Start Date formats... OK \#\> Checking depth data present... OK
\#\> Checking for non-numeric values in Activity Depth/Height Measure...
OK \#\> Checking Activity Depth/Height Unit... OK \#\> Checking Activity
Relative Depth Name formats... OK \#\> Checking values in Activity
Depth/Height Measure \> 1 m / 3.3 ft... OK \#\> Checking Characteristic
Name formats... OK \#\> Checking Result Values... OK \#\> Checking for
non-numeric values in Quantitation Limit... OK \#\> Checking QC
Reference Values... OK \#\> Checking for missing entries for Result
Unit... OK \#\> Checking if more than one unit per Characteristic
Name... OK \#\> Checking acceptable units for each entry in
Characteristic Name... OK \#\> \#\> All checks passed! \#\> Running
checks on data quality objectives for accuracy... \#\> Checking column
names... OK \#\> Checking all required columns are present... OK \#\>
Checking column types... OK \#\> Checking no "na" in Value Range... OK
\#\> Checking for text other than \<=, ≤, \<, \>=, ≥, \>, ±, %, AQL,
BQL, log, or all... OK \#\> Checking overlaps in Value Range... OK \#\>
Checking gaps in Value Range... OK \#\> Checking Parameter formats... OK
\#\> Checking for missing entries for unit (uom)... OK \#\> Checking if
more than one unit (uom) per Parameter... OK \#\> Checking acceptable
units (uom) for each entry in Parameter... OK \#\> Checking empty
columns... OK \#\> \#\> All checks passed! \#\> Running checks on data
quality objectives for frequency and completeness... \#\> Checking
column names... OK \#\> Checking all required columns are present... OK
\#\> Checking for non-numeric values... OK \#\> Checking for values
outside of 0 and 100... OK \#\> Checking Parameter formats... OK \#\>
Checking empty columns... OK \#\> \#\> All checks passed!

| Parameter      | Field Duplicate | Lab Duplicate | Field Blank | Lab Blank | Spike/Check Accuracy |
|----------------|-----------------|---------------|-------------|-----------|----------------------|
| Ammonia        | 9%              | 23%           | 16%         | 16%       | 21%                  |
| DO             | 22%             | -             | -           | -         | -                    |
| E.coli         | 17%             | 33%           | 33%         | 0%        | -                    |
| Nitrate        | 10%             | 50%           | 35%         | 25%       | 50%                  |
| Sp Conductance | 22%             | 35%           | -           | 43%       | 43%                  |
| TP             | 10%             | 33%           | 23%         | 10%       | 31%                  |
| Water Temp     | 22%             | 35%           | -           | -         | 39%                  |
| pH             | 22%             | 35%           | -           | -         | 41%                  |

\## \# using data frames \# results data resdat \<-
[readMWRresults](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)(respth)
\#\> Running checks on results data... \#\> Checking column names... OK
\#\> Checking all required columns are present... OK \#\> Checking valid
Activity Types... OK \#\> Checking Activity Start Date formats... OK
\#\> Checking depth data present... OK \#\> Checking for non-numeric
values in Activity Depth/Height Measure... OK \#\> Checking Activity
Depth/Height Unit... OK \#\> Checking Activity Relative Depth Name
formats... OK \#\> Checking values in Activity Depth/Height Measure \> 1
m / 3.3 ft... OK \#\> Checking Characteristic Name formats... OK \#\>
Checking Result Values... OK \#\> Checking for non-numeric values in
Quantitation Limit... OK \#\> Checking QC Reference Values... OK \#\>
Checking for missing entries for Result Unit... OK \#\> Checking if more
than one unit per Characteristic Name... OK \#\> Checking acceptable
units for each entry in Characteristic Name... OK \#\> \#\> All checks
passed! \# accuracy data accdat \<-
[readMWRacc](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)(accpth)
\#\> Running checks on data quality objectives for accuracy... \#\>
Checking column names... OK \#\> Checking all required columns are
present... OK \#\> Checking column types... OK \#\> Checking no "na" in
Value Range... OK \#\> Checking for text other than \<=, ≤, \<, \>=, ≥,
\>, ±, %, AQL, BQL, log, or all... OK \#\> Checking overlaps in Value
Range... OK \#\> Checking gaps in Value Range... OK \#\> Checking
Parameter formats... OK \#\> Checking for missing entries for unit
(uom)... OK \#\> Checking if more than one unit (uom) per Parameter...
OK \#\> Checking acceptable units (uom) for each entry in Parameter...
OK \#\> Checking empty columns... OK \#\> \#\> All checks passed! \#
frequency and completeness data frecomdat \<-
[readMWRfrecom](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)(frecompth)
\#\> Running checks on data quality objectives for frequency and
completeness... \#\> Checking column names... OK \#\> Checking all
required columns are present... OK \#\> Checking for non-numeric
values... OK \#\> Checking for values outside of 0 and 100... OK \#\>
Checking Parameter formats... OK \#\> Checking empty columns... OK \#\>
\#\> All checks passed! \# table as summary tabMWRfre(res = resdat, acc
= accdat, frecom = frecomdat, type = 'summary')

| Type                           | Parameter      | Number of Data Records | Number of Dups/Blanks/Spikes | Frequency % | Hit/Miss |
|--------------------------------|----------------|------------------------|------------------------------|-------------|----------|
| Field Duplicates               |                |                        |                              |             |          |
|                                | Ammonia        | 43                     | 4                            | 9%          | MISS     |
|                                | DO             | 49                     | 11                           | 22%         |          |
|                                | E.coli         | 12                     | 2                            | 17%         |          |
|                                | Nitrate        | 20                     | 2                            | 10%         |          |
|                                | pH             | 49                     | 11                           | 22%         |          |
|                                | Sp Conductance | 49                     | 11                           | 22%         |          |
|                                | TP             | 48                     | 5                            | 10%         |          |
|                                | Water Temp     | 49                     | 11                           | 22%         |          |
| Lab Duplicates                 |                |                        |                              |             |          |
|                                | Ammonia        | 43                     | 10                           | 23%         |          |
|                                | E.coli         | 12                     | 4                            | 33%         |          |
|                                | Nitrate        | 20                     | 10                           | 50%         |          |
|                                | pH             | 49                     | 17                           | 35%         |          |
|                                | Sp Conductance | 49                     | 17                           | 35%         |          |
|                                | TP             | 48                     | 16                           | 33%         |          |
|                                | Water Temp     | 49                     | 17                           | 35%         |          |
| Field Blanks                   |                |                        |                              |             |          |
|                                | Ammonia        | 43                     | 7                            | 16%         |          |
|                                | E.coli         | 12                     | 4                            | 33%         |          |
|                                | Nitrate        | 20                     | 7                            | 35%         |          |
|                                | TP             | 48                     | 11                           | 23%         |          |
| Lab Blanks                     |                |                        |                              |             |          |
|                                | Ammonia        | 43                     | 7                            | 16%         |          |
|                                | E.coli         | 12                     | 0                            | 0%          | MISS     |
|                                | Nitrate        | 20                     | 5                            | 25%         |          |
|                                | Sp Conductance | 49                     | 21                           | 43%         |          |
|                                | TP             | 48                     | 5                            | 10%         |          |
| Lab Spikes / Instrument Checks |                |                        |                              |             |          |
|                                | Ammonia        | 43                     | 9                            | 21%         |          |
|                                | Nitrate        | 20                     | 10                           | 50%         |          |
|                                | pH             | 49                     | 20                           | 41%         |          |
|                                | Sp Conductance | 49                     | 21                           | 43%         |          |
|                                | TP             | 48                     | 15                           | 31%         |          |
|                                | Water Temp     | 49                     | 19                           | 39%         |          |

\# table as percent tabMWRfre(res = resdat, acc = accdat, frecom =
frecomdat, type = 'percent')

| Parameter      | Field Duplicate | Lab Duplicate | Field Blank | Lab Blank | Spike/Check Accuracy |
|----------------|-----------------|---------------|-------------|-----------|----------------------|
| Ammonia        | 9%              | 23%           | 16%         | 16%       | 21%                  |
| DO             | 22%             | -             | -           | -         | -                    |
| E.coli         | 17%             | 33%           | 33%         | 0%        | -                    |
| Nitrate        | 10%             | 50%           | 35%         | 25%       | 50%                  |
| Sp Conductance | 22%             | 35%           | -           | 43%       | 43%                  |
| TP             | 10%             | 33%           | 23%         | 10%       | 31%                  |
| Water Temp     | 22%             | 35%           | -           | -         | 39%                  |
| pH             | 22%             | 35%           | -           | -         | 41%                  |
