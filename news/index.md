# Changelog

## MassWateR 2.2.0

CRAN release: 2025-05-29

- [`utilMWRsheet()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRsheet.md)
  function created to format tabular output if `savesheet = TRUE` for
  [`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
- Vignettes updated to describe optional censored data file as input to
  quality control workflow
- Censored data file can be included as an optional file in
  [`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
  via
  [`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
  and
  [`qcMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRcom.md)
- Complete workflow to import, check, and format censored data file
  using
  [`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md),
  [`checkMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRcens.md),
  and
  [`formMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/formMWRcens.md)
- [`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
  has option to save tables in a spreadsheet using `savesheet = TRUE`
- [`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
  places censored data next to qualified records
- [`readMWRresultsview()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresultsview.md)
  will show `NA` entries if found in a column of the water quality
  results file
- [`checkMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)
  will now return an error (stop) if `NA` found in `Result Value` column
- Training video link added to resources page of website
- [`tabMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRwqx.md)
  has option to return tabular output in a list format using
  `listout = TRUE`
- [`anlzMWRoutlierall()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRoutlierall.md)
  has option to export images in a zipped folder using `format = 'zip'`
- `bssize` argument added to all analysis functions to uniformly change
  font size for all text
- Tests no longer load artifacts into the environment when running
  package dev version locally
- Fixed broken links on web page for downloadable resources

## MassWateR 2.1.5

CRAN release: 2024-10-20

- Added check to
  [`checkMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)
  for results data to verify all values in the quantitation limit column
  are numbers, with updated instructions in the results template file
- Parameter list (`paramMWR`) updated with Pycocyanin, Phycocyanin
  (probe), RFU as unit for chlorophyll, including appropriate updates to
  `thresholdMWR`, results template, and WQX phys-chem template
- Removed prettymapr, raster, added maptile and tidyterra for
  [`anlzMWRmap()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRmap.md)
  basemaps, this changes the options that are accepted by the `maptype`
  argument

## MassWateR 2.1.4

CRAN release: 2023-11-19

- Improved warning message for all empty or `na` entries in
  [`checkMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)
  and
  [`checkMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md)
- Fixed spelling of
  [`tabMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRwqx.md)
  output in the `Result Detection Condition` column for “Present Above
  Quantification Limit”
- Fix to
  [`checkMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)
  if more than two value ranges in DQO accuracy file as ascending,
  previously resulted in error
- Fix to incorrect parameter paste in error message in
  [`checkMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md)
  if values less than 0 or greater than 100 are found
- Improved tests to check error or warning messages for
  [`checkMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md)
  and
  [`checkMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)

## MassWateR 2.1.3

CRAN release: 2023-10-26

- [`anlzMWRmap()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRmap.md)
  has different basemap options using the `maptype` argument, these
  include `"cartolight"`, `"cartodark"`, `"osm"`, or `"hotstyle"`. These
  changes accommodate recent issues with access to stamen tiles.
- ggmap dependency was removed, added raster and prettymapr dependencies
- Fixed issue in Roxygen documentation for itemized lists

## MassWateR 2.1.2

CRAN release: 2023-10-06

- Warning is now returned if a column for a QC check includes all `na`
  entries on import of the DQO accuracy file with
  [`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
- [`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
  no longer uses
  [`dplyr::na_if()`](https://dplyr.tidyverse.org/reference/na_if.html)
  on all columns, only for numeric, to correctly identify columns that
  have all `na` entries for a QC check
- Sorting behavior for
  [`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)
  reverted to `.locale = 'en'` to ignore case
- [`utilMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRfre.md)
  function added to prep results data for frequency checks, similar to
  existing
  [`utilMWRlimits()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRlimits.md)
  function
- Correct number of data records is now reported by
  [`tabMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)
  following value range filtering
- [`tabMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)
  and
  [`qcMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRfre.md)
  now require the DQO accuracy file as input to identify appropriate
  ranges to check for each parameter using the value range column
- Added
  [`utilMWRvaluerange()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRvaluerange.md)
  function to check for `na`, gaps, and overlap in the value range
  column on import of the DQO accuracy file with
  [`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
- Error is now returned if overlapping value ranges are present in the
  DQO accuracy file
- Warning now returned if gaps are present in the value ranges for a
  parameter in the DQO accuracy file
- Fix to
  [`checkMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)
  to convert MDL and UQL columns in DQO accuracy as numeric following
  import as text
- Fixed bug to evaluate lab spike QC checks as the absolute difference,
  was previously a relative difference
- New error message if the upper value range in the DQO accuracy file is
  not a percent value for lab spike QC checks with units as percentage
- Lab spikes entered as a percent measure are now always evaluated
  against the data quality objective for the upper value range
- Better error and warning messages for
  [`tabMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)
  for incorrect and required data for individual QC checks

## MassWateR 2.1.1

CRAN release: 2023-07-16

- Fix to incorrect secondary label for Enterococcus in `thresholdMWR`
- Corrected column name to `Record ID User Supplied` in WQX output from
  [`tabMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRwqx.md)
- Fix for
  [`tabMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRwqx.md)
  output if no entries in `QC Reference Value` column in the results
  file, this previously resulted in an error
- [`formMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/formMWRresults.md)
  no longer imports dplyr and tidyr in Roxygen documentation
- [`formMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/formMWRresults.md)
  now handles time and text inputs for `Activity Start Time` from Excel,
  all times are correctly formatted as HH:MM in 24 hour time. This
  includes more robust testing of inputs in `text-formMWRresults.R`.
- Added check for data quality objectives for accuracy that returns an
  error if `na` entries are included in the `Value Range` column, should
  be `all`

## MassWateR 2.1.0

CRAN release: 2023-06-01

- Added option to report mean, median, min, max, or geometric mean in
  summary plots and maps
- Updated
  [`utilMWRtitle()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRtitle.md)
  function to accommodate the previous point
- Replaced `utilMWRconfint()` function with
  [`utilMWRsummary()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRsummary.md)
  for additional summary functions
- Added option to change the scale bar from km to mi on the map created
  with
  [`anlzMWRmap()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRmap.md)
- Added option to reverse the color ramp in the legend created with
  [`anlzMWRmap()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRmap.md)
- All columns in the results file are now required on input with
  [`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md),
  this includes a new column `Local Record ID`
- Added a new check for depth data in the results file used by
  [`checkMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md),
  must be present with no missing values
- Removed cryptic error messages when confidence intervals cannot be
  plotted, replaced with informative warning
- Fix to
  [`qcMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md)
  if output list elements return a data frame with zero rows
- Fix to output message that was creating duplicates when a file is
  saved to disk
- Fixed incorrect entry description for E. coli in `thresholdMWR`
- Data input template files and example files updated
- Created a vignette about the utility functions and added an example
  using `patchwork` in the modifying plots vignette

## MassWateR 2.0.2

CRAN release: 2023-03-21

- `utilMWRfilter` has fix to date filter and no longer uses
  [`lubridate::ymd`](https://lubridate.tidyverse.org/reference/ymd.html)
- All but one test removed for `utilMWRfilter`, covered in other tests
- Text for modifying vignette edited for better examples
- Out of state article to vignettes
- Added `utilMWRhttpgrace` for graceful fails if http requests do not
  work, applies to `anlzMWRmap`

## MassWateR 2.0.1

CRAN release: 2023-02-06

- Removed all uses of `case_when` and replaced with base `ifelse`, this
  was to address performance issues with dplyr v1.1.0
- System files for examples replaced with real data
- Slight change to method id and method context logic in `tabMWRwqx`
- Functions that write files (e.g., `qcMWRreview`) require explicit
  entry for the `output_dir` argument
- `anlzMWRmap` now imports NHD layers from external source (no user
  changes)
- Added a `NEWS.md` file to track changes to the package.

## MassWateR 2.0.0

CRAN release: 2023-01-20

- Initial CRAN release following beta testing
