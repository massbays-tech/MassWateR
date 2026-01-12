# MassWateR quality control functions

The quality control functions in MassWateR can be used once the required
data are successfully imported into R (see the [data input and checks
vignette](https://massbays-tech.github.io/MassWateR/articles/inputs.html)
for an overview). The required data includes the results data file that
describe the monitoring data, the data quality objective files for
accuracy, frequency, and completeness, and a censored data file
(optional) showing number of missing or censored data by parameter. The
example data files included with the package are imported here to
demonstrate how to use the quality control functions:

``` r
library(MassWateR)

# import results data
respth <- system.file("extdata/ExampleResults.xlsx", package = "MassWateR")
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

# import data quality objectives for accuracy
accpth <- system.file("extdata/ExampleDQOAccuracy.xlsx", package = "MassWateR")
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

# import data quality objectives for frequency and completeness
frecompth <- system.file("extdata/ExampleDQOFrequencyCompleteness.xlsx", package = "MassWateR")
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

# import censored data
censpth <- system.file("extdata/ExampleCensored.xlsx", package = "MassWateR")
censdat <- readMWRcens(censpth)
#> Running checks on censored data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric or empty values in Missed and Censored Records... OK
#>  Checking for negative values in Missed and Censored Records... OK
#>  Checking Parameter Name formats... OK
#> 
#> All checks passed!
```

## Creating the review report

The
[`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
function compiles a review report as a Word document for all quality
control checks included in the MassWateR package. The report shows
several tables, including the data quality objectives files for
accuracy, frequency, and completeness, summary results for all accuracy
checks, summary results for all frequency checks, summary results for
all completeness checks, and individual results for all accuracy checks.
The report uses individual table functions described in the sections
below to return the results, which include
[`tabMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
[`tabMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md),
and
[`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md).

The workflow for using this function is to import the required data
(results, data quality objective files and censored data, as above) and
to fix any errors noted on import prior to creating the review report.
The function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md),
and
[`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`, as explained in
the relevant help files. In the latter case, downstream analyses may not
work if data are formatted incorrectly.

The report can be created as follows by including the required files and
specifying an output directory where the Word document is saved (a
temporary directory is used here). Once the function is done running, a
message indicating success and where the file is located is returned.
The Word file can be further edited by hand as needed.

``` r
qcMWRreview(res = resdat, acc = accdat, frecom = frecomdat, cens = censdat, warn = FALSE, output_dir = tempdir())
#> Report created successfully! File located at /tmp/RtmpSB679Z/qcreview.docx
```

As a convenience, the input files can also be passed to the
[`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
function as a named list using the `fset` argument. This eliminates the
need to individually specify the input arguments.

``` r
# names list of inputs
fsetls <- list(
  res = resdat, 
  acc = accdat, 
  frecom = frecomdat,
  cens = censdat
)

qcMWRreview(fset = fsetls, output_dir = tempdir())
```

Note that the warnings are suppressed above with `warn = FALSE`. By
default, this argument is set to `TRUE` to view the warnings in the R
console after the report is created. The warnings indicate notable
concerns to consider for the input data that may need to be addressed.
Details on these warnings are described in the sections below for each
quality control table.

Optional arguments for
[`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
that can be changed as needed include specifying the file name with
`output_file`, suppressing the raw data summaries at the end of the
report with `rawdata = FALSE`, and changing the table font sizes
(`dqofontsize` for the data quality objectives on the first page,
`tabfontsize` for the remainder). A spreadsheet of the tables in the
Word document can also be created by setting `savesheet = TRUE`. The
spreadsheet is saved in the same directory as the Word document.

## Quality control for accuracy

The quality control checks for accuracy assess several characteristics
of the data in the results file by referencing appropriate values in the
data quality objectives file for accuracy. In short, the accuracy checks
evaluate field blanks, lab blanks, field duplicates, lab duplicates, lab
spikes, and instrument checks. The accuracy checks require results data
(as in `resdat` above) and data quality objectives files for accuracy
(`accdat`) and frequency and completeness (`frecomdat`).

The
[`tabMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)
function is used to create tabular results for the accuracy checks for
each parameter. The function can be used with inputs as paths to the
relevant files or as data frames returned by
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
and `readMWRfrecom`. For the former, the full suite of data checks can
be evaluated with `runkchk = T` (default) or suppressed with
`runchk = F`, as explained in the [data inputs and checks
vignette](https://massbays-tech.github.io/MassWateR/articles/inputs.html).
In the latter case, downstream analyses may not work if data are
formatted incorrectly. Also note that accuracy is only evaluated on
parameters that are shared between the results file and the data quality
objectives accuracy file. A warning is returned if there are parameters
that do not match. The warnings can be suppressed by setting
`warn = FALSE`.

The
[`tabMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)
function can return three types of tables as specified with the `type`
argument: `"individual"`, `"summary"`, or `"percent"`. The individual
tables are specific to each type of accuracy check for each parameter
(e.g., field blanks, lab blanks, etc.). The summary table summarizes all
accuracy checks by the number of checks and how many hit/misses are
returned for each across all parameters. The percent table is similar to
the summary table, but showing only percentages with appropriate
color-coding for hit/misses. The data quality objectives file for
frequency and completeness is also required if `type = "summary"` or
`type = "percent"`.

For `type = "individual"`, the quality control tables for accuracy are
retrieved by specifying the check with the `accchk` argument. The
`accchk` argument can be used to specify one of the following values to
retrieve the relevant tables: `"Field Blanks"`, `"Lab Blanks"`,
`"Field Duplicates"`, `"Lab Duplicates"`, or
`"Lab Spikes / Instrument Checks"`. Below shows how to retrieve each
table using the data frames from above for the results and quality
objectives file for accuracy. The warnings are suppressed with
`warn = FALSE`.

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = "individual", accchk = "Field Blanks", warn = FALSE)
```

| Parameter | Date       | Site | Result    | Threshold   | Hit/Miss |
|-----------|------------|------|-----------|-------------|----------|
| Ammonia   |            |      |           |             |          |
|           | 2022-05-15 |      | BDL       | 0.1 mg/l    |          |
|           | 2022-06-12 |      | BDL       | 0.1 mg/l    |          |
|           | 2022-07-17 |      | BDL       | 0.1 mg/l    |          |
|           | 2022-07-17 |      | BDL       | 0.1 mg/l    |          |
|           | 2022-08-14 |      | BDL       | 0.1 mg/l    |          |
|           | 2022-08-14 |      | BDL       | 0.1 mg/l    |          |
|           | 2022-09-11 |      | BDL       | 0.1 mg/l    |          |
| E.coli    |            |      |           |             |          |
|           | 2022-06-13 |      | BDL       | 1 MPN/100ml |          |
|           | 2022-07-18 |      | BDL       | 1 MPN/100ml |          |
|           | 2022-08-01 |      | BDL       | 1 MPN/100ml |          |
|           | 2022-08-29 |      | BDL       | 1 MPN/100ml |          |
| Nitrate   |            |      |           |             |          |
|           | 2022-05-15 |      | BDL       | 0.05 mg/l   |          |
|           | 2022-06-12 |      | BDL       | 0.05 mg/l   |          |
|           | 2022-06-12 |      | BDL       | 0.05 mg/l   |          |
|           | 2022-07-17 |      | BDL       | 0.05 mg/l   |          |
|           | 2022-07-17 |      | BDL       | 0.05 mg/l   |          |
|           | 2022-08-14 |      | BDL       | 0.05 mg/l   |          |
|           | 2022-09-11 |      | BDL       | 0.05 mg/l   |          |
| TP        |            |      |           |             |          |
|           | 2022-05-15 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-05-15 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-06-12 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-06-12 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-07-17 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-07-17 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-07-17 |      | 0.01 mg/l | 0.01 mg/l   | MISS     |
|           | 2022-08-14 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-08-14 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-09-11 |      | BDL       | 0.01 mg/l   |          |
|           | 2022-09-11 |      | BDL       | 0.01 mg/l   |          |

Field Blanks

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat,type = "individual", accchk = "Lab Blanks", warn = FALSE)
```

| Parameter      | Date       | Sample ID | Result     | Threshold | Hit/Miss |
|----------------|------------|-----------|------------|-----------|----------|
| Ammonia        |            |           |            |           |          |
|                | 2022-05-15 |           | BDL        | 0.1 mg/l  |          |
|                | 2022-06-12 |           | BDL        | 0.1 mg/l  |          |
|                | 2022-07-17 |           | BDL        | 0.1 mg/l  |          |
|                | 2022-07-17 |           | 0.1 mg/l   | 0.1 mg/l  | MISS     |
|                | 2022-08-14 |           | BDL        | 0.1 mg/l  |          |
|                | 2022-08-14 |           | BDL        | 0.1 mg/l  |          |
|                | 2022-09-11 |           | BDL        | 0.1 mg/l  |          |
| Nitrate        |            |           |            |           |          |
|                | 2022-05-15 |           | BDL        | 0.05 mg/l |          |
|                | 2022-06-12 |           | BDL        | 0.05 mg/l |          |
|                | 2022-07-17 |           | BDL        | 0.05 mg/l |          |
|                | 2022-08-14 |           | BDL        | 0.05 mg/l |          |
|                | 2022-09-11 |           | BDL        | 0.05 mg/l |          |
| Sp Conductance |            |           |            |           |          |
|                | 2022-05-15 |           | 7 uS/cm    | 50 uS/cm  |          |
|                | 2022-05-15 |           | 7.4 uS/cm  | 50 uS/cm  |          |
|                | 2022-05-15 |           | 7.7 uS/cm  | 50 uS/cm  |          |
|                | 2022-05-15 |           | 8.6 uS/cm  | 50 uS/cm  |          |
|                | 2022-06-12 |           | 8.9 uS/cm  | 50 uS/cm  |          |
|                | 2022-06-12 |           | 9 uS/cm    | 50 uS/cm  |          |
|                | 2022-06-12 |           | 10.1 uS/cm | 50 uS/cm  |          |
|                | 2022-06-12 |           | 10.9 uS/cm | 50 uS/cm  |          |
|                | 2022-06-12 |           | 13 uS/cm   | 50 uS/cm  |          |
|                | 2022-07-17 |           | 4 uS/cm    | 50 uS/cm  |          |
|                | 2022-07-17 |           | 4 uS/cm    | 50 uS/cm  |          |
|                | 2022-07-17 |           | 5.8 uS/cm  | 50 uS/cm  |          |
|                | 2022-07-17 |           | 6 uS/cm    | 50 uS/cm  |          |
|                | 2022-08-14 |           | 2.5 uS/cm  | 50 uS/cm  |          |
|                | 2022-08-14 |           | 3 uS/cm    | 50 uS/cm  |          |
|                | 2022-08-14 |           | 80 uS/cm   | 50 uS/cm  | MISS     |
|                | 2022-08-14 |           | 3.9 uS/cm  | 50 uS/cm  |          |
|                | 2022-09-11 |           | 4 uS/cm    | 50 uS/cm  |          |
|                | 2022-09-11 |           | 4.1 uS/cm  | 50 uS/cm  |          |
|                | 2022-09-11 |           | 4.7 uS/cm  | 50 uS/cm  |          |
|                | 2022-09-11 |           | 5.9 uS/cm  | 50 uS/cm  |          |
| TP             |            |           |            |           |          |
|                | 2022-05-15 |           | BDL        | 0.01 mg/l |          |
|                | 2022-06-12 |           | BDL        | 0.01 mg/l |          |
|                | 2022-07-17 |           | BDL        | 0.01 mg/l |          |
|                | 2022-08-14 |           | BDL        | 0.01 mg/l |          |
|                | 2022-09-11 |           | BDL        | 0.01 mg/l |          |

Lab Blanks

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = "individual", accchk = "Field Duplicates", warn = FALSE)
```

| Parameter      | Date       | Site    | Initial Result | Dup. Result   | Diff./RPD | Hit/Miss |
|----------------|------------|---------|----------------|---------------|-----------|----------|
| Ammonia        |            |         |                |               |           |          |
|                | 2022-05-15 | ABT-312 | BDL            | BDL           | 0% RPD    |          |
|                | 2022-05-15 | DAN-013 | BDL            | BDL           | 0% RPD    |          |
|                | 2022-06-12 | ABT-301 | BDL            | 0.2 mg/l      | 67% RPD   | MISS     |
|                | 2022-09-11 | ABT-301 | BDL            | BDL           | 0% RPD    |          |
| DO             |            |         |                |               |           |          |
|                | 2022-05-15 | ABT-026 | 7.58 mg/l      | 7.6 mg/l      | 0% RPD    |          |
|                | 2022-05-15 | ELZ-004 | 5.81 mg/l      | 5.94 mg/l     | 2% RPD    |          |
|                | 2022-05-15 | NSH-002 | 8.32 mg/l      | 8.33 mg/l     | 0% RPD    |          |
|                | 2022-06-12 | ABT-062 | 8.56 mg/l      | 8.56 mg/l     | 0% RPD    |          |
|                | 2022-06-12 | ABT-237 | 7.81 mg/l      | 8.1 mg/l      | 4% RPD    |          |
|                | 2022-06-12 | HOP-011 | 7.8 mg/l       | 7.79 mg/l     | 0% RPD    |          |
|                | 2022-07-17 | ABT-062 | 7.59 mg/l      | 7.59 mg/l     | 0% RPD    |          |
|                | 2022-07-17 | ABT-237 | 5.92 mg/l      | 5.92 mg/l     | 0% RPD    |          |
|                | 2022-08-14 | ABT-237 | 5.89 mg/l      | 5.9 mg/l      | 0% RPD    |          |
|                | 2022-09-11 | ABT-026 | 7.7 mg/l       | 7.7 mg/l      | 0% RPD    |          |
|                | 2022-09-11 | HOP-011 | 8.36 mg/l      | 8.35 mg/l     | 0% RPD    |          |
| E.coli         |            |         |                |               |           |          |
|                | 2022-07-18 | ABT-162 | 276 MPN/100ml  | 276 MPN/100ml | 0% logRPD |          |
|                | 2022-08-15 | ABT-077 | 231 MPN/100ml  | 276 MPN/100ml | 3% logRPD |          |
| Nitrate        |            |         |                |               |           |          |
|                | 2022-06-12 | ABT-301 | 3.65 mg/l      | 3.35 mg/l     | 9% RPD    |          |
|                | 2022-07-17 | ABT-077 | 0.72 mg/l      | 0.73 mg/l     | 1% RPD    |          |
| pH             |            |         |                |               |           |          |
|                | 2022-05-15 | ABT-026 | 7.19 s.u.      | 7.2 s.u.      | 0.01 s.u. |          |
|                | 2022-05-15 | ELZ-004 | 6.95 s.u.      | 7.08 s.u.     | 0.13 s.u. |          |
|                | 2022-05-15 | NSH-002 | 7.23 s.u.      | 7.25 s.u.     | 0.02 s.u. |          |
|                | 2022-06-12 | ABT-062 | 7.26 s.u.      | 7.26 s.u.     | 0 s.u.    |          |
|                | 2022-06-12 | ABT-237 | 7.1 s.u.       | 7.11 s.u.     | 0.01 s.u. |          |
|                | 2022-06-12 | HOP-011 | 6.86 s.u.      | 6.82 s.u.     | 0.04 s.u. |          |
|                | 2022-07-17 | ABT-062 | 8.02 s.u.      | 8.01 s.u.     | 0.01 s.u. |          |
|                | 2022-07-17 | ABT-237 | 7.28 s.u.      | 7.28 s.u.     | 0 s.u.    |          |
|                | 2022-08-14 | ABT-237 | 7.28 s.u.      | 7.28 s.u.     | 0 s.u.    |          |
|                | 2022-09-11 | ABT-026 | 7.13 s.u.      | 7.14 s.u.     | 0.01 s.u. |          |
|                | 2022-09-11 | HOP-011 | 6.92 s.u.      | 6.84 s.u.     | 0.08 s.u. |          |
| Sp Conductance |            |         |                |               |           |          |
|                | 2022-05-15 | ABT-026 | 585 uS/cm      | 586 uS/cm     | 0% RPD    |          |
|                | 2022-05-15 | ELZ-004 | 375 uS/cm      | 375 uS/cm     | 0% RPD    |          |
|                | 2022-05-15 | NSH-002 | 524 uS/cm      | 525 uS/cm     | 0% RPD    |          |
|                | 2022-06-12 | ABT-062 | 579 uS/cm      | 579 uS/cm     | 0% RPD    |          |
|                | 2022-06-12 | ABT-237 | 740 uS/cm      | 740 uS/cm     | 0% RPD    |          |
|                | 2022-06-12 | HOP-011 | 731 uS/cm      | 731 uS/cm     | 0% RPD    |          |
|                | 2022-07-17 | ABT-062 | 831 uS/cm      | 831 uS/cm     | 0% RPD    |          |
|                | 2022-07-17 | ABT-237 | 1222 uS/cm     | 1221 uS/cm    | 0% RPD    |          |
|                | 2022-08-14 | ABT-237 | 1497 uS/cm     | 1489 uS/cm    | 1% RPD    |          |
|                | 2022-09-11 | ABT-026 | 738 uS/cm      | 675 uS/cm     | 9% RPD    |          |
|                | 2022-09-11 | HOP-011 | 865 uS/cm      | 865 uS/cm     | 0% RPD    |          |
| TP             |            |         |                |               |           |          |
|                | 2022-05-15 | ABT-312 | 0.03 mg/l      | 0.03 mg/l     | 0 mg/l    |          |
|                | 2022-05-15 | DAN-013 | 0.04 mg/l      | 0.04 mg/l     | 0 mg/l    |          |
|                | 2022-06-12 | ABT-301 | 0.03 mg/l      | 0.03 mg/l     | 0 mg/l    |          |
|                | 2022-07-17 | ABT-077 | 0.04 mg/l      | 0.02 mg/l     | 0.02 mg/l | MISS     |
|                | 2022-09-11 | ABT-301 | 0.03 mg/l      | 0.03 mg/l     | 0 mg/l    |          |
| Water Temp     |            |         |                |               |           |          |
|                | 2022-05-15 | ABT-026 | 22.4 deg C     | 22.4 deg C    | 0 deg C   |          |
|                | 2022-05-15 | ELZ-004 | 22.2 deg C     | 22.2 deg C    | 0 deg C   |          |
|                | 2022-05-15 | NSH-002 | 23.3 deg C     | 23.3 deg C    | 0 deg C   |          |
|                | 2022-06-12 | ABT-062 | 21.1 deg C     | 21.1 deg C    | 0 deg C   |          |
|                | 2022-06-12 | ABT-237 | 18.7 deg C     | 18.7 deg C    | 0 deg C   |          |
|                | 2022-06-12 | HOP-011 | 18.4 deg C     | 18.4 deg C    | 0 deg C   |          |
|                | 2022-07-17 | ABT-062 | 25.6 deg C     | 25.6 deg C    | 0 deg C   |          |
|                | 2022-07-17 | ABT-237 | 20.8 deg C     | 20.8 deg C    | 0 deg C   |          |
|                | 2022-08-14 | ABT-237 | 18.8 deg C     | 18.8 deg C    | 0 deg C   |          |
|                | 2022-09-11 | ABT-026 | 20.5 deg C     | 20.5 deg C    | 0 deg C   |          |
|                | 2022-09-11 | HOP-011 | 19.3 deg C     | 19.3 deg C    | 0 deg C   |          |

Field Duplicates

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = "individual", accchk = "Lab Duplicates", warn = FALSE)
```

| Parameter      | Date       | Sample ID | Initial Result  | Dup. Result     | Diff./RPD  | Hit/Miss |
|----------------|------------|-----------|-----------------|-----------------|------------|----------|
| Ammonia        |            |           |                 |                 |            |          |
|                | 2022-05-15 |           | 0.21 mg/l       | 0.21 mg/l       | 0% RPD     |          |
|                | 2022-05-15 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-06-12 |           | 0.1 mg/l        | 0.1 mg/l        | 0% RPD     |          |
|                | 2022-06-12 |           | 0.19 mg/l       | 0.19 mg/l       | 0% RPD     |          |
|                | 2022-07-17 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-07-17 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-08-14 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-08-14 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-09-11 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-09-11 |           | BDL             | BDL             | 0% RPD     |          |
| E.coli         |            |           |                 |                 |            |          |
|                | 2022-06-13 |           | 547.5 MPN/100ml | 579.4 MPN/100ml | 1% logRPD  |          |
|                | 2022-07-18 |           | 88 MPN/100ml    | 167 MPN/100ml   | 13% logRPD |          |
|                | 2022-08-01 |           | 114.5 MPN/100ml | 160.7 MPN/100ml | 7% logRPD  |          |
|                | 2022-08-29 |           | 42.8 MPN/100ml  | 40.4 MPN/100ml  | 2% logRPD  |          |
| Nitrate        |            |           |                 |                 |            |          |
|                | 2022-05-15 |           | 0.37 mg/l       | 0.38 mg/l       | 3% RPD     |          |
|                | 2022-06-12 |           | 0.17 mg/l       | 0.17 mg/l       | 0% RPD     |          |
|                | 2022-06-12 |           | 3.65 mg/l       | 3.63 mg/l       | 1% RPD     |          |
|                | 2022-06-12 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-07-17 |           | 1.29 mg/l       | 1.29 mg/l       | 0% RPD     |          |
|                | 2022-07-17 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-07-17 |           | BDL             | BDL             | 0% RPD     |          |
|                | 2022-08-14 |           | 2.69 mg/l       | 2.69 mg/l       | 0% RPD     |          |
|                | 2022-08-14 |           | 5.22 mg/l       | 5.24 mg/l       | 0% RPD     |          |
|                | 2022-09-11 |           | 1.51 mg/l       | 1.5 mg/l        | 1% RPD     |          |
| pH             |            |           |                 |                 |            |          |
|                | 2022-05-15 |           | 7.11 s.u.       | 7.09 s.u.       | 0.02 s.u.  |          |
|                | 2022-05-15 |           | 7.18 s.u.       | 7.09 s.u.       | 0.09 s.u.  |          |
|                | 2022-05-15 |           | 7.19 s.u.       | 7.09 s.u.       | 0.1 s.u.   |          |
|                | 2022-06-12 |           | 7.12 s.u.       | 7.19 s.u.       | 0.07 s.u.  |          |
|                | 2022-06-12 |           | 7.13 s.u.       | 7.19 s.u.       | 0.06 s.u.  |          |
|                | 2022-06-12 |           | 7.21 s.u.       | 7.19 s.u.       | 0.02 s.u.  |          |
|                | 2022-06-12 |           | 7.27 s.u.       | 7.19 s.u.       | 0.08 s.u.  |          |
|                | 2022-07-17 |           | 7.48 s.u.       | 7.37 s.u.       | 0.11 s.u.  |          |
|                | 2022-07-17 |           | 7.54 s.u.       | 7.37 s.u.       | 0.17 s.u.  |          |
|                | 2022-07-17 |           | 7.54 s.u.       | 7.37 s.u.       | 0.17 s.u.  |          |
|                | 2022-07-17 |           | 7.54 s.u.       | 7.37 s.u.       | 0.17 s.u.  |          |
|                | 2022-08-14 |           | 7.64 s.u.       | 7.32 s.u.       | 0.32 s.u.  |          |
|                | 2022-08-14 |           | 7.65 s.u.       | 7.32 s.u.       | 0.33 s.u.  |          |
|                | 2022-08-14 |           | 7.68 s.u.       | 7.32 s.u.       | 0.36 s.u.  |          |
|                | 2022-09-11 |           | 7.07 s.u.       | 6.74 s.u.       | 0.33 s.u.  |          |
|                | 2022-09-11 |           | 7.16 s.u.       | 6.74 s.u.       | 0.42 s.u.  |          |
|                | 2022-09-11 |           | 7.34 s.u.       | 6.74 s.u.       | 0.6 s.u.   | MISS     |
| Sp Conductance |            |           |                 |                 |            |          |
|                | 2022-05-15 |           | 599 uS/cm       | 609 uS/cm       | 2% RPD     |          |
|                | 2022-05-15 |           | 605 uS/cm       | 609 uS/cm       | 1% RPD     |          |
|                | 2022-05-15 |           | 606 uS/cm       | 609 uS/cm       | 0% RPD     |          |
|                | 2022-06-12 |           | 600 uS/cm       | 608 uS/cm       | 1% RPD     |          |
|                | 2022-06-12 |           | 602 uS/cm       | 608 uS/cm       | 1% RPD     |          |
|                | 2022-06-12 |           | 606 uS/cm       | 608 uS/cm       | 0% RPD     |          |
|                | 2022-07-17 |           | 793 uS/cm       | 802 uS/cm       | 1% RPD     |          |
|                | 2022-07-17 |           | 900 uS/cm       | 802 uS/cm       | 12% RPD    |          |
|                | 2022-07-17 |           | 796 uS/cm       | 802 uS/cm       | 1% RPD     |          |
|                | 2022-07-17 |           | 801 uS/cm       | 802 uS/cm       | 0% RPD     |          |
|                | 2022-08-14 |           | 1062 uS/cm      | 1066 uS/cm      | 0% RPD     |          |
|                | 2022-08-14 |           | 1062 uS/cm      | 1066 uS/cm      | 0% RPD     |          |
|                | 2022-08-14 |           | 1063 uS/cm      | 1066 uS/cm      | 0% RPD     |          |
|                | 2022-08-14 |           | 1065 uS/cm      | 1066 uS/cm      | 0% RPD     |          |
|                | 2022-09-11 |           | 761 uS/cm       | 766 uS/cm       | 1% RPD     |          |
|                | 2022-09-11 |           | 765 uS/cm       | 766 uS/cm       | 0% RPD     |          |
|                | 2022-09-11 |           | 774 uS/cm       | 766 uS/cm       | 1% RPD     |          |
| TP             |            |           |                 |                 |            |          |
|                | 2022-05-15 |           | 0.01 mg/l       | 0.01 mg/l       | 0 mg/l     |          |
|                | 2022-05-15 |           | 0.03 mg/l       | 0.02 mg/l       | 0.01 mg/l  |          |
|                | 2022-05-15 |           | 0.06 mg/l       | 0.06 mg/l       | 0% RPD     |          |
|                | 2022-06-12 |           | 0.04 mg/l       | 0.04 mg/l       | 0 mg/l     |          |
|                | 2022-06-12 |           | 0.04 mg/l       | 0.04 mg/l       | 0 mg/l     |          |
|                | 2022-06-12 |           | 0.06 mg/l       | 0.06 mg/l       | 0% RPD     |          |
|                | 2022-06-12 |           | BDL             | BDL             | 0 mg/l     |          |
|                | 2022-07-17 |           | 0.04 mg/l       | 0.04 mg/l       | 0 mg/l     |          |
|                | 2022-07-17 |           | 0.05 mg/l       | 0.05 mg/l       | 0% RPD     |          |
|                | 2022-07-17 |           | BDL             | BDL             | 0 mg/l     |          |
|                | 2022-08-14 |           | 0.03 mg/l       | 0.03 mg/l       | 0 mg/l     |          |
|                | 2022-08-14 |           | 0.05 mg/l       | 0.05 mg/l       | 0% RPD     |          |
|                | 2022-08-14 |           | 0.09 mg/l       | 0.09 mg/l       | 0% RPD     |          |
|                | 2022-09-11 |           | 0.04 mg/l       | 0.04 mg/l       | 0 mg/l     |          |
|                | 2022-09-11 |           | 0.04 mg/l       | 0.04 mg/l       | 0 mg/l     |          |
|                | 2022-09-11 |           | 0.05 mg/l       | 0.05 mg/l       | 0% RPD     |          |
| Water Temp     |            |           |                 |                 |            |          |
|                | 2022-05-15 |           | 21.7 deg C      | 21.8 deg C      | 0.1 deg C  |          |
|                | 2022-05-15 |           | 21.8 deg C      | 21.8 deg C      | 0 deg C    |          |
|                | 2022-05-15 |           | 21.8 deg C      | 21.8 deg C      | 0 deg C    |          |
|                | 2022-06-12 |           | 20.2 deg C      | 20.2 deg C      | 0 deg C    |          |
|                | 2022-06-12 |           | 20.2 deg C      | 20.2 deg C      | 0 deg C    |          |
|                | 2022-06-12 |           | 20.3 deg C      | 20.2 deg C      | 0.1 deg C  |          |
|                | 2022-06-12 |           | 20.3 deg C      | 20.2 deg C      | 0.1 deg C  |          |
|                | 2022-07-17 |           | 23 deg C        | 22.9 deg C      | 0.1 deg C  |          |
|                | 2022-07-17 |           | 23 deg C        | 22.9 deg C      | 0.1 deg C  |          |
|                | 2022-07-17 |           | 23.1 deg C      | 22.9 deg C      | 0.2 deg C  |          |
|                | 2022-08-14 |           | 20.8 deg C      | 20.7 deg C      | 0.1 deg C  |          |
|                | 2022-08-14 |           | 20.8 deg C      | 20.7 deg C      | 0.1 deg C  |          |
|                | 2022-08-14 |           | 20.9 deg C      | 20.7 deg C      | 0.2 deg C  |          |
|                | 2022-08-14 |           | 20.9 deg C      | 20.7 deg C      | 0.2 deg C  |          |
|                | 2022-09-11 |           | 20.6 deg C      | 20.5 deg C      | 0.1 deg C  |          |
|                | 2022-09-11 |           | 20.7 deg C      | 20.5 deg C      | 0.2 deg C  |          |
|                | 2022-09-11 |           | 20.7 deg C      | 20.5 deg C      | 0.2 deg C  |          |

Lab Duplicates

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = "individual", accchk = "Lab Spikes / Instrument Checks", warn = FALSE)
```

| Parameter      | Date       | Sample ID | Spike/Standard | Result         | Diff./Accuracy | Hit/Miss |
|----------------|------------|-----------|----------------|----------------|----------------|----------|
| Ammonia        |            |           |                |                |                |          |
|                | 2022-05-15 |           | 100 % recovery | 86 % recovery  | 86%            |          |
|                | 2022-06-12 |           | 100 % recovery | 94 % recovery  | 94%            |          |
|                | 2022-06-12 |           | 100 % recovery | 106 % recovery | 106%           |          |
|                | 2022-07-17 |           | 100 % recovery | 92 % recovery  | 92%            |          |
|                | 2022-07-17 |           | 100 % recovery | 108 % recovery | 108%           |          |
|                | 2022-08-14 |           | 100 % recovery | 96 % recovery  | 96%            |          |
|                | 2022-08-14 |           | 100 % recovery | 102 % recovery | 102%           |          |
|                | 2022-09-11 |           | 100 % recovery | 88 % recovery  | 88%            |          |
|                | 2022-09-11 |           | 100 % recovery | 89 % recovery  | 89%            |          |
| Nitrate        |            |           |                |                |                |          |
|                | 2022-05-15 |           | 100 % recovery | 99 % recovery  | 99%            |          |
|                | 2022-06-12 |           | 100 % recovery | 95 % recovery  | 95%            |          |
|                | 2022-06-12 |           | 100 % recovery | 97 % recovery  | 97%            |          |
|                | 2022-06-12 |           | 100 % recovery | 105 % recovery | 105%           |          |
|                | 2022-07-17 |           | 100 % recovery | 99 % recovery  | 99%            |          |
|                | 2022-07-17 |           | 100 % recovery | 101 % recovery | 101%           |          |
|                | 2022-07-17 |           | 100 % recovery | 125 % recovery | 125%           | MISS     |
|                | 2022-08-14 |           | 100 % recovery | 103 % recovery | 103%           |          |
|                | 2022-08-14 |           | 100 % recovery | 109 % recovery | 109%           |          |
|                | 2022-09-11 |           | 100 % recovery | 101 % recovery | 101%           |          |
| pH             |            |           |                |                |                |          |
|                | 2022-05-15 |           | 7.02 s.u.      | 7 s.u.         | -0.02 s.u.     |          |
|                | 2022-05-15 |           | 7.02 s.u.      | 7.03 s.u.      | +0.01 s.u.     |          |
|                | 2022-05-15 |           | 7.02 s.u.      | 7.09 s.u.      | +0.07 s.u.     |          |
|                | 2022-05-15 |           | 7.02 s.u.      | 7.11 s.u.      | +0.09 s.u.     |          |
|                | 2022-06-12 |           | 7 s.u.         | 7.01 s.u.      | +0.01 s.u.     |          |
|                | 2022-06-12 |           | 7 s.u.         | 7.05 s.u.      | +0.05 s.u.     |          |
|                | 2022-06-12 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
|                | 2022-06-12 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
|                | 2022-06-12 |           | 7 s.u.         | 7.07 s.u.      | +0.07 s.u.     |          |
|                | 2022-07-17 |           | 7 s.u.         | 7.05 s.u.      | +0.05 s.u.     |          |
|                | 2022-07-17 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
|                | 2022-07-17 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
|                | 2022-07-17 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
|                | 2022-07-17 |           | 7 s.u.         | 7.4 s.u.       | +0.4 s.u.      | MISS     |
|                | 2022-08-14 |           | 7 s.u.         | 6.99 s.u.      | -0.01 s.u.     |          |
|                | 2022-08-14 |           | 7 s.u.         | 7.07 s.u.      | +0.07 s.u.     |          |
|                | 2022-08-14 |           | 7 s.u.         | 7.09 s.u.      | +0.09 s.u.     |          |
|                | 2022-09-11 |           | 7 s.u.         | 7.01 s.u.      | +0.01 s.u.     |          |
|                | 2022-09-11 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
|                | 2022-09-11 |           | 7 s.u.         | 7.06 s.u.      | +0.06 s.u.     |          |
| Sp Conductance |            |           |                |                |                |          |
|                | 2022-05-15 |           | 1000 uS/cm     | 975 uS/cm      | -25 uS/cm      |          |
|                | 2022-05-15 |           | 1000 uS/cm     | 977 uS/cm      | -23 uS/cm      |          |
|                | 2022-05-15 |           | 1000 uS/cm     | 985 uS/cm      | -15 uS/cm      |          |
|                | 2022-05-15 |           | 1000 uS/cm     | 991 uS/cm      | -9 uS/cm       |          |
|                | 2022-06-12 |           | 1000 uS/cm     | 978 uS/cm      | -22 uS/cm      |          |
|                | 2022-06-12 |           | 1000 uS/cm     | 979 uS/cm      | -21 uS/cm      |          |
|                | 2022-06-12 |           | 1000 uS/cm     | 979 uS/cm      | -21 uS/cm      |          |
|                | 2022-06-12 |           | 1000 uS/cm     | 983 uS/cm      | -17 uS/cm      |          |
|                | 2022-06-12 |           | 1000 uS/cm     | 987 uS/cm      | -13 uS/cm      |          |
|                | 2022-07-17 |           | 1000 uS/cm     | 984 uS/cm      | -16 uS/cm      |          |
|                | 2022-07-17 |           | 1000 uS/cm     | 988 uS/cm      | -12 uS/cm      |          |
|                | 2022-07-17 |           | 1000 uS/cm     | 997 uS/cm      | -3 uS/cm       |          |
|                | 2022-08-14 |           | 1000 uS/cm     | 991 uS/cm      | -9 uS/cm       |          |
|                | 2022-08-14 |           | 1000 uS/cm     | 991 uS/cm      | -9 uS/cm       |          |
|                | 2022-08-14 |           | 1000 uS/cm     | 992 uS/cm      | -8 uS/cm       |          |
|                | 2022-08-14 |           | 1000 uS/cm     | 992 uS/cm      | -8 uS/cm       |          |
|                | 2022-08-14 |           | 1000 uS/cm     | 996 uS/cm      | -4 uS/cm       |          |
|                | 2022-09-11 |           | 1000 uS/cm     | 986 uS/cm      | -14 uS/cm      |          |
|                | 2022-09-11 |           | 1000 uS/cm     | 989 uS/cm      | -11 uS/cm      |          |
|                | 2022-09-11 |           | 1000 uS/cm     | 990 uS/cm      | -10 uS/cm      |          |
|                | 2022-09-11 |           | 1000 uS/cm     | 993 uS/cm      | -7 uS/cm       |          |
| TP             |            |           |                |                |                |          |
|                | 2022-05-15 |           | 100 % recovery | 100 % recovery | 100%           |          |
|                | 2022-05-15 |           | 100 % recovery | 101 % recovery | 101%           |          |
|                | 2022-05-15 |           | 100 % recovery | 103 % recovery | 103%           |          |
|                | 2022-06-12 |           | 100 % recovery | 100 % recovery | 100%           |          |
|                | 2022-06-12 |           | 100 % recovery | 104 % recovery | 104%           |          |
|                | 2022-06-12 |           | 100 % recovery | 104 % recovery | 104%           |          |
|                | 2022-07-17 |           | 100 % recovery | 105 % recovery | 105%           |          |
|                | 2022-07-17 |           | 100 % recovery | 105 % recovery | 105%           |          |
|                | 2022-07-17 |           | 100 % recovery | 110 % recovery | 110%           |          |
|                | 2022-08-14 |           | 100 % recovery | 99 % recovery  | 99%            |          |
|                | 2022-08-14 |           | 100 % recovery | 99 % recovery  | 99%            |          |
|                | 2022-08-14 |           | 100 % recovery | 101 % recovery | 101%           |          |
|                | 2022-09-11 |           | 100 % recovery | 97 % recovery  | 97%            |          |
|                | 2022-09-11 |           | 100 % recovery | 99 % recovery  | 99%            |          |
|                | 2022-09-11 |           | 100 % recovery | 99 % recovery  | 99%            |          |
| Water Temp     |            |           |                |                |                |          |
|                | 2022-05-15 |           | 21.8 deg C     | 21.8 deg C     | +0 deg C       |          |
|                | 2022-05-15 |           | 21.8 deg C     | 21.8 deg C     | +0 deg C       |          |
|                | 2022-05-15 |           | 21.8 deg C     | 21.9 deg C     | +0.1 deg C     |          |
|                | 2022-05-15 |           | 21.8 deg C     | 21.9 deg C     | +0.1 deg C     |          |
|                | 2022-06-12 |           | 22.5 deg C     | 22.6 deg C     | +0.1 deg C     |          |
|                | 2022-06-12 |           | 22.5 deg C     | 22.6 deg C     | +0.1 deg C     |          |
|                | 2022-06-12 |           | 22.5 deg C     | 22.7 deg C     | +0.2 deg C     |          |
|                | 2022-07-17 |           | 22.7 deg C     | 22.6 deg C     | -0.1 deg C     |          |
|                | 2022-07-17 |           | 22.7 deg C     | 22.7 deg C     | +0 deg C       |          |
|                | 2022-07-17 |           | 22.7 deg C     | 22.7 deg C     | +0 deg C       |          |
|                | 2022-07-17 |           | 22.7 deg C     | 25 deg C       | +2.3 deg C     | MISS     |
|                | 2022-07-17 |           | 22.7 deg C     | 22.9 deg C     | +0.2 deg C     |          |
|                | 2022-08-14 |           | 23.1 deg C     | 23.1 deg C     | +0 deg C       |          |
|                | 2022-08-14 |           | 23.1 deg C     | 23.4 deg C     | +0.3 deg C     |          |
|                | 2022-08-14 |           | 23.1 deg C     | 23.4 deg C     | +0.3 deg C     |          |
|                | 2022-09-11 |           | 22.8 deg C     | 22.8 deg C     | +0 deg C       |          |
|                | 2022-09-11 |           | 22.8 deg C     | 22.8 deg C     | +0 deg C       |          |
|                | 2022-09-11 |           | 22.8 deg C     | 22.9 deg C     | +0.1 deg C     |          |
|                | 2022-09-11 |           | 22.8 deg C     | 23 deg C       | +0.2 deg C     |          |

Lab Spikes / Instrument Checks

For `type = "summary"`, the function summarizes all accuracy checks by
counting the number of quality control checks, number of misses, and
percent acceptance for each parameter. All accuracy checks are used and
the `accchk` argument does not apply.

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = "summary", warn = FALSE)
```

