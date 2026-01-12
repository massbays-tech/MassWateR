# Format a list of QC tables for spreadsheet export

Format a list of QC tables for spreadsheet export

## Usage

``` r
utilMWRsheet(datin, rawdata = TRUE)
```

## Arguments

- datin:

  list of input QC tables

- rawdata:

  logical to include quality control accuracy summaries for raw data,
  e.g., field blanks, etc.

## Value

A list similar to the input with formatting applied

## Details

The function is used internally with
[`qcMWRreview`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
to format data quality objective and quality control tables for export
into an Excel spreadsheet. These changes are specific to the spreadsheet
format and may not reflect the formatting in the Word document produced
by
[`qcMWRreview`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md).

The `datin` list is expected to contain the following elements:

- `frecomdat` Data Quality Objectives for frequency and completeness
  data frame as returned by
  [`readMWRfrecom`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)

- `accdat` Data Quality Objectives for accuracy data frame as returned
  by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- `tabfreper` Frequency checks percent table, created with
  [`tabMWRfre`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)

- `tabfresum` Frequency checks summary table, created with
  [`tabMWRfre`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)

- `tabaccper` Accuracy checks percent table, created with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)

- `tabaccsum` Accuracy checks summary table, created with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)

- `tabcom` Completeness table, created with
  [`tabMWRcom`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)

- `indflddup` Individual accuracy checks table for field duplicates,
  created with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
  can be `NULL`

- `indlabdup` Individual accuracy checks table for lab duplicates,
  created with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
  can be `NULL`

- `indfldblk` Individual accuracy checks table for field blanks, created
  with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
  can be `NULL`

- `indlabblk` Individual accuracy checks table for lab blanks, created
  with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
  can be `NULL`

- `indlabins` Individual accuracy checks table for lab spikes and
  instrument checks, created with
  [`tabMWRacc`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md),
  can be `NULL`

## Examples

