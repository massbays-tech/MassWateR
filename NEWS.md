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