| Type                           | Parameter      | Number of QC Checks | Number of Misses | % Acceptance |
|--------------------------------|----------------|---------------------|------------------|--------------|
| Field Duplicates               |                |                     |                  |              |
|                                | Ammonia        | 4                   | 1                | 75 %         |
|                                | DO             | 11                  | 0                | 100 %        |
|                                | E.coli         | 2                   | 0                | 100 %        |
|                                | Nitrate        | 2                   | 0                | 100 %        |
|                                | pH             | 11                  | 0                | 100 %        |
|                                | Sp Conductance | 11                  | 0                | 100 %        |
|                                | TP             | 5                   | 1                | 80 %         |
|                                | Water Temp     | 11                  | 0                | 100 %        |
| Lab Duplicates                 |                |                     |                  |              |
|                                | Ammonia        | 10                  | 0                | 100 %        |
|                                | E.coli         | 4                   | 0                | 100 %        |
|                                | Nitrate        | 10                  | 0                | 100 %        |
|                                | pH             | 17                  | 1                | 94 %         |
|                                | Sp Conductance | 17                  | 0                | 100 %        |
|                                | TP             | 16                  | 0                | 100 %        |
|                                | Water Temp     | 17                  | 0                | 100 %        |
| Field Blanks                   |                |                     |                  |              |
|                                | Ammonia        | 7                   | 0                | 100 %        |
|                                | E.coli         | 4                   | 0                | 100 %        |
|                                | Nitrate        | 7                   | 0                | 100 %        |
|                                | TP             | 11                  | 1                | 91 %         |
| Lab Blanks                     |                |                     |                  |              |
|                                | Ammonia        | 7                   | 1                | 86 %         |
|                                | E.coli         | 0                   | -                | -            |
|                                | Nitrate        | 5                   | 0                | 100 %        |
|                                | Sp Conductance | 21                  | 1                | 95 %         |
|                                | TP             | 5                   | 0                | 100 %        |
| Lab Spikes / Instrument Checks |                |                     |                  |              |
|                                | Ammonia        | 9                   | 0                | 100 %        |
|                                | Nitrate        | 10                  | 1                | 90 %         |
|                                | pH             | 20                  | 1                | 95 %         |
|                                | Sp Conductance | 21                  | 0                | 100 %        |
|                                | TP             | 15                  | 0                | 100 %        |
|                                | Water Temp     | 19                  | 1                | 95 %         |

