# MassWateR

<!-- badges: start -->
[![R-CMD-check](https://github.com/massbays-tech/MassWateR/workflows/R-CMD-check/badge.svg)](https://github.com/massbays-tech/MassWateR/actions)
[![pkgdown](https://github.com/massbays-tech/MassWateR/workflows/pkgdown/badge.svg)](https://github.com/massbays-tech/MassWateR/actions)
[![Codecov test coverage](https://codecov.io/gh/massbays-tech/MassWateR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/massbays-tech/MassWateR?branch=main)
[![CRAN status](https://www.r-pkg.org/badges/version/MassWateR)](https://CRAN.R-project.org/package=MassWateR)
[![](https://cranlogs.r-pkg.org/badges/grand-total/MassWateR)](https://cran.r-project.org/package=MassWateR)
<!-- badges: end -->

R package for working with Massachusetts surface water quality data, created in partnership by the [Mass Bays National Estuary Partnership](https://massbays.org/).

Please cite the package as: 

Beck, M.W., Wetherill, B., Carr, J. 2023. MassWateR: Improving Quality Control, Analysis, and Sharing of
Water Quality Data. PLOS ONE. 18(11):e0293737. doi: [10.1371/journal.pone.0293737](https://doi.org/10.1371/journal.pone.0293737)

## Installation

The package can be installed as follows:

``` r
# Install the package
install.packages("MassWateR")
```

Windows PC users may encounter the following warning when installing MassWateR.

```r
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding: https://cran.r-project.org/bin/windows/Rtools/
```

This warning can be ignored for the MassWateR solution.  If desired, RTools can be obtained following the instructions <a rel="canonical" href="https://cran.r-project.org/bin/windows/Rtools/" target="_blank">here</a>.

## Using the package

Please see the vignette articles for an overview of how to use functions in the MassWateR package.  The vignettes are organized topically as follows: 

* [MassWateR quick start](https://massbays-tech.github.io/MassWateR/articles/MassWateR.html): A quick start guide to importing data and using the various functions in MassWateR. Detailed information is provided in the other vignettes.
* [MassWateR data input and checks](https://massbays-tech.github.io/MassWateR/articles/inputs.html): Information on datasets required to use the package, the required formats and how to import them into R, and the checks that are run when the data are imported.
* [MassWateR outlier checks](https://massbays-tech.github.io/MassWateR/articles/outlierchecks.html): Information on evaluating outliers in the results data for surface water quality.
* [MassWateR quality control functions](https://massbays-tech.github.io/MassWateR/articles/qcoverview.html): Information on using the quality control functions to assess completeness and accuracy of results data for surface water quality and to generate automated reports.
* [MassWateR analysis functions](https://massbays-tech.github.io/MassWateR/articles/analysis.html): Information on using the analysis functions to evaluate trends, summaries, and maps in the results data for surface water quality.
* [MassWateR utility functions](https://massbays-tech.github.io/MassWateR/articles/utility.html): Information on using optional utility functions for custom analyses.
* [Modifying plots](https://massbays-tech.github.io/MassWateR/articles/modifying.html): A short tutorial on modifying plots created with MassWateR.
* [Water Quality Exchange output](https://massbays-tech.github.io/MassWateR/articles/wqx.html): Information on generating output that will facilitate upload of data to the EPA Water Quality Exchange
* [Out of state?](https://massbays-tech.github.io/MassWateR/articles/outofstate.html): MassWateR can be used anywhere and this article describes some tips for using the package outside of Massachusetts.

In addition to the content on this web page, the MassWateR Community of Practice forum is a space for users to find help, share ideas, and suggest improvements for the package.  Please follow the <a href="https://massbays.discourse.group/login" target="_blank">link</a> to register and login to the forum.

## Issues and help 

Please report any issues (bugs or errors) on the [issues link](https://github.com/massbays-tech/MassWateR/issues) for the repository.  Please visit the <a href="https://massbays.discourse.group/login" target="_blank">Community of Practice</a> forum for general questions, help, sharing ideas, or to suggest package improvements.

## Contributing 

Please view our [contributing](https://github.com/massbays-tech/MassWateR/blob/master/.github/CONTRIBUTING.md) guidelines for any changes or pull requests.

## Code of Conduct
  
Please note that the MassWateR project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
