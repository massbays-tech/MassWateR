# Master parameter list and units for Characteristic Name column in results data

Master parameter list and units for Characteristic Name column in
results data

## Usage

``` r
paramsMWR
```

## Format

A `data.frame`

## Details

This information is used to verify the correct format of input data and
for formatting output data for upload to WQX. A column showing the
corresponding WQX names is also included.

## Examples

``` r
paramsMWR
#> # A tibble: 46 × 4
#>    `Parameter Group` `Simple Parameter` `WQX Parameter`       `Units of measure`
#>    <chr>             <chr>              <chr>                 <chr>             
#>  1 Water Temp        Water Temp         Temperature, water    deg C, deg F      
#>  2 pH                pH                 pH                    blank, s.u., None 
#>  3 DO                DO                 Dissolved oxygen (DO) mg/l, ug/l        
#>  4 DO                DO saturation      Dissolved oxygen sat… %                 
#>  5 Conductivity      Conductivity       Conductivity          uS/cm, mS/cm, S/m 
#>  6 Conductivity      Sp Conductance     Specific conductance  uS/cm, mS/cm, S/m 
#>  7 Conductivity      Salinity           Salinity              ppth, PSU, PSS, g…
#>  8 Phosphorus        TP                 Total Phosphorus, mi… mg/l, ug/l, umol/…
#>  9 Phosphorus        Ortho P            Orthophosphate        mg/l, ug/l, umol/…
#> 10 Phosphorus        POP                Phosphorus, Particul… mg/l, ug/l, umol/…
#> # ℹ 36 more rows
```
