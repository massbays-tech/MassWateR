# MassWateR 2.0.1

* Removed all uses of `case_when` and replaced with base `ifelse`, this was to address performance issues with dplyr v1.1.0
* System files for examples replaced with real data
* Slight change to method id and method context logic in `tabMWRwqx`
* Functions that write files (e.g., `qcMWRreview`) require explicit entry for the `output_dir` argument
* `anlzMWRmap` now imports NHD layers from external source (no user changes)
* Added a `NEWS.md` file to track changes to the package.

# MassWateR 2.0.0

* Initial CRAN release following beta testing
