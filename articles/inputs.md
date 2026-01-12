# MassWateR data input and checks

Five types of data are used with the MassWateR package.

1.  Water quality **results** organized by sample location and date.
2.  Summary of data quality objectives that describe quality control
    **accuracy**, **frequency**, and **completeness** measures for data
    in the results file.
3.  A **site metadata** file, including location names, latitude,
    longitude, and additional grouping factors for sites.
4.  A **wqx metadata** file required for generating output to facilitate
    data upload to WQX.
5.  Information on the number of **censored** or missing observations by
    parameter. This is used for the QC report created by
    [`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md),
    specifically for the quality control completeness checks in the
    table produced by
    [`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md).

Templates with instructions for each of the types of input data are
available for download in the [Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html).
Additionally, example files, described below, are provided with the
package to demonstrate and test the functions.

Load the package in an R session after installation:

``` r
library(MassWateR)
```

The following shows how to specify a path and import each required data
file. These are hypothetical files and the path will need to be changed
to where your data are located on your computer.

``` r
# import results data
respth <- "C:/Documents/MassWateR/MyResults.xlsx"
resdat <- readMWRresults(respth)

# import dqo accuracy data
accpth <- "C:/Documents/MassWateR/MyDQOAccuracy.xlsx"
accdat <- readMWRacc(accpth)

# import dqo frequency and completeness data
frecompth <- "C:/Documents/MassWateR/MyDQOFreCom.xlsx"
frecomdat <- readMWRfrecom(frecompth)

# import site data
sitpth <- "C:/Documents/MassWateR/MySites.xlsx"
sitdat <- readMWRsites(sitpth)

# import WQX meta data
wqxpth <- "C:/Documents/MassWateR/MyWQXMeta.xlsx"
wqxdat <- readMWRwqx(wqxpth)

# censored data
censpth <- "C:/Documents/MassWateR/MyCensored.xlsx"
censdat <- readMWRcens(censpth)
```

