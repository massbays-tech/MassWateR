# Utility function to import data as paths or data frames

Utility function to import data as paths or data frames

## Usage

``` r
utilMWRinput(
  res = NULL,
  acc = NULL,
  frecom = NULL,
  sit = NULL,
  wqx = NULL,
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

- acc:

  character string of path to the data quality objectives file for
  accuracy or `data.frame` returned by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- frecom:

  character string of path to the data quality objectives file for
  frequency and completeness or `data.frame` returned by
  [`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)

- sit:

  character string of path to the site metadata file or `data.frame` for
  site metadata returned by
  [`readMWRsites`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md)

- wqx:

  character string of path to the wqx metadata file or `data.frame` for
  wqx metadata returned by
  [`readMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md)

- cens:

  character string of path to the censored data file or `data.frame` for
  censored data returned by
  [`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)

- fset:

  optional list of inputs with elements named `res`, `acc`, `frecom`,
  `sit`, `wqx`, or `cens`, overrides the other arguments, see details

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md),
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md),
  [`checkMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md),
  [`checkMWRsites`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md),
  [`checkMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/checkMWRwqx.md),
  or
  [`checkMWRcens`](https://massbays-tech.github.io/MassWateR/reference/checkMWRcens.md),
  applies only if `res`, `acc`, `frecom`, `sit`, `wqx`, or `cens` are
  file paths

- warn:

  logical to return warnings to the console (default)

## Value

A six element list with the imported results, data quality objective
files, site metadata, wqx metadata, and censored data named `"resdat"`,
`"accdat"`, `"frecomdat"`, `"sitdat"`, `"wqxdat"`, and `"censdat"`
respectively.

## Details

The function is used internally by others to import data from paths to
the relevant files or as data frames returned by
[`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
[`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md),
[`readMWRsites`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md),
[`readMWRwqx`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md),
or
[`readMWRcens`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md).
For the former, the full suite of data checks can be evaluated with
`runkchk = T` (default) or suppressed with `runchk = F`.

The `fset` argument can used in place of the preceding arguments. The
argument accepts a list with named elements as `res`, `acc`, `frecom`,
`sit`, `wqx`, or `cens`, where the elements are either character strings
of the path or data frames to the corresponding inputs. Missing elements
will be interpreted as `NULL` values. This argument is provided as
convenience to apply a single list as input versus separate inputs for
each argument.

Any of the arguments for the data files can be `NULL`, used as a
convenience for downstream functions that do not require all.

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

# site path
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')

# wqx path
wqxpth <- system.file('extdata/ExampleWQX.xlsx', package = 'MassWateR')

# censored path
censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')

inp <- utilMWRinput(res = respth, acc = accpth, frecom = frecompth, sit = sitpth, 
  wqx = wqxpth, cens = censpth)
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
#> Running checks on WQX metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking unique parameters... OK
#>  Checking Parameter formats... OK
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
inp$resdat
#> # A tibble: 571 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#>  2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#>  3 ABT-301                  Field Msr/Obs   2022-05-15 00:00:00  
#>  4 ABT-312                  Field Msr/Obs   2022-05-15 00:00:00  
#>  5 DAN-013                  Field Msr/Obs   2022-05-15 00:00:00  
#>  6 ELZ-004                  Field Msr/Obs   2022-05-15 00:00:00  
#>  7 HOP-011                  Field Msr/Obs   2022-05-15 00:00:00  
#>  8 NSH-002                  Field Msr/Obs   2022-05-15 00:00:00  
#>  9 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#> 10 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#> # ℹ 561 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
inp$accdat
#> # A tibble: 12 × 10
#>    Parameter   uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>    <chr>       <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#>  1 Water Temp  deg C NA       NA all           <= 1.0            <= 1.0         
#>  2 pH          NA    NA       NA all           <= 0.5            <= 0.5         
#>  3 DO          mg/l  NA       NA < 4           < 20%             NA             
#>  4 DO          mg/l  NA       NA >= 4          < 10%             NA             
#>  5 Sp Conduct… uS/cm NA       NA < 250         < 30%             < 30%          
#>  6 Sp Conduct… uS/cm NA    10000 >= 250        < 20%             < 20%          
#>  7 TP          mg/l   0.01    NA < 0.05        <= 0.01           <= 0.01        
#>  8 TP          mg/l   0.01    NA >= 0.05       < 30%             < 20%          
#>  9 Nitrate     mg/l   0.05    NA all           < 30%             < 20%          
#> 10 Ammonia     mg/l   0.1     NA all           < 30%             < 20%          
#> 11 E.coli      MPN/…  1       NA <50           < log30%          < log30%       
#> 12 E.coli      MPN/…  1       NA >=50          < log20%          < log20%       
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
inp$frecomdat
#> # A tibble: 8 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Water Temp                    10              10            NA          NA
#> 2 pH                            10              10            NA          NA
#> 3 DO                            10              NA            NA          NA
#> 4 Sp Conductance                10              10            NA          10
#> 5 TP                            10               5            10           5
#> 6 Nitrate                       10               5            10           5
#> 7 Ammonia                       10               5            10           5
#> 8 E.coli                        10               5            10           5
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
inp$sitdat
#> # A tibble: 12 × 5
#>    `Monitoring Location ID` `Monitoring Location Name`    Monitoring Location …¹
#>    <chr>                    <chr>                                          <dbl>
#>  1 ABT-026                  Rte 2, Concord                                  42.5
#>  2 ABT-062                  Rte 62, Acton                                   42.4
#>  3 ABT-077                  Rte 27/USGS, Maynard                            42.4
#>  4 ABT-144                  Rte 62, Stow                                    42.4
#>  5 ABT-162                  Cox Street bridge                               42.4
#>  6 ABT-237                  Robin Hill Rd, Marlboro                         42.3
#>  7 ABT-301                  Rte 9, Westboro                                 42.3
#>  8 ABT-312                  Mill Road, Westboro                             42.3
#>  9 DAN-013                  Danforth Br, Hudson                             42.4
#> 10 ELZ-004                  Elizabeth Br, Stow                              42.4
#> 11 HOP-011                  Hop Br, Northboro                               42.3
#> 12 NSH-002                  Nashoba, Commonwealth, W. Co…                   42.5
#> # ℹ abbreviated name: ¹​`Monitoring Location Latitude`
#> # ℹ 2 more variables: `Monitoring Location Longitude` <dbl>,
#> #   `Location Group` <chr>
inp$wqxdat
#> # A tibble: 8 × 6
#>   Parameter    Sampling Method Cont…¹ `Method Speciation` Result Sample Fracti…²
#>   <chr>        <chr>                  <chr>               <chr>                 
#> 1 Water Temp   NA                     NA                  NA                    
#> 2 pH           NA                     NA                  NA                    
#> 3 DO           NA                     NA                  NA                    
#> 4 Sp Conducta… NA                     NA                  NA                    
#> 5 TP           MassWateR              as P                Unfiltered            
#> 6 Nitrate      MassWateR              as N                Unfiltered            
#> 7 Ammonia      MassWateR              as N                Unfiltered            
#> 8 E.coli       MassWateR              NA                  NA                    
#> # ℹ abbreviated names: ¹​`Sampling Method Context`, ²​`Result Sample Fraction`
#> # ℹ 2 more variables: `Analytical Method` <chr>,
#> #   `Analytical Method Context` <chr>
inp$censdat
#> # A tibble: 8 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <int>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
#> 7 Ammonia                                    0
#> 8 E.coli                                     0

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

inp <- utilMWRinput(res = resdat, acc = accdat, frecom = frecomdat, sit = sitdat, 
   wqx = wqxdat, cens = censdat)
inp$resdat
#> # A tibble: 571 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#>  2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#>  3 ABT-301                  Field Msr/Obs   2022-05-15 00:00:00  
#>  4 ABT-312                  Field Msr/Obs   2022-05-15 00:00:00  
#>  5 DAN-013                  Field Msr/Obs   2022-05-15 00:00:00  
#>  6 ELZ-004                  Field Msr/Obs   2022-05-15 00:00:00  
#>  7 HOP-011                  Field Msr/Obs   2022-05-15 00:00:00  
#>  8 NSH-002                  Field Msr/Obs   2022-05-15 00:00:00  
#>  9 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#> 10 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#> # ℹ 561 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
inp$accdat
#> # A tibble: 12 × 10
#>    Parameter   uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>    <chr>       <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#>  1 Water Temp  deg C NA       NA all           <= 1.0            <= 1.0         
#>  2 pH          NA    NA       NA all           <= 0.5            <= 0.5         
#>  3 DO          mg/l  NA       NA < 4           < 20%             NA             
#>  4 DO          mg/l  NA       NA >= 4          < 10%             NA             
#>  5 Sp Conduct… uS/cm NA       NA < 250         < 30%             < 30%          
#>  6 Sp Conduct… uS/cm NA    10000 >= 250        < 20%             < 20%          
#>  7 TP          mg/l   0.01    NA < 0.05        <= 0.01           <= 0.01        
#>  8 TP          mg/l   0.01    NA >= 0.05       < 30%             < 20%          
#>  9 Nitrate     mg/l   0.05    NA all           < 30%             < 20%          
#> 10 Ammonia     mg/l   0.1     NA all           < 30%             < 20%          
#> 11 E.coli      MPN/…  1       NA <50           < log30%          < log30%       
#> 12 E.coli      MPN/…  1       NA >=50          < log20%          < log20%       
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
inp$frecomdat
#> # A tibble: 8 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Water Temp                    10              10            NA          NA
#> 2 pH                            10              10            NA          NA
#> 3 DO                            10              NA            NA          NA
#> 4 Sp Conductance                10              10            NA          10
#> 5 TP                            10               5            10           5
#> 6 Nitrate                       10               5            10           5
#> 7 Ammonia                       10               5            10           5
#> 8 E.coli                        10               5            10           5
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
inp$sitdat
#> # A tibble: 12 × 5
#>    `Monitoring Location ID` `Monitoring Location Name`    Monitoring Location …¹
#>    <chr>                    <chr>                                          <dbl>
#>  1 ABT-026                  Rte 2, Concord                                  42.5
#>  2 ABT-062                  Rte 62, Acton                                   42.4
#>  3 ABT-077                  Rte 27/USGS, Maynard                            42.4
#>  4 ABT-144                  Rte 62, Stow                                    42.4
#>  5 ABT-162                  Cox Street bridge                               42.4
#>  6 ABT-237                  Robin Hill Rd, Marlboro                         42.3
#>  7 ABT-301                  Rte 9, Westboro                                 42.3
#>  8 ABT-312                  Mill Road, Westboro                             42.3
#>  9 DAN-013                  Danforth Br, Hudson                             42.4
#> 10 ELZ-004                  Elizabeth Br, Stow                              42.4
#> 11 HOP-011                  Hop Br, Northboro                               42.3
#> 12 NSH-002                  Nashoba, Commonwealth, W. Co…                   42.5
#> # ℹ abbreviated name: ¹​`Monitoring Location Latitude`
#> # ℹ 2 more variables: `Monitoring Location Longitude` <dbl>,
#> #   `Location Group` <chr>
inp$wqxdat
#> # A tibble: 8 × 6
#>   Parameter    Sampling Method Cont…¹ `Method Speciation` Result Sample Fracti…²
#>   <chr>        <chr>                  <chr>               <chr>                 
#> 1 Water Temp   NA                     NA                  NA                    
#> 2 pH           NA                     NA                  NA                    
#> 3 DO           NA                     NA                  NA                    
#> 4 Sp Conducta… NA                     NA                  NA                    
#> 5 TP           MassWateR              as P                Unfiltered            
#> 6 Nitrate      MassWateR              as N                Unfiltered            
#> 7 Ammonia      MassWateR              as N                Unfiltered            
#> 8 E.coli       MassWateR              NA                  NA                    
#> # ℹ abbreviated names: ¹​`Sampling Method Context`, ²​`Result Sample Fraction`
#> # ℹ 2 more variables: `Analytical Method` <chr>,
#> #   `Analytical Method Context` <chr>
inp$censdat
#> # A tibble: 8 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <int>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
#> 7 Ammonia                                    0
#> 8 E.coli                                     0

##
# using fset as list input

# input with paths to files
fset <- list(
  res = respth, 
  acc = accpth, 
  frecom = frecompth,
  sit = sitpth, 
  wqx = wqxpth, 
  cens = censpth
)
utilMWRinput(fset = fset)
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
#> Running checks on WQX metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking unique parameters... OK
#>  Checking Parameter formats... OK
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
#> $resdat
#> # A tibble: 571 × 18
#>    `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>    <chr>                    <chr>           <dttm>               
#>  1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#>  2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#>  3 ABT-301                  Field Msr/Obs   2022-05-15 00:00:00  
#>  4 ABT-312                  Field Msr/Obs   2022-05-15 00:00:00  
#>  5 DAN-013                  Field Msr/Obs   2022-05-15 00:00:00  
#>  6 ELZ-004                  Field Msr/Obs   2022-05-15 00:00:00  
#>  7 HOP-011                  Field Msr/Obs   2022-05-15 00:00:00  
#>  8 NSH-002                  Field Msr/Obs   2022-05-15 00:00:00  
#>  9 ABT-026                  Field Msr/Obs   2022-06-12 00:00:00  
#> 10 ABT-062                  Field Msr/Obs   2022-06-12 00:00:00  
#> # ℹ 561 more rows
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>, …
#> 
#> $accdat
#> # A tibble: 12 × 10
#>    Parameter   uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>    <chr>       <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#>  1 Water Temp  deg C NA       NA all           <= 1.0            <= 1.0         
#>  2 pH          NA    NA       NA all           <= 0.5            <= 0.5         
#>  3 DO          mg/l  NA       NA < 4           < 20%             NA             
#>  4 DO          mg/l  NA       NA >= 4          < 10%             NA             
#>  5 Sp Conduct… uS/cm NA       NA < 250         < 30%             < 30%          
#>  6 Sp Conduct… uS/cm NA    10000 >= 250        < 20%             < 20%          
#>  7 TP          mg/l   0.01    NA < 0.05        <= 0.01           <= 0.01        
#>  8 TP          mg/l   0.01    NA >= 0.05       < 30%             < 20%          
#>  9 Nitrate     mg/l   0.05    NA all           < 30%             < 20%          
#> 10 Ammonia     mg/l   0.1     NA all           < 30%             < 20%          
#> 11 E.coli      MPN/…  1       NA <50           < log30%          < log30%       
#> 12 E.coli      MPN/…  1       NA >=50          < log20%          < log20%       
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
#> 
#> $frecomdat
#> # A tibble: 8 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Water Temp                    10              10            NA          NA
#> 2 pH                            10              10            NA          NA
#> 3 DO                            10              NA            NA          NA
#> 4 Sp Conductance                10              10            NA          10
#> 5 TP                            10               5            10           5
#> 6 Nitrate                       10               5            10           5
#> 7 Ammonia                       10               5            10           5
#> 8 E.coli                        10               5            10           5
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
#> 
#> $sitdat
#> # A tibble: 12 × 5
#>    `Monitoring Location ID` `Monitoring Location Name`    Monitoring Location …¹
#>    <chr>                    <chr>                                          <dbl>
#>  1 ABT-026                  Rte 2, Concord                                  42.5
#>  2 ABT-062                  Rte 62, Acton                                   42.4
#>  3 ABT-077                  Rte 27/USGS, Maynard                            42.4
#>  4 ABT-144                  Rte 62, Stow                                    42.4
#>  5 ABT-162                  Cox Street bridge                               42.4
#>  6 ABT-237                  Robin Hill Rd, Marlboro                         42.3
#>  7 ABT-301                  Rte 9, Westboro                                 42.3
#>  8 ABT-312                  Mill Road, Westboro                             42.3
#>  9 DAN-013                  Danforth Br, Hudson                             42.4
#> 10 ELZ-004                  Elizabeth Br, Stow                              42.4
#> 11 HOP-011                  Hop Br, Northboro                               42.3
#> 12 NSH-002                  Nashoba, Commonwealth, W. Co…                   42.5
#> # ℹ abbreviated name: ¹​`Monitoring Location Latitude`
#> # ℹ 2 more variables: `Monitoring Location Longitude` <dbl>,
#> #   `Location Group` <chr>
#> 
#> $wqxdat
#> # A tibble: 8 × 6
#>   Parameter    Sampling Method Cont…¹ `Method Speciation` Result Sample Fracti…²
#>   <chr>        <chr>                  <chr>               <chr>                 
#> 1 Water Temp   NA                     NA                  NA                    
#> 2 pH           NA                     NA                  NA                    
#> 3 DO           NA                     NA                  NA                    
#> 4 Sp Conducta… NA                     NA                  NA                    
#> 5 TP           MassWateR              as P                Unfiltered            
#> 6 Nitrate      MassWateR              as N                Unfiltered            
#> 7 Ammonia      MassWateR              as N                Unfiltered            
#> 8 E.coli       MassWateR              NA                  NA                    
#> # ℹ abbreviated names: ¹​`Sampling Method Context`, ²​`Result Sample Fraction`
#> # ℹ 2 more variables: `Analytical Method` <chr>,
#> #   `Analytical Method Context` <chr>
#> 
#> $censdat
#> # A tibble: 8 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <int>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
#> 7 Ammonia                                    0
#> 8 E.coli                                     0
#> 
```
