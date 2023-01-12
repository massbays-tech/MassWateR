## Test environments

* ubuntu 20.04 (R 4.2.2, R 4.1.3, R devel)
* OS X (R 4.2.2)
* win-builder [http://win-builder.r-project.org/](http://win-builder.r-project.org/) (R 4.2.2, R 4.1.3, R devel)
* local Windows 10 install (R 4.1.3)

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Marcus Beck <mbeck@tbep.org>'

New submission

Found the following (possibly) invalid URLs:
  URL: https://cran.rstudio.com/bin/windows/Rtools/
    From: inst/doc/MassWateR.html
          README.md
    Status: 200
    Message: OK
    CRAN URL not in canonical form
  URL: https://massbays-tech.github.io/MassWateR (moved to https://massbays-tech.github.io/MassWateR/)
    From: DESCRIPTION
    Status: 200
    Message: OK
  URL: https://massbays.discourse.group/c/masswater-r-tools/5
    From: inst/doc/MassWateR.html
          README.md
    Status: 403
    Message: Forbidden
  Canonical CRAN.R-project.org URLs use https.

The URLs are valid.

## Downstream dependencies

None.