Example files included with the package are imported for demonstration
in this vignette. The paths to these files are identified using the
[`system.file()`](https://rdrr.io/r/base/system.file.html) function and
used in the examples below. In practice, alternative data files that
follow the same format as the examples will be used with the functions
and imported using code similar to above.

**Make sure to close any data files on your desktop before importing
them in MassWateR**. Some operating systems may require the file to be
closed for successful import.

## Data import and checks

The MassWateR package is developed for quality control and exploratory
analysis of surface water quality data. Before these analyses can occur,
the data must be formatted correctly. There are several checks included
in the data import functions to ensure the files are formatted correctly
for downstream use. If any of the checks fail, an error message will be
returned that prompts the necessary changes that must be made to the
Excel file before the data can be used.

For many of the checks, parameter names and units need to match the
following columns in the `paramsMWR` file included with the package.
Specifically parameter names (either `Characteristic Name` in the
results file, or `Parameter` in the data quality objectives files) can
be the simple or WQX format as below. The units can be any that apply
for a given parameter, although only one is allowed per parameter. All
entries are case-sensitive. This file is also available in the
[Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html).

| Simple Parameter      | WQX Parameter                                                  | Units of measure                                             |
|:----------------------|:---------------------------------------------------------------|:-------------------------------------------------------------|
| Air Temp              | Temperature, air                                               | deg C, deg F                                                 |
| Ammonia               | Ammonia                                                        | mg/l, ug/l, umol/l, ppm                                      |
| Ammonium              | Ammonium                                                       | mg/l, ug/l, umol/l, ppm                                      |
| Chl a                 | Chlorophyll a                                                  | mg/l, ug/l, umol/l, ppm                                      |
| Chl a (probe)         | Chlorophyll a (probe)                                          | mg/l, ug/l, umol/l, ppm, RFU                                 |
| Chloride              | Chloride                                                       | mg/l, ug/l, umol/l, ppm                                      |
| Conductivity          | Conductivity                                                   | uS/cm, mS/cm, S/m                                            |
| Cyanobacteria         | Algae, blue-green (phylum cyanophyta) density                  | mg/l, ug/l, umol/l, ppm                                      |
| Cyanobacteria (probe) | Chlorophyll a (probe) concentration, Cyanobacteria (bluegreen) | mg/l, ug/l, umol/l, ppm, RFU                                 |
| Depth                 | Depth                                                          | m, cm, ft                                                    |
| DO                    | Dissolved oxygen (DO)                                          | mg/l, ug/l                                                   |
| DO saturation         | Dissolved oxygen saturation                                    | %                                                            |
| E.coli                | Escherichia coli                                               | cfu/100ml, MPN/100ml, \#/100ml                               |
| Enterococcus          | Enterococcus                                                   | cfu/100ml, MPN/100ml, \#/100ml                               |
| Fecal Coliform        | Fecal Coliform                                                 | cfu/100ml, MPN/100ml, \#/100ml                               |
| Flow                  | Flow                                                           | cfs, cfm, mgd, l/sec, l/min,                                 |
| Gage                  | Height, gage                                                   | m, cm, ft                                                    |
| Metals                | Metals                                                         | mg/l, ug/l, umol/l, ppm                                      |
| Microcystins          | Microcystins                                                   | mg/l, ug/l, umol/l, ppm                                      |
| Nitrate               | Nitrate                                                        | mg/l, ug/l, umol/l, ppm                                      |
| Nitrate + Nitrite     | Nitrate + Nitrite                                              | mg/l, ug/l, umol/l, ppm                                      |
| Nitrite               | Nitrite                                                        | mg/l, ug/l, umol/l, ppm                                      |
| Ortho P               | Orthophosphate                                                 | mg/l, ug/l, umol/l, ppm                                      |
| pH                    | pH                                                             | blank, s.u., None                                            |
| Pheophytin            | Pheophytin a                                                   | mg/l, ug/l, umol/l, ppm                                      |
| Phycocyanin           | Phycocyanin                                                    | mg/l, ug/l, umol/l, ppm                                      |
| Phycocyanin (probe)   | Phycocyanin (probe)                                            | mg/l, ug/l, umol/l, ppm, RFU                                 |
| Phycoerythrin         | Phycoerythrin                                                  | mg/l, ug/l, umol/l, ppm, RFU                                 |
| POC                   | Particulate organic carbon                                     | mg/l, ug/l, umol/l, ppm                                      |
| PON                   | Total Nitrogen, mixed forms                                    | mg/l, ug/l, umol/l, ppm                                      |
| POP                   | Phosphorus, Particulate Organic                                | mg/l, ug/l, umol/l, ppm                                      |
| Salinity              | Salinity                                                       | ppth, PSU, PSS, g/kg, ppt                                    |
| Secchi Depth          | Depth, Secchi disk depth                                       | m, cm, ft                                                    |
| Silicate              | Silicate                                                       | mg/l, ug/l, umol/l, ppm                                      |
| Sp Conductance        | Specific conductance                                           | uS/cm, mS/cm, S/m                                            |
| Sulfate               | Sulfate                                                        | mg/l, ug/l, umol/l, ppm                                      |
| Surfactants           | Surfactants                                                    | mg/l, ug/l, umol/l, ppm                                      |
| TDN                   | Total Nitrogen, mixed forms                                    | mg/l, ug/l, umol/l, ppm                                      |
| TDP                   | Total Phosphorus, mixed forms                                  | mg/l, ug/l, umol/l, ppm                                      |
| TDS                   | Total dissolved solids                                         | mg/l, ug/l, umol/l, ppm                                      |
| TKN                   | Total Kjeldahl nitrogen                                        | mg/l, ug/l, umol/l, ppm                                      |
| TN                    | Total Nitrogen, mixed forms                                    | mg/l, ug/l, umol/l, ppm                                      |
| TP                    | Total Phosphorus, mixed forms                                  | mg/l, ug/l, umol/l, ppm                                      |
| TSS                   | Total suspended solids                                         | mg/l, ug/l, umol/l, ppm                                      |
| Turbidity             | Turbidity                                                      | FTU, FNU, JTU, NTU, AU, BU, FAU, FBU, FNMU, FNRU, NTMU, NTRU |
| Water Temp            | Temperature, water                                             | deg C, deg F                                                 |

The
[`readMWRresultsview()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresultsview.md)
function can be used to help troubleshoot issues that are encountered
importing the water quality results file (next section). This function
can be used to create a .csv spreadsheet that shows the unique values
within columns of the results file. This information can be used to
verify if the values in each conform to the requirements for the data
import checks, including acceptable values for the table above. By
default, a .csv is created for all columns. The `columns` argument can
be used to select columns of interest. Below shows how to view the
unique entries for parameters (`"Characteristic Name"`) and units
(`"Result Unit"`). The .csv is created in the directory specified by
`output_dir`. Visually evaluating the results for conformance to the
package requirements and manually editing the input file can help with
the import checks, described below.

``` r
# find path to the file included with the package, replace with a path to your file as needed
respth <- system.file("extdata/ExampleResults.xlsx", package = "MassWateR")

# create a .csv file for the two columns that show unique values in each
readMWRresultsview(respth, columns = c("Characteristic Name", "Result Unit"), output_dir = tempdir())
```

### Surface water quality results

First, the surface water quality results can be imported with the
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
function. This is designed to import an Excel file external to R, run
checks on the data, and provide some minor formatting for downstream
quality control or exploratory analysis. In this example, the system
file `ExampleResults.xlsx` is imported. In practice, the `pth` argument
will point to an external file in the WQX format. See the [Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html) for the
Excel file template and detailed instructions (in the template’s
instructions worksheet). Note that `runchk = TRUE` is set to run the
checks on data import. This is the default setting and it is not
necessary to explicitly set this argument on import.

``` r
respth <- system.file("extdata/ExampleResults.xlsx", package = "MassWateR")
resdat <- readMWRresults(respth, runchk = TRUE)
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
head(resdat)
#> # A tibble: 6 × 18
#>   `Monitoring Location ID` `Activity Type` `Activity Start Date`
#>   <chr>                    <chr>           <dttm>               
#> 1 ABT-026                  Field Msr/Obs   2022-05-15 00:00:00  
#> 2 ABT-077                  Field Msr/Obs   2022-05-15 00:00:00  
#> 3 ABT-301                  Field Msr/Obs   2022-05-15 00:00:00  
#> 4 ABT-312                  Field Msr/Obs   2022-05-15 00:00:00  
#> 5 DAN-013                  Field Msr/Obs   2022-05-15 00:00:00  
#> 6 ELZ-004                  Field Msr/Obs   2022-05-15 00:00:00  
#> # ℹ 15 more variables: `Activity Start Time` <chr>,
#> #   `Activity Depth/Height Measure` <chr>, `Activity Depth/Height Unit` <chr>,
#> #   `Activity Relative Depth Name` <chr>, `Characteristic Name` <chr>,
#> #   `Result Value` <chr>, `Result Unit` <chr>, `Quantitation Limit` <chr>,
#> #   `QC Reference Value` <chr>, `Result Measure Qualifier` <chr>,
#> #   `Result Attribute` <chr>, `Sample Collection Method ID` <chr>,
#> #   `Project ID` <chr>, `Local Record ID` <chr>, `Result Comment` <chr>
```

Several checks are run automatically when the data are imported. These
file checks are as follows (also viewed from the help file for
[`checkMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)):

