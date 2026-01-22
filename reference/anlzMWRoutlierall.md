# Analyze outliers in results file for all parameters

Analyze outliers in results file for all parameters

## Usage

``` r
anlzMWRoutlierall(
  res = NULL,
  acc = NULL,
  fset = NULL,
  fig_height = 4,
  fig_width = 8,
  format = c("word", "png", "zip"),
  output_dir,
  output_file = NULL,
  type = c("box", "jitterbox", "jitter"),
  group,
  dtrng = NULL,
  repel = TRUE,
  outliers = FALSE,
  labsize = 3,
  fill = "lightgrey",
  alpha = 0.8,
  width = 0.8,
  yscl = "auto",
  ttlsize = 1.2,
  bssize = 11,
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

- fset:

  optional list of inputs with elements named `res`, `acc`, `frecom`,
  `sit`, or `wqx` overrides the other arguments

- fig_height:

  numeric for plot heights in inches

- fig_width:

  numeric for plot width in inches

- format:

  character string indicating if results are placed in a word file, as
  separate png files, or as a zipped file of separate png files in
  `output_dir`

- output_dir:

  character string of the output directory for the results

- output_file:

  optional character string for the file name if `format = "word"`

- type:

  character indicating `"box"`, `"jitterbox"`, or `"jitter"`, see
  details

- group:

  character indicating whether the summaries are grouped by month, site,
  or week of year

- dtrng:

  character string of length two for the date ranges as YYYY-MM-DD,
  optional

- repel:

  logical indicating if overlapping outlier labels are offset

- outliers:

  logical indicating if outliers are returned to the console instead of
  plotting

- labsize:

  numeric indicating font size for the outlier labels

- fill:

  numeric indicating fill color for boxplots

- alpha:

  numeric from 0 to 1 indicating transparency of fill color

- width:

  numeric for width of boxplots

- yscl:

  character indicating one of `"auto"` (default), `"log"`, or
  `"linear"`, see details

- ttlsize:

  numeric value indicating font size of the title relative to other text
  in the plot

- bssize:

  numeric for overall plot text scaling, passed to
  [`theme_minimal`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)
  or
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md),
  applies only if `res` or `acc` are file paths

- warn:

  logical to return warnings to the console (default)

## Value

A word document named `outlierall.docx` (or name passed to
`output_file`) if `format = "word"` or separate png files for each
parameter if `format = "png"` will be saved in the directory specified
by `output_dir`

## Details

This function is a wrapper to
[`anlzMWRoutlier`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRoutlier.md)
to create plots for all parameters with appropriate data in the water
quality monitoring results

## Examples

``` r
# results data path
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

# \donttest{
# create word output
anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'word', output_dir = tempdir())
#> Word document created successfully! File located at /tmp/RtmpDrafhR/outlierall.docx

# create png output
anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'png', output_dir = tempdir())
#> PNG files created successfully! Files located at /tmp/RtmpDrafhR

# create zipped png output
anlzMWRoutlierall(resdat, accdat, group = 'month', format = 'zip', output_dir = tempdir())
#> PNG files created successfully! Zipped files located at /tmp/RtmpDrafhR
# }
```
