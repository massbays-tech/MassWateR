# MassWateR 2.1.5

* Added check to `checkMWRresults()` for results data to verify all values in the quantitation limit column are numbers, with updated instructions in the results template file
* Parameter list (`paramMWR`) updated with Pycocyanin, Phycocyanin (probe), RFU as unit for chlorophyll, including appropriate updates to `thresholdMWR`, results template, and WQX phys-chem template
* Removed prettymapr, raster, added maptile and tidyterra for `anlzMWRmap()` basemaps, this changes the options that are accepted by the `maptype` argument

# MassWateR 2.1.4

* Improved warning message for all empty or `na` entries in `checkMWRacc()` and `checkMWRfrecom()`
* Fixed spelling of `tabMWRwqx()` output in the `Result Detection Condition` column for "Present Above Quantification Limit"
* Fix to `checkMWRacc()` if more than two value ranges in DQO accuracy file as ascending, previously resulted in error
* Fix to incorrect parameter paste in error message in `checkMWRfrecom()` if values less than 0 or greater than 100 are found
* Improved tests to check error or warning messages for `checkMWRfrecom()` and `checkMWRacc()`

# MassWateR 2.1.3

* `anlzMWRmap()` has different basemap options using the `maptype` argument, these include `"cartolight"`, `"cartodark"`, `"osm"`, or `"hotstyle"`. These changes accommodate recent issues with access to stamen tiles.
* ggmap dependency was removed, added raster and prettymapr dependencies
* Fixed issue in Roxygen documentation for itemized lists

# MassWateR 2.1.2

* Warning is now returned if a column for a QC check includes all `na` entries on import of the DQO accuracy file with `readMWRacc()`
* `readMWRacc()` no longer uses `dplyr::na_if()` on all columns, only for numeric, to correctly identify columns that have all `na` entries for a QC check
* Sorting behavior for `dplyr::arrange()` reverted to `.locale = 'en'` to ignore case
* `utilMWRfre()` function added to prep results data for frequency checks, similar to existing `utilMWRlimits()` function
* Correct number of data records is now reported by `tabMWRfre()` following value range filtering
* `tabMWRfre()` and `qcMWRfre()` now require the DQO accuracy file as input to identify appropriate ranges to check for each parameter using the value range column
* Added `utilMWRvaluerange()` function to check for `na`, gaps, and overlap in the value range column on import of the DQO accuracy file with `readMWRacc()`
* Error is now returned if overlapping value ranges are present in the DQO accuracy file
* Warning now returned if gaps are present in the value ranges for a parameter in the DQO accuracy file
* Fix to `checkMWRacc()` to convert MDL and UQL columns in DQO accuracy as numeric following import as text
* Fixed bug to evaluate lab spike QC checks as the absolute difference, was previously a relative difference
* New error message if the upper value range in the DQO accuracy file is not a percent value for lab spike QC checks with units as percentage
* Lab spikes entered as a percent measure are now always evaluated against the data quality objective for the upper value range
* Better error and warning messages for `tabMWRacc()` for incorrect and required data for individual QC checks

# MassWateR 2.1.1

* Fix to incorrect secondary label for Enterococcus in `thresholdMWR`
* Corrected column name to `Record ID User Supplied` in WQX output from `tabMWRwqx()`
* Fix for `tabMWRwqx()` output if no entries in `QC Reference Value` column in the results file, this previously resulted in an error
* `formMWRresults()` no longer imports dplyr and tidyr in Roxygen documentation
* `formMWRresults()` now handles time and text inputs for `Activity Start Time` from Excel, all times are correctly formatted as HH:MM in 24 hour time.  This includes more robust testing of inputs in `text-formMWRresults.R`.
* Added check for data quality objectives for accuracy that returns an error if `na` entries are included in the `Value Range` column, should be `all`

# MassWateR 2.1.0

* Added option to report mean, median, min, max, or geometric mean in summary plots and maps
* Updated `utilMWRtitle()` function to accommodate the previous point
* Replaced `utilMWRconfint()` function with `utilMWRsummary()` for additional summary functions
* Added option to change the scale bar from km to mi on the map created with `anlzMWRmap()`
* Added option to reverse the color ramp in the legend created with `anlzMWRmap()`
* All columns in the results file are now required on input with `readMWRresults()`, this includes a new column `Local Record ID`
* Added a new check for depth data in the results file used by `checkMWRresults()`, must be present with no missing values
* Removed cryptic error messages when confidence intervals cannot be plotted, replaced with informative warning
* Fix to `qcMWRacc()` if output list elements return a data frame with zero rows
* Fix to output message that was creating duplicates when a file is saved to disk
* Fixed incorrect entry description for E. coli in `thresholdMWR`
* Data input template files and example files updated
* Created a vignette about the utility functions and added an example using `patchwork` in the modifying plots vignette

# MassWateR 2.0.2

* `utilMWRfilter` has fix to date filter and no longer uses `lubridate::ymd`
* All but one test removed for `utilMWRfilter`, covered in other tests
* Text for modifying vignette edited for better examples
* Out of state article to vignettes
* Added `utilMWRhttpgrace` for graceful fails if http requests do not work, applies to `anlzMWRmap`

# MassWateR 2.0.1

* Removed all uses of `case_when` and replaced with base `ifelse`, this was to address performance issues with dplyr v1.1.0
* System files for examples replaced with real data
* Slight change to method id and method context logic in `tabMWRwqx`
* Functions that write files (e.g., `qcMWRreview`) require explicit entry for the `output_dir` argument
* `anlzMWRmap` now imports NHD layers from external source (no user changes)
* Added a `NEWS.md` file to track changes to the package.

# MassWateR 2.0.0

* Initial CRAN release following beta testing