- **Column name spelling**: Should be the following: Monitoring Location
  ID, Activity Type, Activity Start Date, Activity Start Time, Activity
  Depth/Height Measure, Activity Depth/Height Unit, Activity Relative
  Depth Name, Characteristic Name, Result Value, Result Unit,
  Quantitation Limit, QC Reference Value, Result Measure Qualifier,
  Result Attribute, Sample Collection Method ID, Project ID, Local
  Record ID, Result Comment
- **Columns present**: All columns from the previous should be present
- **Activity Type**: Should be one of Field Msr/Obs, Sample-Routine,
  Quality Control Sample-Field Blank, Quality Control Sample-Lab Blank,
  Quality Control Sample-Lab Duplicate, Quality Control Sample-Lab
  Spike, Quality Control-Calibration Check, Quality Control-Meter Lab
  Duplicate, Quality Control-Meter Lab Blank
- **Date formats**: Should be mm/dd/yyyy and parsed correctly on import
- **Depth data present**: Depth data should be included in
  `Activity Depth/Height Measure` or `Activity Relative Depth Name` for
  all rows where `Activity Type` is Field Msr/Obs or Sample-Routine
- **Non-numeric Activity Depth/Height Measure**: All depth values should
  be numbers, excluding missing values
- **Activity Depth/Height Unit**: All entries should be `ft`, `m`, or
  blank
