# Create summary spreadsheet of the water quality monitoring results

Create summary spreadsheet of unique values for each column in the water
quality results file to check for data mistakes prior to running the
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
function

## Usage

``` r
readMWRresultsview(
  respth,
  columns = NULL,
  output_dir,
  output_file = NULL,
  maxlen = 8
)
```

## Arguments

- respth:

  character string of path to the results file

- columns:

  character string indicating which columns to view, defaults to all

- output_dir:

  character string of the output directory for the rendered file

- output_file:

  optional character string for the name of the .csv file output, must
  include the file extension

- maxlen:

  numeric to truncate numeric values to the specified length

## Value

Creates a spreadsheet at the location specified by `output_dir`. Each
column shows the unique values.

## Details

Acceptable options for the `columns` argument include any of the column
names in the results file. The default setting (`NULL`) will show every
column in the results file.

The output of this function can be useful to troubleshoot the checks
when importing the water quality monitoring result file with
`readMWRresults` (see
<https://massbays-tech.github.io/MassWateR/articles/MassWateR.html#data-import-and-checks>).

Unique entries for the `Result Value` column will include `NA` entries
if present, all other columns will not.

## Examples

``` r
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# all columns
readMWRresultsview(respth, output_dir = tempdir())
#> csv created successfully! File located at /tmp/Rtmps6FTR0/resultsview.csv

# parameters and units
readMWRresultsview(respth, columns = c('Characteristic Name', 'Result Unit'),
   output_dir = tempdir())
#> csv created successfully! File located at /tmp/Rtmps6FTR0/resultsview.csv
```