For `type = "percent"`, the function returns a similar table as for the
summary option, except only the percentage of checks that pass for each
parameter are shown in wide format. Cells are color-coded based on the
percentage of checks that have passed using the percent thresholds from
the `% Completeness` column of the data quality objectives file for
frequency and completeness. Parameters without an entry for
`% Completeness` are not color-coded and an appropriate warning is
returned. All accuracy checks are used and the `accchk` argument does
not apply.

``` r
tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = "percent", warn = FALSE)
```

| Parameter      | Field Duplicate | Lab Duplicate | Field Blank | Lab Blank | Spike/Check Accuracy |
|----------------|-----------------|---------------|-------------|-----------|----------------------|
| Ammonia        | 75%             | 100%          | 100%        | 86%       | 100%                 |
| DO             | 100%            | -             | -           | -         | -                    |
| E.coli         | 100%            | 100%          | 100%        | -         | -                    |
| Nitrate        | 100%            | 100%          | 100%        | 100%      | 90%                  |
| pH             | 100%            | 94%           | -           | -         | 95%                  |
| Sp Conductance | 100%            | 100%          | -           | 95%       | 100%                 |
| TP             | 80%             | 100%          | 91%         | 100%      | 100%                 |
| Water Temp     | 100%            | 100%          | -           | -         | 95%                  |

