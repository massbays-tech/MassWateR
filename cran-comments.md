## Resubmission

This is a resubmission to fix issues on original CRAN submission, including:

* Reduced length of title and removed redundant text
* Added \value field where missing from .Rd files 
* Removed \dontrun from examples, replaced with \donttest where needed
* Functions in examples/test/vignettes no longer write files to user's home or package file space, nor as default

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

## Downstream dependencies

None.