- **Activity Relative Depth Name**: Should be either Surface, Bottom,
  Midwater, Near Bottom, or blank (warning only)
- **Activity Depth/Height Measure out of range**: All depth values
  should be less than or equal to 1 meter / 3.3 feet or entered as
  Surface in the Activity Relative Depth Name column (warning only)
- **Characteristic Name**: Should match parameter names in the
  `Simple Parameter` or `WQX Parameter` column of the `paramsMWR` data
  (warning only)
- **Result Value**: Should be a numeric value or a text value as AQL or
  BDL
- **Non-numeric Quantitation Limit**: All values should be numbers,
  excluding missing values
- **QC Reference Value**: Any entered values should be numeric or a text
  value as AQL or BDL
- **Result Unit**: No missing entries in `Result Unit`, except pH which
  can be blank
- **Single Result Unit**: Each unique parameter in `Characteristic Name`
  should have only one entry in `Result Unit` (excludes entries for lab
  spikes reported as `%` or `% recovery`)
- **Correct Result Unit**: Each unique parameter in
  `Characteristic Name` should have an entry in `Result Unit` that
  matches one of the acceptable values in the `Units of measure` column
  of the `paramsMWR` data (excludes entries for lab spikes reported as
  `%` or `% recovery`), see the table above.

An informative error is returned if the input data fail any of the
checks. The input data should be corrected by hand in the Excel file by
altering the appropriate rows or column names indicated in the error.
Checks with warnings can be fixed at the discretion of the user before
proceeding.