The
[`tabMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)
function uses the
[`qcMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md)
function internally to create the table. This function creates the raw
summaries of accuracy from the input data. Typically,
[`qcMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md)
is not used by itself, but it is explained here to demonstrate how the
raw summaries can be obtained.

Below, the
[`qcMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md)
function is executed with the data frames for the results and quality
objectives file for accuracy. As with `tabMWRacc`, the `accchk` argument
can be used to return one to all of the checks. The results are returned
as a list, with each element of the list corresponding to a specific
accuracy check. Here, the lab duplicate checks are returned. The
warnings are also suppressed.

``` r
qcMWRacc(res = resdat, acc = accdat, frecom = frecomdat, accchk = "Lab Duplicates", warn = FALSE)
#> $`Lab Duplicates`
#> # A tibble: 91 × 7
#>    Parameter Date                `Sample ID` `Initial Result` `Dup. Result`
#>    <chr>     <dttm>              <chr>       <chr>            <chr>        
#>  1 Ammonia   2022-05-15 00:00:00 NA          0.21 mg/l        0.21 mg/l    
#>  2 Ammonia   2022-05-15 00:00:00 NA          BDL              BDL          
#>  3 Ammonia   2022-06-12 00:00:00 NA          0.1 mg/l         0.1 mg/l     
#>  4 Ammonia   2022-06-12 00:00:00 NA          0.19 mg/l        0.19 mg/l    
#>  5 Ammonia   2022-07-17 00:00:00 NA          BDL              BDL          
#>  6 Ammonia   2022-07-17 00:00:00 NA          BDL              BDL          
#>  7 Ammonia   2022-08-14 00:00:00 NA          BDL              BDL          
#>  8 Ammonia   2022-08-14 00:00:00 NA          BDL              BDL          
#>  9 Ammonia   2022-09-11 00:00:00 NA          BDL              BDL          
#> 10 Ammonia   2022-09-11 00:00:00 NA          BDL              BDL          
#> # ℹ 81 more rows
#> # ℹ 2 more variables: `Diff./RPD` <chr>, `Hit/Miss` <chr>
```