``` r
# results data path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# dqo accuracy data path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

# dqo completeness data path
frecompth <- system.file('extdata/ExampleDQOFrequencyCompleteness.xlsx', package = 'MassWateR')

# censored data path
censpth <- system.file('extdata/ExampleCensored.xlsx', package = 'MassWateR')

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

# frequency table percent
tabfreper <- tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent', 
  warn = FALSE) 

# frequency summary table
tabfresum <- tabMWRfre(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary', 
  warn = FALSE)

# accuracy table percent
tabaccper <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'percent', 
  warn = FALSE)

# accuracy table summary
tabaccsum <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'summary', 
  warn = FALSE)
  
# completeness table
tabcom <- tabMWRcom(res = resdat, frecom = frecomdat, cens = censdat, warn = FALSE, 
  parameterwd = 1.15, noteswd = 2)

# individual accuracy checks for raw data
indflddup <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
  accchk = 'Field Duplicates', warn = FALSE, caption = FALSE)
indlabdup <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
  accchk = 'Lab Duplicates', warn = FALSE, caption = FALSE)
indfldblk <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
  accchk = 'Field Blanks', warn = FALSE, caption = FALSE)
indlabblk <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
  accchk = 'Lab Blanks', warn = FALSE, caption = FALSE)
indlabins <- tabMWRacc(res = resdat, acc = accdat, frecom = frecomdat, type = 'individual', 
  accchk = 'Lab Spikes / Instrument Checks', warn = FALSE, caption = FALSE)

# input  
datin <- list(
  frecomdat = frecomdat, 
  accdat = accdat,
  tabfreper = tabfreper,
  tabfresum = tabfresum,
  tabaccper = tabaccper,
  tabaccsum = tabaccsum,
  tabcom = tabcom,
  indflddup = indflddup,
  indlabdup = indlabdup,
  indfldblk = indfldblk,
  indlabblk = indlabblk,
  indlabins = indlabins
)

utilMWRsheet(datin)
#> $`Frequency DQO`
#> # A tibble: 8 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Ammonia                       10               5            10           5
#> 2 DO                            10              NA            NA          NA
#> 3 E.coli                        10               5            10           5
#> 4 Nitrate                       10               5            10           5
#> 5 pH                            10              10            NA          NA
#> 6 Sp Conductance                10              10            NA          10
#> 7 TP                            10               5            10           5
#> 8 Water Temp                    10              10            NA          NA
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
#> 
#> $`Accuracy DQO`
#> # A tibble: 12 × 10
#>    Parameter   uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>    <chr>       <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#>  1 Ammonia     mg/l   0.1     NA all           < 30%             < 20%          
#>  2 DO          mg/l  NA       NA < 4           < 20%             NA             
#>  3 DO          mg/l  NA       NA >= 4          < 10%             NA             
#>  4 E.coli      MPN/…  1       NA <50           < log30%          < log30%       
#>  5 E.coli      MPN/…  1       NA >=50          < log20%          < log20%       
#>  6 Nitrate     mg/l   0.05    NA all           < 30%             < 20%          
#>  7 pH          NA    NA       NA all           <= 0.5            <= 0.5         
#>  8 Sp Conduct… uS/cm NA       NA < 250         < 30%             < 30%          
#>  9 Sp Conduct… uS/cm NA    10000 >= 250        < 20%             < 20%          
#> 10 TP          mg/l   0.01    NA < 0.05        <= 0.01           <= 0.01        
#> 11 TP          mg/l   0.01    NA >= 0.05       < 30%             < 20%          
#> 12 Water Temp  deg C NA       NA all           <= 1.0            <= 1.0         
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
#> 
#> $`Frequency Checks Percent`
#>        Parameter Field Duplicate Lab Duplicate Field Blank Lab Blank
#> 1        Ammonia               9            23          16        16
#> 2             DO              22            NA          NA        NA
#> 3         E.coli              17            33          33         0
#> 4        Nitrate              10            50          35        25
#> 5 Sp Conductance              22            35          NA        43
#> 6             TP              10            33          23        10
#> 7     Water Temp              22            35          NA        NA
#> 8             pH              22            35          NA        NA
#>   Spike/Check Accuracy
#> 1                   21
#> 2                   NA
#> 3                   NA
#> 4                   50
#> 5                   43
#> 6                   31
#> 7                   39
#> 8                   41
#> 
#> $`Frequency Checks`
#>                              Type      Parameter Number of Data Records
#> 1                Field Duplicates        Ammonia                     43
#> 2                Field Duplicates             DO                     49
#> 3                Field Duplicates         E.coli                     12
#> 4                Field Duplicates        Nitrate                     20
#> 5                Field Duplicates             pH                     49
#> 6                Field Duplicates Sp Conductance                     49
#> 7                Field Duplicates             TP                     48
#> 8                Field Duplicates     Water Temp                     49
#> 9                  Lab Duplicates        Ammonia                     43
#> 10                 Lab Duplicates         E.coli                     12
#> 11                 Lab Duplicates        Nitrate                     20
#> 12                 Lab Duplicates             pH                     49
#> 13                 Lab Duplicates Sp Conductance                     49
#> 14                 Lab Duplicates             TP                     48
#> 15                 Lab Duplicates     Water Temp                     49
#> 16                   Field Blanks        Ammonia                     43
#> 17                   Field Blanks         E.coli                     12
#> 18                   Field Blanks        Nitrate                     20
#> 19                   Field Blanks             TP                     48
#> 20                     Lab Blanks        Ammonia                     43
#> 21                     Lab Blanks         E.coli                     12
#> 22                     Lab Blanks        Nitrate                     20
#> 23                     Lab Blanks Sp Conductance                     49
#> 24                     Lab Blanks             TP                     48
#> 25 Lab Spikes / Instrument Checks        Ammonia                     43
#> 26 Lab Spikes / Instrument Checks        Nitrate                     20
#> 27 Lab Spikes / Instrument Checks             pH                     49
#> 28 Lab Spikes / Instrument Checks Sp Conductance                     49
#> 29 Lab Spikes / Instrument Checks             TP                     48
#> 30 Lab Spikes / Instrument Checks     Water Temp                     49
#>    Number of Dups/Blanks/Spikes Frequency % Hit/Miss
#> 1                             4           9     MISS
#> 2                            11          22         
#> 3                             2          17         
#> 4                             2          10         
#> 5                            11          22         
#> 6                            11          22         
#> 7                             5          10         
#> 8                            11          22         
#> 9                            10          23         
#> 10                            4          33         
#> 11                           10          50         
#> 12                           17          35         
#> 13                           17          35         
#> 14                           16          33         
#> 15                           17          35         
#> 16                            7          16         
#> 17                            4          33         
#> 18                            7          35         
#> 19                           11          23         
#> 20                            7          16         
#> 21                            0           0     MISS
#> 22                            5          25         
#> 23                           21          43         
#> 24                            5          10         
#> 25                            9          21         
#> 26                           10          50         
#> 27                           20          41         
#> 28                           21          43         
#> 29                           15          31         
#> 30                           19          39         
#> 
#> $`Accuracy Checks Percent`
#>        Parameter Field Duplicate Lab Duplicate Field Blank Lab Blank
#> 1        Ammonia              75           100         100        86
#> 2             DO             100            NA          NA        NA
#> 3         E.coli             100           100         100        NA
#> 4        Nitrate             100           100         100       100
#> 5 Sp Conductance             100           100          NA        95
#> 6             TP              80           100          91       100
#> 7     Water Temp             100           100          NA        NA
#> 8             pH             100            94          NA        NA
#>   Spike/Check Accuracy
#> 1                  100
#> 2                   NA
#> 3                   NA
#> 4                   90
#> 5                  100
#> 6                  100
#> 7                   95
#> 8                   95
#> 
#> $`Accuracy Checks`
#>                              Type      Parameter Number of QC Checks
#> 1                Field Duplicates        Ammonia                   4
#> 2                Field Duplicates             DO                  11
#> 3                Field Duplicates         E.coli                   2
#> 4                Field Duplicates        Nitrate                   2
#> 5                Field Duplicates Sp Conductance                  11
#> 6                Field Duplicates             TP                   5
#> 7                Field Duplicates     Water Temp                  11
#> 8                Field Duplicates             pH                  11
#> 9                  Lab Duplicates        Ammonia                  10
#> 10                 Lab Duplicates         E.coli                   4
#> 11                 Lab Duplicates        Nitrate                  10
#> 12                 Lab Duplicates Sp Conductance                  17
#> 13                 Lab Duplicates             TP                  16
#> 14                 Lab Duplicates     Water Temp                  17
#> 15                 Lab Duplicates             pH                  17
#> 16                   Field Blanks        Ammonia                   7
#> 17                   Field Blanks         E.coli                   4
#> 18                   Field Blanks        Nitrate                   7
#> 19                   Field Blanks             TP                  11
#> 20                     Lab Blanks        Ammonia                   7
#> 21                     Lab Blanks         E.coli                   0
#> 22                     Lab Blanks        Nitrate                   5
#> 23                     Lab Blanks Sp Conductance                  21
#> 24                     Lab Blanks             TP                   5
#> 25 Lab Spikes / Instrument Checks        Ammonia                   9
#> 26 Lab Spikes / Instrument Checks        Nitrate                  10
#> 27 Lab Spikes / Instrument Checks Sp Conductance                  21
#> 28 Lab Spikes / Instrument Checks             TP                  15
#> 29 Lab Spikes / Instrument Checks     Water Temp                  19
#> 30 Lab Spikes / Instrument Checks             pH                  20
#>    Number of Misses % Acceptance
#> 1                 1           75
#> 2                 0          100
#> 3                 0          100
#> 4                 0          100
#> 5                 0          100
#> 6                 1           80
#> 7                 0          100
#> 8                 0          100
#> 9                 0          100
#> 10                0          100
#> 11                0          100
#> 12                0          100
#> 13                0          100
#> 14                0          100
#> 15                1           94
#> 16                0          100
#> 17                0          100
#> 18                0          100
#> 19                1           91
#> 20                1           86
#> 21               NA           NA
#> 22                0          100
#> 23                1           95
#> 24                0          100
#> 25                0          100
#> 26                1           90
#> 27                0          100
#> 28                0          100
#> 29                1           95
#> 30                1           95
#> 
#> $Completeness
#>        Parameter Number of Data Records Number of Qualified Records
#> 1        Ammonia                     43                           0
#> 2             DO                     49                           0
#> 3         E.coli                     12                           0
#> 4        Nitrate                     20                           0
#> 5 Sp Conductance                     49                           0
#> 6             TP                     48                           5
#> 7     Water Temp                     49                           0
#> 8             pH                     49                           0
#>   Number of Missed/ Censored Records % Completeness Hit/ Miss Notes
#> 1                                  0            100                
#> 2                                  1             98                
#> 3                                  0            100                
#> 4                                  0            100                
#> 5                                  0            100                
#> 6                                  0             90      MISS      
#> 7                                  0            100                
#> 8                                 12             80      MISS      
#> 
#> $`Field Duplicates`
#>         Parameter       Date    Site Initial Result Initial Units Dup. Result
#> 1         Ammonia 2022-05-15 ABT-312             NA           BDL          NA
#> 2         Ammonia 2022-05-15 DAN-013             NA           BDL          NA
#> 3         Ammonia 2022-06-12 ABT-301             NA           BDL        0.20
#> 4         Ammonia 2022-09-11 ABT-301             NA           BDL          NA
#> 5              DO 2022-05-15 ABT-026           7.58          mg/l        7.60
#> 6              DO 2022-05-15 ELZ-004           5.81          mg/l        5.94
#> 7              DO 2022-05-15 NSH-002           8.32          mg/l        8.33
#> 8              DO 2022-06-12 ABT-062           8.56          mg/l        8.56
#> 9              DO 2022-06-12 ABT-237           7.81          mg/l        8.10
#> 10             DO 2022-06-12 HOP-011           7.80          mg/l        7.79
#> 11             DO 2022-07-17 ABT-062           7.59          mg/l        7.59
#> 12             DO 2022-07-17 ABT-237           5.92          mg/l        5.92
#> 13             DO 2022-08-14 ABT-237           5.89          mg/l        5.90
#> 14             DO 2022-09-11 ABT-026           7.70          mg/l        7.70
#> 15             DO 2022-09-11 HOP-011           8.36          mg/l        8.35
#> 16         E.coli 2022-07-18 ABT-162         276.00     MPN/100ml      276.00
#> 17         E.coli 2022-08-15 ABT-077         231.00     MPN/100ml      276.00
#> 18        Nitrate 2022-06-12 ABT-301           3.65          mg/l        3.35
#> 19        Nitrate 2022-07-17 ABT-077           0.72          mg/l        0.73
#> 20             pH 2022-05-15 ABT-026           7.19          s.u.        7.20
#> 21             pH 2022-05-15 ELZ-004           6.95          s.u.        7.08
#> 22             pH 2022-05-15 NSH-002           7.23          s.u.        7.25
#> 23             pH 2022-06-12 ABT-062           7.26          s.u.        7.26
#> 24             pH 2022-06-12 ABT-237           7.10          s.u.        7.11
#> 25             pH 2022-06-12 HOP-011           6.86          s.u.        6.82
#> 26             pH 2022-07-17 ABT-062           8.02          s.u.        8.01
#> 27             pH 2022-07-17 ABT-237           7.28          s.u.        7.28
#> 28             pH 2022-08-14 ABT-237           7.28          s.u.        7.28
#> 29             pH 2022-09-11 ABT-026           7.13          s.u.        7.14
#> 30             pH 2022-09-11 HOP-011           6.92          s.u.        6.84
#> 31 Sp Conductance 2022-05-15 ABT-026         585.00         uS/cm      586.00
#> 32 Sp Conductance 2022-05-15 ELZ-004         375.00         uS/cm      375.00
#> 33 Sp Conductance 2022-05-15 NSH-002         524.00         uS/cm      525.00
#> 34 Sp Conductance 2022-06-12 ABT-062         579.00         uS/cm      579.00
#> 35 Sp Conductance 2022-06-12 ABT-237         740.00         uS/cm      740.00
#> 36 Sp Conductance 2022-06-12 HOP-011         731.00         uS/cm      731.00
#> 37 Sp Conductance 2022-07-17 ABT-062         831.00         uS/cm      831.00
#> 38 Sp Conductance 2022-07-17 ABT-237        1222.00         uS/cm     1221.00
#> 39 Sp Conductance 2022-08-14 ABT-237        1497.00         uS/cm     1489.00
#> 40 Sp Conductance 2022-09-11 ABT-026         738.00         uS/cm      675.00
#> 41 Sp Conductance 2022-09-11 HOP-011         865.00         uS/cm      865.00
#> 42             TP 2022-05-15 ABT-312           0.03          mg/l        0.03
#> 43             TP 2022-05-15 DAN-013           0.04          mg/l        0.04
#> 44             TP 2022-06-12 ABT-301           0.03          mg/l        0.03
#> 45             TP 2022-07-17 ABT-077           0.04          mg/l        0.02
#> 46             TP 2022-09-11 ABT-301           0.03          mg/l        0.03
#> 47     Water Temp 2022-05-15 ABT-026          22.40         deg C       22.40
#> 48     Water Temp 2022-05-15 ELZ-004          22.20         deg C       22.20
#> 49     Water Temp 2022-05-15 NSH-002          23.30         deg C       23.30
#> 50     Water Temp 2022-06-12 ABT-062          21.10         deg C       21.10
#> 51     Water Temp 2022-06-12 ABT-237          18.70         deg C       18.70
#> 52     Water Temp 2022-06-12 HOP-011          18.40         deg C       18.40
#> 53     Water Temp 2022-07-17 ABT-062          25.60         deg C       25.60
#> 54     Water Temp 2022-07-17 ABT-237          20.80         deg C       20.80
#> 55     Water Temp 2022-08-14 ABT-237          18.80         deg C       18.80
#> 56     Water Temp 2022-09-11 ABT-026          20.50         deg C       20.50
#> 57     Water Temp 2022-09-11 HOP-011          19.30         deg C       19.30
#>    Dup. Result Units Diff./RPD Diff./RPD Units Hit/Miss
#> 1                BDL      0.00             RPD     <NA>
#> 2                BDL      0.00             RPD     <NA>
#> 3               mg/l     67.00             RPD     MISS
#> 4                BDL      0.00             RPD     <NA>
#> 5               mg/l      0.00             RPD     <NA>
#> 6               mg/l      2.00             RPD     <NA>
#> 7               mg/l      0.00             RPD     <NA>
#> 8               mg/l      0.00             RPD     <NA>
#> 9               mg/l      4.00             RPD     <NA>
#> 10              mg/l      0.00             RPD     <NA>
#> 11              mg/l      0.00             RPD     <NA>
#> 12              mg/l      0.00             RPD     <NA>
#> 13              mg/l      0.00             RPD     <NA>
#> 14              mg/l      0.00             RPD     <NA>
#> 15              mg/l      0.00             RPD     <NA>
#> 16         MPN/100ml      0.00          logRPD     <NA>
#> 17         MPN/100ml      3.00          logRPD     <NA>
#> 18              mg/l      9.00             RPD     <NA>
#> 19              mg/l      1.00             RPD     <NA>
#> 20              s.u.      0.01            s.u.     <NA>
#> 21              s.u.      0.13            s.u.     <NA>
#> 22              s.u.      0.02            s.u.     <NA>
#> 23              s.u.      0.00            s.u.     <NA>
#> 24              s.u.      0.01            s.u.     <NA>
#> 25              s.u.      0.04            s.u.     <NA>
#> 26              s.u.      0.01            s.u.     <NA>
#> 27              s.u.      0.00            s.u.     <NA>
#> 28              s.u.      0.00            s.u.     <NA>
#> 29              s.u.      0.01            s.u.     <NA>
#> 30              s.u.      0.08            s.u.     <NA>
#> 31             uS/cm      0.00             RPD     <NA>
#> 32             uS/cm      0.00             RPD     <NA>
#> 33             uS/cm      0.00             RPD     <NA>
#> 34             uS/cm      0.00             RPD     <NA>
#> 35             uS/cm      0.00             RPD     <NA>
#> 36             uS/cm      0.00             RPD     <NA>
#> 37             uS/cm      0.00             RPD     <NA>
#> 38             uS/cm      0.00             RPD     <NA>
#> 39             uS/cm      1.00             RPD     <NA>
#> 40             uS/cm      9.00             RPD     <NA>
#> 41             uS/cm      0.00             RPD     <NA>
#> 42              mg/l      0.00            mg/l     <NA>
#> 43              mg/l      0.00            mg/l     <NA>
#> 44              mg/l      0.00            mg/l     <NA>
#> 45              mg/l      0.02            mg/l     MISS
#> 46              mg/l      0.00            mg/l     <NA>
#> 47             deg C      0.00           deg C     <NA>
#> 48             deg C      0.00           deg C     <NA>
#> 49             deg C      0.00           deg C     <NA>
#> 50             deg C      0.00           deg C     <NA>
#> 51             deg C      0.00           deg C     <NA>
#> 52             deg C      0.00           deg C     <NA>
#> 53             deg C      0.00           deg C     <NA>
#> 54             deg C      0.00           deg C     <NA>
#> 55             deg C      0.00           deg C     <NA>
#> 56             deg C      0.00           deg C     <NA>
#> 57             deg C      0.00           deg C     <NA>
#> 
#> $`Lab Duplicates`
#>         Parameter       Date Sample ID Initial Result Initial Units Dup. Result
#> 1         Ammonia 2022-05-15      <NA>           0.21          mg/l        0.21
#> 2         Ammonia 2022-05-15      <NA>             NA           BDL          NA
#> 3         Ammonia 2022-06-12      <NA>           0.10          mg/l        0.10
#> 4         Ammonia 2022-06-12      <NA>           0.19          mg/l        0.19
#> 5         Ammonia 2022-07-17      <NA>             NA           BDL          NA
#> 6         Ammonia 2022-07-17      <NA>             NA           BDL          NA
#> 7         Ammonia 2022-08-14      <NA>             NA           BDL          NA
#> 8         Ammonia 2022-08-14      <NA>             NA           BDL          NA
#> 9         Ammonia 2022-09-11      <NA>             NA           BDL          NA
#> 10        Ammonia 2022-09-11      <NA>             NA           BDL          NA
#> 11         E.coli 2022-06-13      <NA>         547.50     MPN/100ml      579.40
#> 12         E.coli 2022-07-18      <NA>          88.00     MPN/100ml      167.00
#> 13         E.coli 2022-08-01      <NA>         114.50     MPN/100ml      160.70
#> 14         E.coli 2022-08-29      <NA>          42.80     MPN/100ml       40.40
#> 15        Nitrate 2022-05-15      <NA>           0.37          mg/l        0.38
#> 16        Nitrate 2022-06-12      <NA>           0.17          mg/l        0.17
#> 17        Nitrate 2022-06-12      <NA>           3.65          mg/l        3.63
#> 18        Nitrate 2022-06-12      <NA>             NA           BDL          NA
#> 19        Nitrate 2022-07-17      <NA>           1.29          mg/l        1.29
#> 20        Nitrate 2022-07-17      <NA>             NA           BDL          NA
#> 21        Nitrate 2022-07-17      <NA>             NA           BDL          NA
#> 22        Nitrate 2022-08-14      <NA>           2.69          mg/l        2.69
#> 23        Nitrate 2022-08-14      <NA>           5.22          mg/l        5.24
#> 24        Nitrate 2022-09-11      <NA>           1.51          mg/l        1.50
#> 25             pH 2022-05-15      <NA>           7.11          s.u.        7.09
#> 26             pH 2022-05-15      <NA>           7.18          s.u.        7.09
#> 27             pH 2022-05-15      <NA>           7.19          s.u.        7.09
#> 28             pH 2022-06-12      <NA>           7.12          s.u.        7.19
#> 29             pH 2022-06-12      <NA>           7.13          s.u.        7.19
#> 30             pH 2022-06-12      <NA>           7.21          s.u.        7.19
#> 31             pH 2022-06-12      <NA>           7.27          s.u.        7.19
#> 32             pH 2022-07-17      <NA>           7.48          s.u.        7.37
#> 33             pH 2022-07-17      <NA>           7.54          s.u.        7.37
#> 34             pH 2022-07-17      <NA>           7.54          s.u.        7.37
#> 35             pH 2022-07-17      <NA>           7.54          s.u.        7.37
#> 36             pH 2022-08-14      <NA>           7.64          s.u.        7.32
#> 37             pH 2022-08-14      <NA>           7.65          s.u.        7.32
#> 38             pH 2022-08-14      <NA>           7.68          s.u.        7.32
#> 39             pH 2022-09-11      <NA>           7.07          s.u.        6.74
#> 40             pH 2022-09-11      <NA>           7.16          s.u.        6.74
#> 41             pH 2022-09-11      <NA>           7.34          s.u.        6.74
#> 42 Sp Conductance 2022-05-15      <NA>         599.00         uS/cm      609.00
#> 43 Sp Conductance 2022-05-15      <NA>         605.00         uS/cm      609.00
#> 44 Sp Conductance 2022-05-15      <NA>         606.00         uS/cm      609.00
#> 45 Sp Conductance 2022-06-12      <NA>         600.00         uS/cm      608.00
#> 46 Sp Conductance 2022-06-12      <NA>         602.00         uS/cm      608.00
#> 47 Sp Conductance 2022-06-12      <NA>         606.00         uS/cm      608.00
#> 48 Sp Conductance 2022-07-17      <NA>         793.00         uS/cm      802.00
#> 49 Sp Conductance 2022-07-17      <NA>         900.00         uS/cm      802.00
#> 50 Sp Conductance 2022-07-17      <NA>         796.00         uS/cm      802.00
#> 51 Sp Conductance 2022-07-17      <NA>         801.00         uS/cm      802.00
#> 52 Sp Conductance 2022-08-14      <NA>        1062.00         uS/cm     1066.00
#> 53 Sp Conductance 2022-08-14      <NA>        1062.00         uS/cm     1066.00
#> 54 Sp Conductance 2022-08-14      <NA>        1063.00         uS/cm     1066.00
#> 55 Sp Conductance 2022-08-14      <NA>        1065.00         uS/cm     1066.00
#> 56 Sp Conductance 2022-09-11      <NA>         761.00         uS/cm      766.00
#> 57 Sp Conductance 2022-09-11      <NA>         765.00         uS/cm      766.00
#> 58 Sp Conductance 2022-09-11      <NA>         774.00         uS/cm      766.00
#> 59             TP 2022-05-15      <NA>           0.01          mg/l        0.01
#> 60             TP 2022-05-15      <NA>           0.03          mg/l        0.02
#> 61             TP 2022-05-15      <NA>           0.06          mg/l        0.06
#> 62             TP 2022-06-12      <NA>           0.04          mg/l        0.04
#> 63             TP 2022-06-12      <NA>           0.04          mg/l        0.04
#> 64             TP 2022-06-12      <NA>           0.06          mg/l        0.06
#> 65             TP 2022-06-12      <NA>             NA           BDL          NA
#> 66             TP 2022-07-17      <NA>           0.04          mg/l        0.04
#> 67             TP 2022-07-17      <NA>           0.05          mg/l        0.05
#> 68             TP 2022-07-17      <NA>             NA           BDL          NA
#> 69             TP 2022-08-14      <NA>           0.03          mg/l        0.03
#> 70             TP 2022-08-14      <NA>           0.05          mg/l        0.05
#> 71             TP 2022-08-14      <NA>           0.09          mg/l        0.09
#> 72             TP 2022-09-11      <NA>           0.04          mg/l        0.04
#> 73             TP 2022-09-11      <NA>           0.04          mg/l        0.04
#> 74             TP 2022-09-11      <NA>           0.05          mg/l        0.05
#> 75     Water Temp 2022-05-15      <NA>          21.70         deg C       21.80
#> 76     Water Temp 2022-05-15      <NA>          21.80         deg C       21.80
#> 77     Water Temp 2022-05-15      <NA>          21.80         deg C       21.80
#> 78     Water Temp 2022-06-12      <NA>          20.20         deg C       20.20
#> 79     Water Temp 2022-06-12      <NA>          20.20         deg C       20.20
#> 80     Water Temp 2022-06-12      <NA>          20.30         deg C       20.20
#> 81     Water Temp 2022-06-12      <NA>          20.30         deg C       20.20
#> 82     Water Temp 2022-07-17      <NA>          23.00         deg C       22.90
#> 83     Water Temp 2022-07-17      <NA>          23.00         deg C       22.90
#> 84     Water Temp 2022-07-17      <NA>          23.10         deg C       22.90
#> 85     Water Temp 2022-08-14      <NA>          20.80         deg C       20.70
#> 86     Water Temp 2022-08-14      <NA>          20.80         deg C       20.70
#> 87     Water Temp 2022-08-14      <NA>          20.90         deg C       20.70
#> 88     Water Temp 2022-08-14      <NA>          20.90         deg C       20.70
#> 89     Water Temp 2022-09-11      <NA>          20.60         deg C       20.50
#> 90     Water Temp 2022-09-11      <NA>          20.70         deg C       20.50
#> 91     Water Temp 2022-09-11      <NA>          20.70         deg C       20.50
#>    Dup. Result Units Diff./RPD Diff./RPD Units Hit/Miss
#> 1               mg/l      0.00             RPD     <NA>
#> 2                BDL      0.00             RPD     <NA>
#> 3               mg/l      0.00             RPD     <NA>
#> 4               mg/l      0.00             RPD     <NA>
#> 5                BDL      0.00             RPD     <NA>
#> 6                BDL      0.00             RPD     <NA>
#> 7                BDL      0.00             RPD     <NA>
#> 8                BDL      0.00             RPD     <NA>
#> 9                BDL      0.00             RPD     <NA>
#> 10               BDL      0.00             RPD     <NA>
#> 11         MPN/100ml      1.00          logRPD     <NA>
#> 12         MPN/100ml     13.00          logRPD     <NA>
#> 13         MPN/100ml      7.00          logRPD     <NA>
#> 14         MPN/100ml      2.00          logRPD     <NA>
#> 15              mg/l      3.00             RPD     <NA>
#> 16              mg/l      0.00             RPD     <NA>
#> 17              mg/l      1.00             RPD     <NA>
#> 18               BDL      0.00             RPD     <NA>
#> 19              mg/l      0.00             RPD     <NA>
#> 20               BDL      0.00             RPD     <NA>
#> 21               BDL      0.00             RPD     <NA>
#> 22              mg/l      0.00             RPD     <NA>
#> 23              mg/l      0.00             RPD     <NA>
#> 24              mg/l      1.00             RPD     <NA>
#> 25              s.u.      0.02            s.u.     <NA>
#> 26              s.u.      0.09            s.u.     <NA>
#> 27              s.u.      0.10            s.u.     <NA>
#> 28              s.u.      0.07            s.u.     <NA>
#> 29              s.u.      0.06            s.u.     <NA>
#> 30              s.u.      0.02            s.u.     <NA>
#> 31              s.u.      0.08            s.u.     <NA>
#> 32              s.u.      0.11            s.u.     <NA>
#> 33              s.u.      0.17            s.u.     <NA>
#> 34              s.u.      0.17            s.u.     <NA>
#> 35              s.u.      0.17            s.u.     <NA>
#> 36              s.u.      0.32            s.u.     <NA>
#> 37              s.u.      0.33            s.u.     <NA>
#> 38              s.u.      0.36            s.u.     <NA>
#> 39              s.u.      0.33            s.u.     <NA>
#> 40              s.u.      0.42            s.u.     <NA>
#> 41              s.u.      0.60            s.u.     MISS
#> 42             uS/cm      2.00             RPD     <NA>
#> 43             uS/cm      1.00             RPD     <NA>
#> 44             uS/cm      0.00             RPD     <NA>
#> 45             uS/cm      1.00             RPD     <NA>
#> 46             uS/cm      1.00             RPD     <NA>
#> 47             uS/cm      0.00             RPD     <NA>
#> 48             uS/cm      1.00             RPD     <NA>
#> 49             uS/cm     12.00             RPD     <NA>
#> 50             uS/cm      1.00             RPD     <NA>
#> 51             uS/cm      0.00             RPD     <NA>
#> 52             uS/cm      0.00             RPD     <NA>
#> 53             uS/cm      0.00             RPD     <NA>
#> 54             uS/cm      0.00             RPD     <NA>
#> 55             uS/cm      0.00             RPD     <NA>
#> 56             uS/cm      1.00             RPD     <NA>
#> 57             uS/cm      0.00             RPD     <NA>
#> 58             uS/cm      1.00             RPD     <NA>
#> 59              mg/l      0.00            mg/l     <NA>
#> 60              mg/l      0.01            mg/l     <NA>
#> 61              mg/l      0.00             RPD     <NA>
#> 62              mg/l      0.00            mg/l     <NA>
#> 63              mg/l      0.00            mg/l     <NA>
#> 64              mg/l      0.00             RPD     <NA>
#> 65               BDL      0.00            mg/l     <NA>
#> 66              mg/l      0.00            mg/l     <NA>
#> 67              mg/l      0.00             RPD     <NA>
#> 68               BDL      0.00            mg/l     <NA>
#> 69              mg/l      0.00            mg/l     <NA>
#> 70              mg/l      0.00             RPD     <NA>
#> 71              mg/l      0.00             RPD     <NA>
#> 72              mg/l      0.00            mg/l     <NA>
#> 73              mg/l      0.00            mg/l     <NA>
#> 74              mg/l      0.00             RPD     <NA>
#> 75             deg C      0.10           deg C     <NA>
#> 76             deg C      0.00           deg C     <NA>
#> 77             deg C      0.00           deg C     <NA>
#> 78             deg C      0.00           deg C     <NA>
#> 79             deg C      0.00           deg C     <NA>
#> 80             deg C      0.10           deg C     <NA>
#> 81             deg C      0.10           deg C     <NA>
#> 82             deg C      0.10           deg C     <NA>
#> 83             deg C      0.10           deg C     <NA>
#> 84             deg C      0.20           deg C     <NA>
#> 85             deg C      0.10           deg C     <NA>
#> 86             deg C      0.10           deg C     <NA>
#> 87             deg C      0.20           deg C     <NA>
#> 88             deg C      0.20           deg C     <NA>
#> 89             deg C      0.10           deg C     <NA>
#> 90             deg C      0.20           deg C     <NA>
#> 91             deg C      0.20           deg C     <NA>
#> 
#> $`Field Blanks`
#>    Parameter       Date Site Result Result Units Threshold Threshold Units
#> 1    Ammonia 2022-05-15 <NA>     NA          BDL      0.10            mg/l
#> 2    Ammonia 2022-06-12 <NA>     NA          BDL      0.10            mg/l
#> 3    Ammonia 2022-07-17 <NA>     NA          BDL      0.10            mg/l
#> 4    Ammonia 2022-07-17 <NA>     NA          BDL      0.10            mg/l
#> 5    Ammonia 2022-08-14 <NA>     NA          BDL      0.10            mg/l
#> 6    Ammonia 2022-08-14 <NA>     NA          BDL      0.10            mg/l
#> 7    Ammonia 2022-09-11 <NA>     NA          BDL      0.10            mg/l
#> 8     E.coli 2022-06-13 <NA>     NA          BDL      1.00       MPN/100ml
#> 9     E.coli 2022-07-18 <NA>     NA          BDL      1.00       MPN/100ml
#> 10    E.coli 2022-08-01 <NA>     NA          BDL      1.00       MPN/100ml
#> 11    E.coli 2022-08-29 <NA>     NA          BDL      1.00       MPN/100ml
#> 12   Nitrate 2022-05-15 <NA>     NA          BDL      0.05            mg/l
#> 13   Nitrate 2022-06-12 <NA>     NA          BDL      0.05            mg/l
#> 14   Nitrate 2022-06-12 <NA>     NA          BDL      0.05            mg/l
#> 15   Nitrate 2022-07-17 <NA>     NA          BDL      0.05            mg/l
#> 16   Nitrate 2022-07-17 <NA>     NA          BDL      0.05            mg/l
#> 17   Nitrate 2022-08-14 <NA>     NA          BDL      0.05            mg/l
#> 18   Nitrate 2022-09-11 <NA>     NA          BDL      0.05            mg/l
#> 19        TP 2022-05-15 <NA>     NA          BDL      0.01            mg/l
#> 20        TP 2022-05-15 <NA>     NA          BDL      0.01            mg/l
#> 21        TP 2022-06-12 <NA>     NA          BDL      0.01            mg/l
#> 22        TP 2022-06-12 <NA>     NA          BDL      0.01            mg/l
#> 23        TP 2022-07-17 <NA>     NA          BDL      0.01            mg/l
#> 24        TP 2022-07-17 <NA>     NA          BDL      0.01            mg/l
#> 25        TP 2022-07-17 <NA>   0.01         mg/l      0.01            mg/l
#> 26        TP 2022-08-14 <NA>     NA          BDL      0.01            mg/l
#> 27        TP 2022-08-14 <NA>     NA          BDL      0.01            mg/l
#> 28        TP 2022-09-11 <NA>     NA          BDL      0.01            mg/l
#> 29        TP 2022-09-11 <NA>     NA          BDL      0.01            mg/l
#>    Hit/Miss
#> 1      <NA>
#> 2      <NA>
#> 3      <NA>
#> 4      <NA>
#> 5      <NA>
#> 6      <NA>
#> 7      <NA>
#> 8      <NA>
#> 9      <NA>
#> 10     <NA>
#> 11     <NA>
#> 12     <NA>
#> 13     <NA>
#> 14     <NA>
#> 15     <NA>
#> 16     <NA>
#> 17     <NA>
#> 18     <NA>
#> 19     <NA>
#> 20     <NA>
#> 21     <NA>
#> 22     <NA>
#> 23     <NA>
#> 24     <NA>
#> 25     MISS
#> 26     <NA>
#> 27     <NA>
#> 28     <NA>
#> 29     <NA>
#> 
#> $`Lab Blanks`
#>         Parameter       Date Sample ID Result Result Units Threshold
#> 1         Ammonia 2022-05-15      <NA>     NA          BDL      0.10
#> 2         Ammonia 2022-06-12      <NA>     NA          BDL      0.10
#> 3         Ammonia 2022-07-17      <NA>     NA          BDL      0.10
#> 4         Ammonia 2022-07-17      <NA>    0.1         mg/l      0.10
#> 5         Ammonia 2022-08-14      <NA>     NA          BDL      0.10
#> 6         Ammonia 2022-08-14      <NA>     NA          BDL      0.10
#> 7         Ammonia 2022-09-11      <NA>     NA          BDL      0.10
#> 8         Nitrate 2022-05-15      <NA>     NA          BDL      0.05
#> 9         Nitrate 2022-06-12      <NA>     NA          BDL      0.05
#> 10        Nitrate 2022-07-17      <NA>     NA          BDL      0.05
#> 11        Nitrate 2022-08-14      <NA>     NA          BDL      0.05
#> 12        Nitrate 2022-09-11      <NA>     NA          BDL      0.05
#> 13 Sp Conductance 2022-05-15      <NA>    7.0        uS/cm     50.00
#> 14 Sp Conductance 2022-05-15      <NA>    7.4        uS/cm     50.00
#> 15 Sp Conductance 2022-05-15      <NA>    7.7        uS/cm     50.00
#> 16 Sp Conductance 2022-05-15      <NA>    8.6        uS/cm     50.00
#> 17 Sp Conductance 2022-06-12      <NA>    8.9        uS/cm     50.00
#> 18 Sp Conductance 2022-06-12      <NA>    9.0        uS/cm     50.00
#> 19 Sp Conductance 2022-06-12      <NA>   10.1        uS/cm     50.00
#> 20 Sp Conductance 2022-06-12      <NA>   10.9        uS/cm     50.00
#> 21 Sp Conductance 2022-06-12      <NA>   13.0        uS/cm     50.00
#> 22 Sp Conductance 2022-07-17      <NA>    4.0        uS/cm     50.00
#> 23 Sp Conductance 2022-07-17      <NA>    4.0        uS/cm     50.00
#> 24 Sp Conductance 2022-07-17      <NA>    5.8        uS/cm     50.00
#> 25 Sp Conductance 2022-07-17      <NA>    6.0        uS/cm     50.00
#> 26 Sp Conductance 2022-08-14      <NA>    2.5        uS/cm     50.00
#> 27 Sp Conductance 2022-08-14      <NA>    3.0        uS/cm     50.00
#> 28 Sp Conductance 2022-08-14      <NA>   80.0        uS/cm     50.00
#> 29 Sp Conductance 2022-08-14      <NA>    3.9        uS/cm     50.00
#> 30 Sp Conductance 2022-09-11      <NA>    4.0        uS/cm     50.00
#> 31 Sp Conductance 2022-09-11      <NA>    4.1        uS/cm     50.00
#> 32 Sp Conductance 2022-09-11      <NA>    4.7        uS/cm     50.00
#> 33 Sp Conductance 2022-09-11      <NA>    5.9        uS/cm     50.00
#> 34             TP 2022-05-15      <NA>     NA          BDL      0.01
#> 35             TP 2022-06-12      <NA>     NA          BDL      0.01
#> 36             TP 2022-07-17      <NA>     NA          BDL      0.01
#> 37             TP 2022-08-14      <NA>     NA          BDL      0.01
#> 38             TP 2022-09-11      <NA>     NA          BDL      0.01
#>    Threshold Units Hit/Miss
#> 1             mg/l     <NA>
#> 2             mg/l     <NA>
#> 3             mg/l     <NA>
#> 4             mg/l     MISS
#> 5             mg/l     <NA>
#> 6             mg/l     <NA>
#> 7             mg/l     <NA>
#> 8             mg/l     <NA>
#> 9             mg/l     <NA>
#> 10            mg/l     <NA>
#> 11            mg/l     <NA>
#> 12            mg/l     <NA>
#> 13           uS/cm     <NA>
#> 14           uS/cm     <NA>
#> 15           uS/cm     <NA>
#> 16           uS/cm     <NA>
#> 17           uS/cm     <NA>
#> 18           uS/cm     <NA>
#> 19           uS/cm     <NA>
#> 20           uS/cm     <NA>
#> 21           uS/cm     <NA>
#> 22           uS/cm     <NA>
#> 23           uS/cm     <NA>
#> 24           uS/cm     <NA>
#> 25           uS/cm     <NA>
#> 26           uS/cm     <NA>
#> 27           uS/cm     <NA>
#> 28           uS/cm     MISS
#> 29           uS/cm     <NA>
#> 30           uS/cm     <NA>
#> 31           uS/cm     <NA>
#> 32           uS/cm     <NA>
#> 33           uS/cm     <NA>
#> 34            mg/l     <NA>
#> 35            mg/l     <NA>
#> 36            mg/l     <NA>
#> 37            mg/l     <NA>
#> 38            mg/l     <NA>
#> 
#> $`Lab Spikes - Instrument Checks`
#>         Parameter       Date Sample ID Spike/Standard Spike/Standard Units
#> 1         Ammonia 2022-05-15      <NA>         100.00           % recovery
#> 2         Ammonia 2022-06-12      <NA>         100.00           % recovery
#> 3         Ammonia 2022-06-12      <NA>         100.00           % recovery
#> 4         Ammonia 2022-07-17      <NA>         100.00           % recovery
#> 5         Ammonia 2022-07-17      <NA>         100.00           % recovery
#> 6         Ammonia 2022-08-14      <NA>         100.00           % recovery
#> 7         Ammonia 2022-08-14      <NA>         100.00           % recovery
#> 8         Ammonia 2022-09-11      <NA>         100.00           % recovery
#> 9         Ammonia 2022-09-11      <NA>         100.00           % recovery
#> 10        Nitrate 2022-05-15      <NA>         100.00           % recovery
#> 11        Nitrate 2022-06-12      <NA>         100.00           % recovery
#> 12        Nitrate 2022-06-12      <NA>         100.00           % recovery
#> 13        Nitrate 2022-06-12      <NA>         100.00           % recovery
#> 14        Nitrate 2022-07-17      <NA>         100.00           % recovery
#> 15        Nitrate 2022-07-17      <NA>         100.00           % recovery
#> 16        Nitrate 2022-07-17      <NA>         100.00           % recovery
#> 17        Nitrate 2022-08-14      <NA>         100.00           % recovery
#> 18        Nitrate 2022-08-14      <NA>         100.00           % recovery
#> 19        Nitrate 2022-09-11      <NA>         100.00           % recovery
#> 20             pH 2022-05-15      <NA>           7.02                 s.u.
#> 21             pH 2022-05-15      <NA>           7.02                 s.u.
#> 22             pH 2022-05-15      <NA>           7.02                 s.u.
#> 23             pH 2022-05-15      <NA>           7.02                 s.u.
#> 24             pH 2022-06-12      <NA>           7.00                 s.u.
#> 25             pH 2022-06-12      <NA>           7.00                 s.u.
#> 26             pH 2022-06-12      <NA>           7.00                 s.u.
#> 27             pH 2022-06-12      <NA>           7.00                 s.u.
#> 28             pH 2022-06-12      <NA>           7.00                 s.u.
#> 29             pH 2022-07-17      <NA>           7.00                 s.u.
#> 30             pH 2022-07-17      <NA>           7.00                 s.u.
#> 31             pH 2022-07-17      <NA>           7.00                 s.u.
#> 32             pH 2022-07-17      <NA>           7.00                 s.u.
#> 33             pH 2022-07-17      <NA>           7.00                 s.u.
#> 34             pH 2022-08-14      <NA>           7.00                 s.u.
#> 35             pH 2022-08-14      <NA>           7.00                 s.u.
#> 36             pH 2022-08-14      <NA>           7.00                 s.u.
#> 37             pH 2022-09-11      <NA>           7.00                 s.u.
#> 38             pH 2022-09-11      <NA>           7.00                 s.u.
#> 39             pH 2022-09-11      <NA>           7.00                 s.u.
#> 40 Sp Conductance 2022-05-15      <NA>        1000.00                uS/cm
#> 41 Sp Conductance 2022-05-15      <NA>        1000.00                uS/cm
#> 42 Sp Conductance 2022-05-15      <NA>        1000.00                uS/cm
#> 43 Sp Conductance 2022-05-15      <NA>        1000.00                uS/cm
#> 44 Sp Conductance 2022-06-12      <NA>        1000.00                uS/cm
#> 45 Sp Conductance 2022-06-12      <NA>        1000.00                uS/cm
#> 46 Sp Conductance 2022-06-12      <NA>        1000.00                uS/cm
#> 47 Sp Conductance 2022-06-12      <NA>        1000.00                uS/cm
#> 48 Sp Conductance 2022-06-12      <NA>        1000.00                uS/cm
#> 49 Sp Conductance 2022-07-17      <NA>        1000.00                uS/cm
#> 50 Sp Conductance 2022-07-17      <NA>        1000.00                uS/cm
#> 51 Sp Conductance 2022-07-17      <NA>        1000.00                uS/cm
#> 52 Sp Conductance 2022-08-14      <NA>        1000.00                uS/cm
#> 53 Sp Conductance 2022-08-14      <NA>        1000.00                uS/cm
#> 54 Sp Conductance 2022-08-14      <NA>        1000.00                uS/cm
#> 55 Sp Conductance 2022-08-14      <NA>        1000.00                uS/cm
#> 56 Sp Conductance 2022-08-14      <NA>        1000.00                uS/cm
#> 57 Sp Conductance 2022-09-11      <NA>        1000.00                uS/cm
#> 58 Sp Conductance 2022-09-11      <NA>        1000.00                uS/cm
#> 59 Sp Conductance 2022-09-11      <NA>        1000.00                uS/cm
#> 60 Sp Conductance 2022-09-11      <NA>        1000.00                uS/cm
#> 61             TP 2022-05-15      <NA>         100.00           % recovery
#> 62             TP 2022-05-15      <NA>         100.00           % recovery
#> 63             TP 2022-05-15      <NA>         100.00           % recovery
#> 64             TP 2022-06-12      <NA>         100.00           % recovery
#> 65             TP 2022-06-12      <NA>         100.00           % recovery
#> 66             TP 2022-06-12      <NA>         100.00           % recovery
#> 67             TP 2022-07-17      <NA>         100.00           % recovery
#> 68             TP 2022-07-17      <NA>         100.00           % recovery
#> 69             TP 2022-07-17      <NA>         100.00           % recovery
#> 70             TP 2022-08-14      <NA>         100.00           % recovery
#> 71             TP 2022-08-14      <NA>         100.00           % recovery
#> 72             TP 2022-08-14      <NA>         100.00           % recovery
#> 73             TP 2022-09-11      <NA>         100.00           % recovery
#> 74             TP 2022-09-11      <NA>         100.00           % recovery
#> 75             TP 2022-09-11      <NA>         100.00           % recovery
#> 76     Water Temp 2022-05-15      <NA>          21.80                deg C
#> 77     Water Temp 2022-05-15      <NA>          21.80                deg C
#> 78     Water Temp 2022-05-15      <NA>          21.80                deg C
#> 79     Water Temp 2022-05-15      <NA>          21.80                deg C
#> 80     Water Temp 2022-06-12      <NA>          22.50                deg C
#> 81     Water Temp 2022-06-12      <NA>          22.50                deg C
#> 82     Water Temp 2022-06-12      <NA>          22.50                deg C
#> 83     Water Temp 2022-07-17      <NA>          22.70                deg C
#> 84     Water Temp 2022-07-17      <NA>          22.70                deg C
#> 85     Water Temp 2022-07-17      <NA>          22.70                deg C
#> 86     Water Temp 2022-07-17      <NA>          22.70                deg C
#> 87     Water Temp 2022-07-17      <NA>          22.70                deg C
#> 88     Water Temp 2022-08-14      <NA>          23.10                deg C
#> 89     Water Temp 2022-08-14      <NA>          23.10                deg C
#> 90     Water Temp 2022-08-14      <NA>          23.10                deg C
#> 91     Water Temp 2022-09-11      <NA>          22.80                deg C
#> 92     Water Temp 2022-09-11      <NA>          22.80                deg C
#> 93     Water Temp 2022-09-11      <NA>          22.80                deg C
#> 94     Water Temp 2022-09-11      <NA>          22.80                deg C
#>    Result Result Units Diff./Accuracy Diff./Accuracy Units Hit/Miss
#> 1   86.00   % recovery          86.00                    %     <NA>
#> 2   94.00   % recovery          94.00                    %     <NA>
#> 3  106.00   % recovery         106.00                    %     <NA>
#> 4   92.00   % recovery          92.00                    %     <NA>
#> 5  108.00   % recovery         108.00                    %     <NA>
#> 6   96.00   % recovery          96.00                    %     <NA>
#> 7  102.00   % recovery         102.00                    %     <NA>
#> 8   88.00   % recovery          88.00                    %     <NA>
#> 9   89.00   % recovery          89.00                    %     <NA>
#> 10  99.00   % recovery          99.00                    %     <NA>
#> 11  95.00   % recovery          95.00                    %     <NA>
#> 12  97.00   % recovery          97.00                    %     <NA>
#> 13 105.00   % recovery         105.00                    %     <NA>
#> 14  99.00   % recovery          99.00                    %     <NA>
#> 15 101.00   % recovery         101.00                    %     <NA>
#> 16 125.00   % recovery         125.00                    %     MISS
#> 17 103.00   % recovery         103.00                    %     <NA>
#> 18 109.00   % recovery         109.00                    %     <NA>
#> 19 101.00   % recovery         101.00                    %     <NA>
#> 20   7.00         s.u.          -0.02                 s.u.     <NA>
#> 21   7.03         s.u.           0.01                 s.u.     <NA>
#> 22   7.09         s.u.           0.07                 s.u.     <NA>
#> 23   7.11         s.u.           0.09                 s.u.     <NA>
#> 24   7.01         s.u.           0.01                 s.u.     <NA>
#> 25   7.05         s.u.           0.05                 s.u.     <NA>
#> 26   7.06         s.u.           0.06                 s.u.     <NA>
#> 27   7.06         s.u.           0.06                 s.u.     <NA>
#> 28   7.07         s.u.           0.07                 s.u.     <NA>
#> 29   7.05         s.u.           0.05                 s.u.     <NA>
#> 30   7.06         s.u.           0.06                 s.u.     <NA>
#> 31   7.06         s.u.           0.06                 s.u.     <NA>
#> 32   7.06         s.u.           0.06                 s.u.     <NA>
#> 33   7.40         s.u.           0.40                 s.u.     MISS
#> 34   6.99         s.u.          -0.01                 s.u.     <NA>
#> 35   7.07         s.u.           0.07                 s.u.     <NA>
#> 36   7.09         s.u.           0.09                 s.u.     <NA>
#> 37   7.01         s.u.           0.01                 s.u.     <NA>
#> 38   7.06         s.u.           0.06                 s.u.     <NA>
#> 39   7.06         s.u.           0.06                 s.u.     <NA>
#> 40 975.00        uS/cm         -25.00                uS/cm     <NA>
#> 41 977.00        uS/cm         -23.00                uS/cm     <NA>
#> 42 985.00        uS/cm         -15.00                uS/cm     <NA>
#> 43 991.00        uS/cm          -9.00                uS/cm     <NA>
#> 44 978.00        uS/cm         -22.00                uS/cm     <NA>
#> 45 979.00        uS/cm         -21.00                uS/cm     <NA>
#> 46 979.00        uS/cm         -21.00                uS/cm     <NA>
#> 47 983.00        uS/cm         -17.00                uS/cm     <NA>
#> 48 987.00        uS/cm         -13.00                uS/cm     <NA>
#> 49 984.00        uS/cm         -16.00                uS/cm     <NA>
#> 50 988.00        uS/cm         -12.00                uS/cm     <NA>
#> 51 997.00        uS/cm          -3.00                uS/cm     <NA>
#> 52 991.00        uS/cm          -9.00                uS/cm     <NA>
#> 53 991.00        uS/cm          -9.00                uS/cm     <NA>
#> 54 992.00        uS/cm          -8.00                uS/cm     <NA>
#> 55 992.00        uS/cm          -8.00                uS/cm     <NA>
#> 56 996.00        uS/cm          -4.00                uS/cm     <NA>
#> 57 986.00        uS/cm         -14.00                uS/cm     <NA>
#> 58 989.00        uS/cm         -11.00                uS/cm     <NA>
#> 59 990.00        uS/cm         -10.00                uS/cm     <NA>
#> 60 993.00        uS/cm          -7.00                uS/cm     <NA>
#> 61 100.00   % recovery         100.00                    %     <NA>
#> 62 101.00   % recovery         101.00                    %     <NA>
#> 63 103.00   % recovery         103.00                    %     <NA>
#> 64 100.00   % recovery         100.00                    %     <NA>
#> 65 104.00   % recovery         104.00                    %     <NA>
#> 66 104.00   % recovery         104.00                    %     <NA>
#> 67 105.00   % recovery         105.00                    %     <NA>
#> 68 105.00   % recovery         105.00                    %     <NA>
#> 69 110.00   % recovery         110.00                    %     <NA>
#> 70  99.00   % recovery          99.00                    %     <NA>
#> 71  99.00   % recovery          99.00                    %     <NA>
#> 72 101.00   % recovery         101.00                    %     <NA>
#> 73  97.00   % recovery          97.00                    %     <NA>
#> 74  99.00   % recovery          99.00                    %     <NA>
#> 75  99.00   % recovery          99.00                    %     <NA>
#> 76  21.80        deg C           0.00                deg C     <NA>
#> 77  21.80        deg C           0.00                deg C     <NA>
#> 78  21.90        deg C           0.10                deg C     <NA>
#> 79  21.90        deg C           0.10                deg C     <NA>
#> 80  22.60        deg C           0.10                deg C     <NA>
#> 81  22.60        deg C           0.10                deg C     <NA>
#> 82  22.70        deg C           0.20                deg C     <NA>
#> 83  22.60        deg C          -0.10                deg C     <NA>
#> 84  22.70        deg C           0.00                deg C     <NA>
#> 85  22.70        deg C           0.00                deg C     <NA>
#> 86  25.00        deg C           2.30                deg C     MISS
#> 87  22.90        deg C           0.20                deg C     <NA>
#> 88  23.10        deg C           0.00                deg C     <NA>
#> 89  23.40        deg C           0.30                deg C     <NA>
#> 90  23.40        deg C           0.30                deg C     <NA>
#> 91  22.80        deg C           0.00                deg C     <NA>
#> 92  22.80        deg C           0.00                deg C     <NA>
#> 93  22.90        deg C           0.10                deg C     <NA>
#> 94  23.00        deg C           0.20                deg C     <NA>
#> 
```
