# Identify outliers in a numeric vector

Identify outliers in a numeric vector

## Usage

``` r
utilMWRoutlier(x, logscl)
```

## Arguments

- x:

  numeric vector of any length

- logscl:

  logical to indicate if vector should be log10-transformed first

## Value

A logical vector equal in length to `x` indicating `TRUE` for outliers
or `FALSE` for within normal range

## Details

Outliers are identified as 1.5 times the interquartile range

## Examples

``` r
x <- rnorm(20)
utilMWRoutlier(x, logscl = FALSE)
#>  [1]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [13] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
```
