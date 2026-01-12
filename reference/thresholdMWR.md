# Master thresholds list for analysis of results data

Master thresholds list for analysis of results data

## Usage

``` r
thresholdMWR
```

## Format

A `data.frame` of 28 rows and 10 columns

## Details

This file includes appropriate threshold values of water quality
parameters for marine and freshwater environments based on state
standards or typical ranges in Massachusetts.

## Examples

``` r
thresholdMWR
#> # A tibble: 28 × 10
#>    `Simple Parameter` uom   Fresh_1 Fresh_1_Label Fresh_2 Fresh_2_Label Marine_1
#>    <chr>              <chr>   <dbl> <chr>           <dbl> <chr>            <dbl>
#>  1 TP                 mg/l     0.05 Gold Book St…    NA   NA                NA  
#>  2 TP                 ug/l    50    Gold Book St…    NA   NA                NA  
#>  3 TP                 umol…    1.61 Gold Book St…    NA   NA                NA  
#>  4 TP                 ppm      0.05 Gold Book St…    NA   NA                NA  
#>  5 DO                 mg/l     5    Class A/B Wa…    NA   NA                 5  
#>  6 DO                 ug/l  5000    Class A/B Wa…    NA   NA              5000  
#>  7 pH                 blank    6.5  Class A/B Lo…     8.3 Class A/B Up…      7.5
#>  8 Water Temp         deg C   20    Cold Water F…    28.3 Warm Water F…     25  
#>  9 Water Temp         deg F   68    Cold Water F…    83   Warm Water F…     77  
#> 10 Enterococcus       cfu/…   70    BAV Primary …    NA   NA                70  
#> # ℹ 18 more rows
#> # ℹ 3 more variables: Marine_1_Label <chr>, Marine_2 <dbl>,
#> #   Marine_2_Label <chr>
```
