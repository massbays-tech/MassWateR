# Check data quality objective accuracy data

Check data quality objective accuracy data

## Usage

``` r
checkMWRacc(accdat, warn = TRUE)
```

## Arguments

- accdat:

  input data frame

- warn:

  logical to return warnings to the console (default)

## Value

`accdat` is returned as is if no errors are found, otherwise an
informative error message is returned prompting the user to make the
required correction to the raw data before proceeding.

## Details

This function is used internally within
[`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
to run several checks on the input data for completeness and conformance
to WQX requirements

The following checks are made:

- Column name spelling: Should be the following: Parameter, uom, MDL,
  UQL, Value Range, Field Duplicate, Lab Duplicate, Field Blank, Lab
  Blank, Spike/Check Accuracy

- Columns present: All columns from the previous check should be present

- Column types: All columns should be characters/text, except for MDL
  and UQL

- `Value Range` column na check: The character string `"na"` should not
  be in the `Value Range` column, `"all"` should be used if the entire
  range applies

- Unrecognized characters: Fields describing accuracy checks should not
  include symbols or text other than \\\<=\\, \\\leq\\, \\\<\\, \\\>=\\,
  \\\geq\\, \\\>\\, \\\pm\\, `"%"`, `"BDL"`, `"AQL"`, `"log"`, or
  `"all"`

- Overlap in `Value Range` column: Entries in `Value Range` should not
  overlap for a parameter (excludes ascending ranges)

- Gap in `Value Range` column: Entries in `Value Range` should not
  include a gap for a parameter, warning only

- Parameter: Should match parameter names in the `Simple Parameter` or
  `WQX Parameter` columns of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data

- Units: No missing entries in units (`uom`), except pH which can be
  blank

- Single unit: Each unique `Parameter` should have only one type for the
  units (`uom`)

- Correct units: Each unique `Parameter` should have an entry in the
  units (`uom`) that matches one of the acceptable values in the
  `Units of measure` column of the
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  data

- Empty columns: Columns with all missing or NA values will return a
  warning

## Examples

``` r
# accuracy path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
     package = 'MassWateR')

# accuracy data with no checks
accdat <- readxl::read_excel(accpth, na = c('NA', ''), col_types = 'text')
accdat <- dplyr::mutate(accdat, dplyr::across(-c(`Value Range`), ~ dplyr::na_if(.x, 'na'))) 
      
checkMWRacc(accdat)
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
#> # A tibble: 12 × 10
#>    Parameter   uom   MDL   UQL   `Value Range` `Field Duplicate` `Lab Duplicate`
#>    <chr>       <chr> <chr> <chr> <chr>         <chr>             <chr>          
#>  1 Water Temp  deg C NA    NA    all           <= 1.0            <= 1.0         
#>  2 pH          s.u.  NA    NA    all           <= 0.5            <= 0.5         
#>  3 DO          mg/l  NA    NA    < 4           < 20%             NA             
#>  4 DO          mg/l  NA    NA    >= 4          < 10%             NA             
#>  5 Sp Conduct… uS/cm NA    NA    < 250         < 30%             < 30%          
#>  6 Sp Conduct… uS/cm NA    10000 >= 250        < 20%             < 20%          
#>  7 TP          mg/l  0.01  NA    < 0.05        <= 0.01           <= 0.01        
#>  8 TP          mg/l  0.01  NA    >= 0.05       < 30%             < 20%          
#>  9 Nitrate     mg/l  0.05  NA    all           < 30%             < 20%          
#> 10 Ammonia     mg/l  0.1   NA    all           < 30%             < 20%          
#> 11 E.coli      MPN/… 1     NA    <50           < log30%          < log30%       
#> 12 E.coli      MPN/… 1     NA    >=50          < log20%          < log20%       
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
```
