# Package index

## Read, check, and format data

Functions for importing, checking, and formatting the results and data
quality objectives data.

- [`readMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)
  : Read water quality monitoring results from an external file
- [`readMWRresultsview()`](https://massbays-tech.github.io/MassWateR/reference/readMWRresultsview.md)
  : Create summary spreadsheet of the water quality monitoring results
- [`checkMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md)
  : Check water quality monitoring results
- [`formMWRresults()`](https://massbays-tech.github.io/MassWateR/reference/formMWRresults.md)
  : Format water quality monitoring results
- [`readMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)
  : Read data quality objectives for accuracy from an external file
- [`checkMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md)
  : Check data quality objective accuracy data
- [`formMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/formMWRacc.md)
  : Format data quality objective accuracy data
- [`readMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/readMWRfrecom.md)
  : Read data quality objectives for frequency and completeness from an
  external file
- [`checkMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRfrecom.md)
  : Check data quality objective frequency and completeness data
- [`formMWRfrecom()`](https://massbays-tech.github.io/MassWateR/reference/formMWRfrecom.md)
  : Format data quality objective frequency and completeness data
- [`readMWRsites()`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md)
  : Read site metadata from an external file
- [`checkMWRsites()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md)
  : Check site metadata file
- [`readMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/readMWRwqx.md)
  : Read water quality exchange (wqx) metadata input from an external
  file
- [`checkMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRwqx.md)
  : Check water quality exchange (wqx) metadata input
- [`formMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/formMWRwqx.md)
  : Format WQX metadata input
- [`readMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/readMWRcens.md)
  : Read censored data from an external file
- [`checkMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/checkMWRcens.md)
  : Check censored data
- [`formMWRcens()`](https://massbays-tech.github.io/MassWateR/reference/formMWRcens.md)
  : Format censored data

## Outlier analysis

Functions for evaluating outliers as plots and generating tabular
output.

- [`anlzMWRoutlier()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRoutlier.md)
  : Analyze outliers in results file
- [`anlzMWRoutlierall()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRoutlierall.md)
  : Analyze outliers in results file for all parameters

## Quality control checks, table and report creation

Functions for running quality control checks, generating tables, and
creating the overall report.

- [`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
  : Create the quality control review report
- [`qcMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRacc.md)
  : Run quality control accuracy checks for water quality monitoring
  results
- [`tabMWRacc()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRacc.md)
  : Create a formatted table of quality control accuracy checks
- [`qcMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRfre.md)
  : Run quality control frequency checks for water quality monitoring
  results
- [`tabMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRfre.md)
  : Create a formatted table of quality control frequency checks
- [`qcMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRcom.md)
  : Run quality control completeness checks for water quality monitoring
  results
- [`tabMWRcom()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRcom.md)
  : Create a formatted table of quality control completeness checks
- [`tabMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRwqx.md)
  : Create and save tables in a single workbook for WQX upload

## General analysis

Functions for creating analysis plots of the results data.

- [`anlzMWRseason()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRseason.md)
  : Analyze seasonal trends in results file
- [`anlzMWRdate()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRdate.md)
  : Analyze trends by date in results file
- [`anlzMWRsite()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRsite.md)
  : Analyze data by sites in results file
- [`anlzMWRmap()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRmap.md)
  : Analyze results with maps

## Utility functions

This is a collection of functions used internally by all other
functions. They are not to be called directly.

- [`utilMWRfilter()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRfilter.md)
  : Filter results data by parameter, date range, site, result
  attributes, and/or location group

- [`utilMWRfiltersurface()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRfiltersurface.md)
  : Filter results data to surface measurements

- [`utilMWRfre()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRfre.md)
  : Prep results data for frequency checks

- [`utilMWRgetnhd()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRgetnhd.md)
  : Query NHD data from an ArcGIS REST service

- [`utilMWRhttpgrace()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRhttpgrace.md)
  : Load external file from remote source, fail gracefully

- [`utilMWRinput()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinput.md)
  : Utility function to import data as paths or data frames

- [`utilMWRinputcheck()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRinputcheck.md)
  : Check if required inputs are present for a function

- [`utilMWRlimits()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRlimits.md)
  : Fill results data as BDL or AQL with appropriate values

- [`utilMWRoutlier()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRoutlier.md)
  : Identify outliers in a numeric vector

- [`utilMWRsheet()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRsheet.md)
  : Format a list of QC tables for spreadsheet export

- [`utilMWRsumfun()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRsumfun.md)
  : Verify summary function

- [`utilMWRsummary()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRsummary.md)
  : Summarize a results data frame by a grouping variable

- [`utilMWRthresh()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRthresh.md)
  : Get threshold lines from thresholdMWR

- [`utilMWRtitle()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRtitle.md)
  : Format the title for analyze functions

- [`utilMWRvaluerange()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRvaluerange.md)
  :

  Check if incomplete range in `Value Range` column

- [`utilMWRyscale()`](https://massbays-tech.github.io/MassWateR/reference/utilMWRyscale.md)
  : Get logical value for y axis scaling

## Supplementary datasets

Supplementary datasets for the read, quality control, and analysis
functions.

- [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)
  : Master parameter list and units for Characteristic Name column in
  results data
- [`thresholdMWR`](https://massbays-tech.github.io/MassWateR/reference/thresholdMWR.md)
  : Master thresholds list for analysis of results data
