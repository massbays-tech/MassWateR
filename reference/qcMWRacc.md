# Run quality control accuracy checks for water quality monitoring results

Run quality control accuracy checks for water quality monitoring results

## Usage

``` r
qcMWRacc(
  res = NULL,
  acc = NULL,
  frecom = NULL,
  fset = NULL,
  runchk = TRUE,
  warn = TRUE,
  accchk = c("Field Blanks", "Lab Blanks", "Field Duplicates", "Lab Duplicates",
    "Lab Spikes / Instrument Checks"),
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
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md),
  applies only if `res` or `acc` are file paths

- warn:

  logical to return warnings to the console (default)

- accchk:

  character string indicating which accuracy check to return, one to any
  of `"Field Blanks"`, `"Lab Blanks"`, `"Field Duplicates"`,
  `"Lab Duplicates"`, or `"Lab Spikes / Instrument Checks"`

- suffix:

  character string indicating suffix to append to percentage values

## Value

The output shows the accuracy checks from the input files returned as a
list, with each element of the list corresponding to a specific accuracy
check specified with `accchk`.

## Details

The function can be used with inputs as paths to the relevant files or
as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
and
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`. In the latter
case, downstream analyses may not work if data are formatted
incorrectly. For convenience, a named list with the input arguments as
paths or data frames can be passed to the `fset` argument instead. See
the help file for
[`utilMWRinput`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinput.md).

Note that accuracy is only evaluated on parameters in the `Parameter`
column in the data quality objectives accuracy file. A warning is
returned if there are parameters in `Parameter` in the accuracy file
that are not in `Characteristic Name` in the results file.

Similarly, parameters in the results file in the `Characteristic Name`
column that are not found in the data quality objectives accuracy file
are not evaluated. A warning is returned if there are parameters in
`Characteristic Name` in the results file that are not in `Parameter` in
the accuracy file.

The data quality objectives file for frequency and completeness is used
to screen parameters in the results file for inclusion in the accuracy
tables. Parameters with empty values in the frequency and completeness
table are not returned.

## Examples

``` r
##
# using file paths

# results path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# accuracy path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

# frequency and completeness path
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
     package = 'MassWateR')

qcMWRacc(res = respth, acc = accpth, frecom = frecompth)
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
#> $`Field Blanks`
#> # A tibble: 29 × 6
#>    Parameter Date                Site  Result Threshold   `Hit/Miss`
#>    <chr>     <dttm>              <chr> <chr>  <chr>       <chr>     
#>  1 Ammonia   2022-05-15 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  2 Ammonia   2022-06-12 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  3 Ammonia   2022-07-17 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  4 Ammonia   2022-07-17 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  5 Ammonia   2022-08-14 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  6 Ammonia   2022-08-14 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  7 Ammonia   2022-09-11 00:00:00 NA    BDL    0.1 mg/l    NA        
#>  8 E.coli    2022-06-13 00:00:00 NA    BDL    1 MPN/100ml NA        
#>  9 E.coli    2022-07-18 00:00:00 NA    BDL    1 MPN/100ml NA        
#> 10 E.coli    2022-08-01 00:00:00 NA    BDL    1 MPN/100ml NA        
#> # ℹ 19 more rows
#> 
#> $`Lab Blanks`
#> # A tibble: 38 × 6
#>    Parameter Date                `Sample ID` Result   Threshold `Hit/Miss`
#>    <chr>     <dttm>              <chr>       <chr>    <chr>     <chr>     
#>  1 Ammonia   2022-05-15 00:00:00 NA          BDL      0.1 mg/l  NA        
#>  2 Ammonia   2022-06-12 00:00:00 NA          BDL      0.1 mg/l  NA        
#>  3 Ammonia   2022-07-17 00:00:00 NA          BDL      0.1 mg/l  NA        
#>  4 Ammonia   2022-07-17 00:00:00 NA          0.1 mg/l 0.1 mg/l  MISS      
#>  5 Ammonia   2022-08-14 00:00:00 NA          BDL      0.1 mg/l  NA        
#>  6 Ammonia   2022-08-14 00:00:00 NA          BDL      0.1 mg/l  NA        
#>  7 Ammonia   2022-09-11 00:00:00 NA          BDL      0.1 mg/l  NA        
#>  8 Nitrate   2022-05-15 00:00:00 NA          BDL      0.05 mg/l NA        
#>  9 Nitrate   2022-06-12 00:00:00 NA          BDL      0.05 mg/l NA        
#> 10 Nitrate   2022-07-17 00:00:00 NA          BDL      0.05 mg/l NA        
#> # ℹ 28 more rows
#> 
#> $`Field Duplicates`
#> # A tibble: 57 × 7
#>    Parameter Date                Site    `Initial Result` `Dup. Result`
#>    <chr>     <dttm>              <chr>   <chr>            <chr>        
#>  1 Ammonia   2022-05-15 00:00:00 ABT-312 BDL              BDL          
#>  2 Ammonia   2022-05-15 00:00:00 DAN-013 BDL              BDL          
#>  3 Ammonia   2022-06-12 00:00:00 ABT-301 BDL              0.2 mg/l     
#>  4 Ammonia   2022-09-11 00:00:00 ABT-301 BDL              BDL          
#>  5 DO        2022-05-15 00:00:00 ABT-026 7.58 mg/l        7.6 mg/l     
#>  6 DO        2022-05-15 00:00:00 ELZ-004 5.81 mg/l        5.94 mg/l    
#>  7 DO        2022-05-15 00:00:00 NSH-002 8.32 mg/l        8.33 mg/l    
#>  8 DO        2022-06-12 00:00:00 ABT-062 8.56 mg/l        8.56 mg/l    
#>  9 DO        2022-06-12 00:00:00 ABT-237 7.81 mg/l        8.1 mg/l     
#> 10 DO        2022-06-12 00:00:00 HOP-011 7.8 mg/l         7.79 mg/l    
#> # ℹ 47 more rows
#> # ℹ 2 more variables: `Diff./RPD` <chr>, `Hit/Miss` <chr>
#> 
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
#> 
#> $`Lab Spikes / Instrument Checks`
#> # A tibble: 94 × 7
#>    Parameter Date                `Sample ID` `Spike/Standard` Result        
#>    <chr>     <dttm>              <chr>       <chr>            <chr>         
#>  1 Ammonia   2022-05-15 00:00:00 NA          100 % recovery   86 % recovery 
#>  2 Ammonia   2022-06-12 00:00:00 NA          100 % recovery   94 % recovery 
#>  3 Ammonia   2022-06-12 00:00:00 NA          100 % recovery   106 % recovery
#>  4 Ammonia   2022-07-17 00:00:00 NA          100 % recovery   92 % recovery 
#>  5 Ammonia   2022-07-17 00:00:00 NA          100 % recovery   108 % recovery
#>  6 Ammonia   2022-08-14 00:00:00 NA          100 % recovery   96 % recovery 
#>  7 Ammonia   2022-08-14 00:00:00 NA          100 % recovery   102 % recovery
#>  8 Ammonia   2022-09-11 00:00:00 NA          100 % recovery   88 % recovery 
#>  9 Ammonia   2022-09-11 00:00:00 NA          100 % recovery   89 % recovery 
#> 10 Nitrate   2022-05-15 00:00:00 NA          100 % recovery   99 % recovery 
#> # ℹ 84 more rows
#> # ℹ 2 more variables: `Diff./Accuracy` <chr>, `Hit/Miss` <chr>
#> 
```