Here is an example of an error that might be returned for an incorrect
data entry (using the
[`checkMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)
function, which is used inside of
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)).
To remedy the issue, change the entries in rows 4 and 135 in the
Activity Type column to Sample-Routine and Field Msr/Obs, respectively.
This must be done in the original Excel file. Import the data again in R
to verify the data are corrected.

``` r
chk <- resdat
chk[4, 2] <- "Sample"
chk[135, 2] <- "Field"
checkMWRresults(chk)
#> Running checks on results data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#> Error:
#> !  Checking valid Activity Types...
#>  Incorrect Activity Type found: Sample, Field in row(s) 4, 135
```

Data imported with
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
are also formatted to address a few minor issues for downstream
analysis. This formatting includes:

- **Fix date and time inputs**: Activity Start Date is converted to
  YYYY-MM-DD as a date object, Activity Start Time is converted to HH:MM
  as a character to fix artifacts from Excel import.
- **Minor formatting for Result Unit**: For conformance to WQX, e.g.,
  ppt is changed to ppth, s.u. is changed to `NA`.
- **Convert characteristic names**: All parameters in
  `Characteristic Name` are converted to `Simple Parameter` in
  `paramsMWR` as needed.

A few other points about the `Activity Type` column are worth
mentioning. As noted in the list above, the package uses specific
activity types for data organization. *Sample-Routine* should be used
for collected water samples. *Field Msr/Obs* should be used for in-situ
measurements. The rest of the activity types are all for QC data. The
input file should only contain the activity types in the Input Activity
Type column below. The WQX output that is generated by the package will
create extra rows with the activity types in the second column below.
The new WQX output rows will take the value from the
`QC Reference Value` column as their `Result Value`. Please view the
[Water Quality Exchange
output](https://massbays-tech.github.io/MassWateR/articles/wqx.html)
vignette for a complete description of creating output for WQX upload
with MassWateR.

| Input Activity Type                  | WQX output new row Activity Type         |
|--------------------------------------|------------------------------------------|
| Sample-Routine                       | Quality Control Sample-Field Replicate   |
| Quality Control Sample-Field Blank   | NA                                       |
| Quality Control Sample-Lab Duplicate | Quality Control Sample-Lab Duplicate 2   |
| Quality Control Sample-Lab Blank     | NA                                       |
| Quality Control Sample-Lab Spike     | Quality Control Sample-Lab Spike Target  |
| Field Msr/Obs                        | Quality Control Field Replicate Msr/Obs  |
| Quality Control-Meter Lab Duplicate  | Quality Control-Meter Lab Duplicate 2    |
| Quality Control-Meter Lab Blank      | NA                                       |
| Quality Control-Calibration Check    | Quality Control-Calibration Check Buffer |

### Data quality objectives

To use the quality control functions in MassWateR, Excel files that
describe the data quality objectives for accuracy, frequency, and
completeness must be provided. The system files included with the
package, described above, demonstrate the required information and
format for these files. They can be imported into R using the
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
and
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)
functions for the accuracy, frequency, and completeness files. The `pth`
argument will point to the location of the external files on your
computer. See the [Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html) for the
Excel file template and detailed instructions (in the template’s
instructions worksheet). As above, the system files included with the
package are used for the examples.

``` r
# import data quality objectives for accuracy
accpth <- system.file("extdata/ExampleDQOAccuracy.xlsx", package = "MassWateR")
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
head(accdat)
#> # A tibble: 6 × 10
#>   Parameter    uom     MDL   UQL `Value Range` `Field Duplicate` `Lab Duplicate`
#>   <chr>        <chr> <dbl> <dbl> <chr>         <chr>             <chr>          
#> 1 Water Temp   deg C    NA    NA all           <= 1.0            <= 1.0         
#> 2 pH           NA       NA    NA all           <= 0.5            <= 0.5         
#> 3 DO           mg/l     NA    NA < 4           < 20%             NA             
#> 4 DO           mg/l     NA    NA >= 4          < 10%             NA             
#> 5 Sp Conducta… uS/cm    NA    NA < 250         < 30%             < 30%          
#> 6 Sp Conducta… uS/cm    NA 10000 >= 250        < 20%             < 20%          
#> # ℹ 3 more variables: `Field Blank` <chr>, `Lab Blank` <chr>,
#> #   `Spike/Check Accuracy` <chr>
```

``` r
# import data quality objectives for frequency and completeness
frecompth <- system.file("extdata/ExampleDQOFrequencyCompleteness.xlsx", package = "MassWateR")
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
head(frecomdat)
#> # A tibble: 6 × 7
#>   Parameter      `Field Duplicate` `Lab Duplicate` `Field Blank` `Lab Blank`
#>   <chr>                      <dbl>           <dbl>         <dbl>       <dbl>
#> 1 Water Temp                    10              10            NA          NA
#> 2 pH                            10              10            NA          NA
#> 3 DO                            10              NA            NA          NA
#> 4 Sp Conductance                10              10            NA          10
#> 5 TP                            10               5            10           5
#> 6 Nitrate                       10               5            10           5
#> # ℹ 2 more variables: `Spike/Check Accuracy` <dbl>, `% Completeness` <dbl>
```

Both the
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
and
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)
functions will run a series of checks to ensure the imported data are
formatted correctly. The
[`checkMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)
and
[`checkMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md)
functions run these checks when the
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
and
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)
functions are executed, respectively. The checks for each are as
follows.

File checks for accuracy:

- **Column name spelling**: Should be the following: Parameter, uom,
  MDL, UQL, Value Range, Field Duplicate, Lab Duplicate, Field Blank,
  Lab Blank, Spike/Check Accuracy
- **Columns present**: All columns from the previous check should be
  present
- **Column types**: All columns should be characters/text, except for
  MDL and UQL
- **`Value Range` column na check**: The character string `"na"` should
  not be in the `Value Range` column, `"all"` should be used if the
  entire range applies
- **Unrecognized characters**: Fields describing accuracy checks should
  not include symbols or text other than $< =$, $\leq$, $<$, $> =$,
  $\geq$, $>$, $\pm$`"\%"`, `"BDL"`, `"AQL"`, `"log"`, or `"all"`
- **Overlap in `Value Range` column**: Entries in `Value Range` should
  not overlap for a parameter (excludes ascending ranges)
- **Gap in `Value Range` column**: Entries in `Value Range` should not
  include a gap for a parameter, warning only
- **Parameter**: Should match parameter names in the `Simple Parameter`
  or `WQX Parameter` columns of the `paramsMWR` data
- **Units**: No missing entries in units (`uom`), except pH which can be
  blank
- **Single unit**: Each unique `Parameter` should have only one type for
  the units (`uom`)
- **Correct units**: Each unique `Parameter` should have an entry in the
  units (`uom`) that matches one of the acceptable values in the
  `Units of measure` column of the `paramsMWR` data, see the table
  above.
- **Empty columns**: Columns with all missing or `NA` values will return
  a warning

File checks for frequency and completeness:

- **Column name spelling**: Should be the following: Parameter, Field
  Duplicate, Lab Duplicate, Field Blank, Lab Blank, Spike/Check
  Accuracy, % Completeness
- **Columns present**: All columns from the previous check should be
  present
- **Non-numeric values**: Values entered in columns other than the first
  should be numeric
- **Values outside of 0 - 100**: Values entered in columns other than
  the first should not be outside of 0 and 100
- **Parameter**: Should match parameter names in the `Simple Parameter`
  or `WQX Parameter` columns of the `paramsMWR` data
- **Empty columns**: Columns with all missing or `NA` values will return
  a warning

Minor formatting of the input files is also done to address a few minor
issues for downstream analysis. This formatting includes:

- **Minor formatting for units**: For conformance to WQX, e.g., ppt is
  changed to ppth, s.u. is changed to `NA` for the `uom` column
  ([`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
  only).
- **Convert parameter names**: All parameters in `Parameter` are
  converted to `Simple Parameter` in `paramsMWR` as needed.
- **Remove unicode**: Remove or replace unicode characters with those
  that can be used in logical expressions in
  [`qcMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md),
  e.g., replace $\geq$ with $> =$.
- **Convert limits to numeric**: Convert `MDL` and `UQL` columns in the
  accuracy file to numeric

### Site metadata

An Excel file for site metadata that describes spatial location and any
other grouping factors for the sites in the results file can be imported
using
[`readMWRsites()`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md).
The system file included with the package, described above, demonstrates
the required information and format for the file. The `pth` argument
will point to the location of the external file on your computer. See
the [Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html) for the
Excel file template. As above, the system file included with the package
is used for the example.

``` r
# import site metadata
sitpth <- system.file("extdata/ExampleSites.xlsx", package = "MassWateR")
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
head(sitdat)
#> # A tibble: 6 × 5
#>   `Monitoring Location ID` `Monitoring Location Name` Monitoring Location Lati…¹
#>   <chr>                    <chr>                                           <dbl>
#> 1 ABT-026                  Rte 2, Concord                                   42.5
#> 2 ABT-062                  Rte 62, Acton                                    42.4
#> 3 ABT-077                  Rte 27/USGS, Maynard                             42.4
#> 4 ABT-144                  Rte 62, Stow                                     42.4
#> 5 ABT-162                  Cox Street bridge                                42.4
#> 6 ABT-237                  Robin Hill Rd, Marlboro                          42.3
#> # ℹ abbreviated name: ¹​`Monitoring Location Latitude`
#> # ℹ 2 more variables: `Monitoring Location Longitude` <dbl>,
#> #   `Location Group` <chr>
```

The
[`readMWRsites()`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md)
function runs several checks on the file using the
[`checkMWRsites()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md)
function. Most of the checks are to ensure the latitude and longitude
data are present and properly formatted. It is assumed that latitude and
longitude data are entered in decimal degrees. The projection can be
entered in other functions used in exploratory analysis. Details on the
file checks are as follows:

- **Column name spelling**: Should be the following: Monitoring Location
  ID, Monitoring Location Name, Monitoring Location Latitude, Monitoring
  Location Longitude, Location Group
- **Columns present**: All columns from the previous check should be
  present
- **Missing longitude or latitude**: No missing entries in Monitoring
  Location Latitude or Monitoring Location Longitude
- **Non-numeric latitude values**: Values entered in Monitoring Location
  Latitude must be numeric
- **Non-numeric longitude values**: Values entered in Monitoring
  Location Longitude must be numeric
- **Positive longitude values**: Values in Monitoring Location Longitude
  must be negative
- **Missing Location ID**: No missing entries for Monitoring Location ID

### WQX metadata

An Excel file for wqx metadata that is required to generate output for
upload to WQX can be imported using
[`readMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md).
The system file included with the package, described above, demonstrates
the required information and format for the file. The `pth` argument
will point to the location of the external file on your computer. See
the [Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html) for the
Excel file template and detailed instructions (in the template’s
instructions worksheet). As above, the system file included with the
package is used for the example.

``` r
# import wqx metadata
wqxpth <- system.file("extdata/ExampleWQX.xlsx", package = "MassWateR")
wqxdat <- readMWRwqx(wqxpth)
#> Running checks on WQX metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking unique parameters... OK
#>  Checking Parameter formats... OK
#> 
#> All checks passed!
head(wqxdat)
#> # A tibble: 6 × 6
#>   Parameter    Sampling Method Cont…¹ `Method Speciation` Result Sample Fracti…²
#>   <chr>        <chr>                  <chr>               <chr>                 
#> 1 Water Temp   NA                     NA                  NA                    
#> 2 pH           NA                     NA                  NA                    
#> 3 DO           NA                     NA                  NA                    
#> 4 Sp Conducta… NA                     NA                  NA                    
#> 5 TP           MassWateR              as P                Unfiltered            
#> 6 Nitrate      MassWateR              as N                Unfiltered            
#> # ℹ abbreviated names: ¹​`Sampling Method Context`, ²​`Result Sample Fraction`
#> # ℹ 2 more variables: `Analytical Method` <chr>,
#> #   `Analytical Method Context` <chr>
```

The
[`readMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md)
function runs a few checks on the file using the
[`checkMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRwqx.md)
function. Details on the file checks are as follows:

- **Column name spelling**: Should be the following: Parameter, Sampling
  Method Context, Method Speciation, Result Sample Fraction, Analytical
  Method, Analytical Method Context.
- **Columns present**: All columns from the previous should be present
- **Unique parameters**: Values in `Parameter` should be unique (no
  duplicates)
- **Parameter**: Should match parameter names in the `Simple Parameter`
  or `WQX Parameter` column of the `paramsMWR` data (warning only)

An informative error is returned if the input data fail any of the
checks. The input data should be corrected by hand in the Excel file by
altering the appropriate rows or column names indicated in the error.
Checks with warnings can be fixed at the discretion of the user before
proceeding.

### Censored data

An Excel file for the number of missed or censored observations by
parameter is required for use with some of the quality control
functions, specifically
[`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
to generate the QC report and
[`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
to generate the completeness table. The parameters in this file must
match those in the data quality objectives file for frequency and
completeness. The censored data can be imported using the
[`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
function. The system file included with the package, described above,
demonstrates the required information and format for the file. The `pth`
argument will point to the location of the external file on your
computer. See the [Resources
tab](https://massbays-tech.github.io/MassWateR/RESOURCES.html) for the
Excel file template and detailed instructions (in the template’s
instructions worksheet). As above, the system file included with the
package is used for the example.

``` r
# import cens metadata
censpth <- system.file("extdata/ExampleCensored.xlsx", package = "MassWateR")
censdat <- readMWRcens(censpth)
#> Running checks on censored data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for non-numeric or empty values in Missed and Censored Records... OK
#>  Checking for negative values in Missed and Censored Records... OK
#>  Checking Parameter Name formats... OK
#> 
#> All checks passed!
head(censdat)
#> # A tibble: 6 × 2
#>   Parameter      `Missed and Censored Records`
#>   <chr>                                  <int>
#> 1 Water Temp                                 0
#> 2 pH                                        12
#> 3 DO                                         1
#> 4 Sp Conductance                             0
#> 5 TP                                         0
#> 6 Nitrate                                    0
```

The
[`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
function runs a few checks on the file using the
[`checkMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRcens.md)
function. Details on the file checks are as follows:

- **Column name spelling**: Should be the following: Parameter, Missed
  and Censored Records.
- **Columns present**: All columns from the previous should be present
- **Non-numeric or empty entries in Missed and Censored Records**: All
  values should be numbers
- **Negative Missed and Censored Records**: All values should be greater
  than or equal to zero
- **Parameter**: Should match parameter names in the `Simple Parameter`
  or `WQX Parameter` column of the `paramsMWR` data (warning only)

An informative error is returned if the input data fail any of the
checks. The input data should be corrected by hand in the Excel file by
altering the appropriate rows or column names indicated in the error.
Checks with warnings can be fixed at the discretion of the user before
proceeding.

## Using the fset argument

All of the [quality
control](https://massbays-tech.github.io/MassWateR/articles/qcoverview.html),
[outlier](https://massbays-tech.github.io/MassWateR/articles/outlierchecks.html),
[analysis](https://massbays-tech.github.io/MassWateR/articles/analysis.html),
and [wqx](https://massbays-tech.github.io/MassWateR/articles/wqx.html)
functions in MassWateR require the inputs described above, depending on
the function. These are generally passed to each function using the
appropriate arguments, e.g., `res` for the surface water quality
results, `acc` and `frecom` for the data quality objective files for
accuracy, frequency, and completeness, `sit` for the site metadata,
`wqx` for the wqx metadata, and `cens` for the censored data. The values
passed to these functions can be file paths that specify the location of
the file or as data frames returned by the relevant import functions
(i.e.,
[`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
[`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md),
[`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md),
[`readMWRsites()`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md),
[`readMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md),
[`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)).

Because it can be tedious to specify each of the input files in the
arguments for the MassWateR functions, the `fset` (file set) argument
can be used as an alternative method. The `fset` argument for each
function accepts a named list with the relevant input file locations or
data frames. This can be created at the top of a script and recycled as
necessary for an analysis workflow. The examples below demonstrate
creating the list as file paths or as exported data frames from the
import functions. Examples in the vignettes show how this list can be
used as alternative input using the `fset` argument.

``` r
# a list of input file paths
fsetls <- list(
  res = respth, 
  acc = accpth,
  frecom = frecompth,
  sit = sitpth, 
  wqx = wqxpth,
  cens = censpth
)

# a list of input data frames
fsetls <- list(
  res = resdat, 
  acc = accdat,
  frecom = frecomdat,
  sit = sitdat, 
  wqx = wqxdat, 
  cens = censdat
)
```