## Quality control for frequency

The quality control checks for frequency are used to verify an
appropriate number of quality control samples have been collected or
analyzed for each parameter. These are checks on the quantity of samples
and not the values, as for the accuracy checks. The frequency checks
require results data (as in `resdat` above), a data quality objectives
file for accuracy (as in `accdat`), and a data quality objectives file
for frequency and completeness (as in `frecomdat`).

The
[`tabMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)
function is used to create tabular results for the frequency checks for
each parameter. The function can be used with inputs as paths to the
relevant files or as data frames returned by
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
and
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`, as explained in
the [data inputs and checks
vignette](https://massbays-tech.github.io/MassWateR/articles/inputs.html).
In the latter case, downstream analyses may not work if data are
formatted incorrectly. Also note that completeness is only evaluated on
parameters that are shared between the results file and the data quality
objectives completeness file. A warning is returned if there are
parameters that do not match. The warnings can be suppressed by setting
`warn = FALSE`.

The quality control tables for frequency show the number of records that
apply to a given check (e.g., Lab Blank, Field Blank, etc.) relative to
the number of “regular” data records (e.g., field samples or measures)
for each parameter. A summary of all frequency checks for each parameter
is provided if `type = "summary"`. The function is executed with the
data frames for the results and quality objectives file for frequency.

``` r
tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = "summary", warn = FALSE)
```

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

A color-coded table showing similar information as percentages for each
parameter is provided if `type = "percent"`. Cells are shown as green or
red if the required frequency checks are met as specified in the data
quality objectives file.

``` r
tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = "percent", warn = FALSE)
```

| Parameter      | Field Duplicate | Lab Duplicate | Field Blank | Lab Blank | Spike/Check Accuracy |
|----------------|-----------------|---------------|-------------|-----------|----------------------|
| Ammonia        | 9%              | 23%           | 16%         | 16%       | 21%                  |
| DO             | 22%             | -             | -           | -         | -                    |
| E.coli         | 17%             | 33%           | 33%         | 0%        | -                    |
| Nitrate        | 10%             | 50%           | 35%         | 25%       | 50%                  |
| pH             | 22%             | 35%           | -           | -         | 41%                  |
| Sp Conductance | 22%             | 35%           | -           | 43%       | 43%                  |
| TP             | 10%             | 33%           | 23%         | 10%       | 31%                  |
| Water Temp     | 22%             | 35%           | -           | -         | 39%                  |

The
[`tabMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)
function uses the
[`qcMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRfre.md)
function internally to create the table. This function creates the raw
summaries of frequency from the input data. Typically,
[`qcMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRfre.md)
is not used by itself, but it is explained here to demonstrate how the
raw summaries can be obtained.

Below, the
[`qcMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRfre.md)
function is executed with the data frames for the results and quality
objectives file for frequency and completeness. The warnings are
suppressed.

``` r
qcMWRfre(res = resdat, acc = accdat, frecom = frecomdat, warn = FALSE)
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

The output shows the frequency checks from the combined files. Each row
applies to a frequency check for a parameter. The `Parameter` column
shows the parameter, the `obs` column shows the total records that apply
to regular activity types, the `check` column shows the relevant
activity type for each frequency check, the `count` column shows the
number of records that apply to a check, the `standard` column shows the
relevant percentage required for the quality control check from the
quality control objectives file, and the `met` column shows if the
standard was met by comparing if `percent` is greater than or equal to
`standard`.

## Quality control for completeness

The quality control checks for completeness are used to assess the
number of regular samples relative to qualified samples that apply to
each parameter. Regular samples are those with `Field Msr/Obs` or
`Sample-Routine` in the `Activity Type` column of the results file and
qualified samples are those marked as `Q` in the
`Result Measure Qualifier` column of the results file. The completeness
checks require results data (as in `resdat` above), a data quality
objectives file for frequency and completeness (as in `frecomdat`), and
the censored data indicating number of missing or censored observations
by parameter (as in `censdat`). The censored data is optional.

The
[`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
function is used to create a table that shows the completeness
percentages for each parameter. As explained in the previous section,
the function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md),
and
[`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md).

A summary table showing the number of data records, number of qualified
records, and percent completeness can be created with
[`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md).
The `% Completeness` column shows cells as green or red if the required
percentage of observations for completeness are present as specified in
the data quality objectives file. The `Hit/Miss` column shows similar
information but in text format, i.e., `MISS` is shown if the quality
control standard for completeness is not met. The function is also
executed with the data frames from above, since they have already passed
the internal checks.

``` r
tabMWRcom(res = resdat, frecom = frecomdat, cens = censdat, warn = FALSE)
```

| Parameter      | Number of Data Records | Number of Qualified Records | Number of Missed/ Censored Records | % Completeness | Hit/ Miss | Notes |
|----------------|------------------------|-----------------------------|------------------------------------|----------------|-----------|-------|
| Ammonia        | 43                     | 0                           | 0                                  | 100%           |           |       |
| DO             | 49                     | 0                           | 1                                  | 98%            |           |       |
| E.coli         | 12                     | 0                           | 0                                  | 100%           |           |       |
| Nitrate        | 20                     | 0                           | 0                                  | 100%           |           |       |
| pH             | 49                     | 0                           | 12                                 | 80%            | MISS      |       |
| Sp Conductance | 49                     | 0                           | 0                                  | 100%           |           |       |
| TP             | 48                     | 5                           | 0                                  | 90%            | MISS      |       |
| Water Temp     | 49                     | 0                           | 0                                  | 100%           |           |       |

The
[`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
function uses the
[`qcMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRcom.md)
function internally to create the table. This function creates the raw
summaries of completeness from the input data. Typically,
[`qcMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRcom.md)
is not used by itself, but it is explained here to demonstrate how the
raw summaries can be obtained.

Below, the
[`qcMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRcom.md)
function is executed with the data frames for the results, quality
objectives file for frequency and completeness, and censored data. The
warnings are suppressed.

``` r
qcMWRcom(res = resdat, frecom = frecomdat, cens = censdat, warn = FALSE)
#> # A tibble: 8 × 7
#>   Parameter      datarec qualrec standard Missed and Censored R…¹ complete met  
#>   <chr>            <int>   <int>    <dbl>                   <int>    <dbl> <lgl>
#> 1 Ammonia             43       0       90                       0    100   TRUE 
#> 2 DO                  49       0       90                       1     98   TRUE 
#> 3 E.coli              12       0       90                       0    100   TRUE 
#> 4 Nitrate             20       0       90                       0    100   TRUE 
#> 5 pH                  49       0       90                      12     80.3 FALSE
#> 6 Sp Conductance      49       0       90                       0    100   TRUE 
#> 7 TP                  48       5       90                       0     89.6 FALSE
#> 8 Water Temp          49       0       90                       0    100   TRUE 
#> # ℹ abbreviated name: ¹​`Missed and Censored Records`
```

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
