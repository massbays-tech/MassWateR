# MassWateR

<!-- badges: start -->
[![R-CMD-check](https://github.com/massbays-tech/MassWateR/workflows/R-CMD-check/badge.svg)](https://github.com/massbays-tech/MassWateR/actions)
[![pkgdown](https://github.com/massbays-tech/MassWateR/workflows/pkgdown/badge.svg)](https://github.com/massbays-tech/MassWateR/actions)
[![Codecov test coverage](https://codecov.io/gh/massbays-tech/MassWateR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/massbays-tech/MassWateR?branch=main)
<!-- badges: end -->

R package for working with Massachusetts surface water quality data, created in partnership by the [Mass Bays National Estuary Partnership](https://www.mass.gov/orgs/massachusetts-bays-national-estuary-partnership).

## Installation

The package can be installed as follows:

``` r
# Enable universe(s) by massbays-tech
options(repos = c(
  massbaystech = "https://massbays-tech.r-universe.dev",
  CRAN = "https://cloud.r-project.org"))

# Install the package
install.packages("MassWateR")
```

Windows PC users may encounter the following warning when installing MassWateR.

```r
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding: https://cran.rstudio.com/bin/windows/Rtools/
```

This warning can be ignored.  If desired, RTools can be obtained following the instructions [here](https://cran.rstudio.com/bin/windows/Rtools/).

## Using the package

Please see the vignette articles for an overview of how to use functions in the MassWateR package.  The vignettes are organized topically as follows: 

* [MassWateR data input and checks](https://massbays-tech.github.io/MassWateR/articles/MassWateR.html): Information on datasets required to use the package, the required formats and how to import them into R, and the checks that are run when the data are imported.
* [MassWateR quality control functions](https://massbays-tech.github.io/MassWateR/articles/qcoverview.html): Information on using the quality control functions to assess completeness and accuracy of results data for surface water quality and to generate automated reports.
* [MassWateR outlier checks](https://massbays-tech.github.io/MassWateR/articles/outlierchecks.html): Information on evaluating outliers in the results data for surface water quality.
* [MassWateR analysis functions](https://massbays-tech.github.io/MassWateR/articles/analysis.html): Information on using the analysis functions to evaluate trends, summaries, and maps in the results data for surface water quality.
* [Modifying plots](https://massbays-tech.github.io/MassWateR/articles/modifying.html): A short tutorial on modifying plots created with MassWateR.

## Issues and suggestions 

Please report any issues and suggestions on the [issues link](https://github.com/massbays-tech/MassWateR/issues) for the repository.

## Contributing 

Please view our [contributing](https://github.com/massbays-tech/MassWateR/blob/master/.github/CONTRIBUTING.md) guidelines for any changes or pull requests.

## Code of Conduct
  
Please note that the MassWateR project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
