# Check if required inputs are present for a function

Check if required inputs are present for a function

## Usage

``` r
utilMWRinputcheck(inputs, nocheck = NULL)
```

## Arguments

- inputs:

  list of arguments passed from the parent function

- nocheck:

  optional character vector of inputs not to check, allows for optional
  inputs

## Value

NULL if all inputs are present, otherwise an error message indicating
which inputs are missing

## Examples

``` r
inputchk <- formals(tabMWRcom)
inputchk$res <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')
inputchk$frecom <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', 
  package = 'MassWateR')
inputchk$cens <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')

utilMWRinputcheck(inputchk)
#> NULL
```
