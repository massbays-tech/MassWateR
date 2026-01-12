# Format the title for analyze functions

Format the title for analyze functions

## Usage

``` r
utilMWRtitle(
  param,
  accdat = NULL,
  sumfun = NULL,
  site = NULL,
  dtrng = NULL,
  resultatt = NULL,
  locgroup = NULL
)
```

## Arguments

- param:

  character string of the parameter to plot

- accdat:

  optional `data.frame` for data quality objectives file for accuracy as
  returned by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- sumfun:

  optional character indicating one of `"auto"`, `"mean"`, `"geomean"`,
  `"median"`, `"min"`, or `"max"`

- site:

  character string of sites to include

- dtrng:

  character string of length two for the date ranges as YYYY-MM-DD

- resultatt:

  character string of result attributes to plot

- locgroup:

  character string of location groups to plot from the
  `"Location Group"` column in the site metadata file

## Value

A formatted character string used for the title in analysis plots

## Details

All arguments are optional except `param`, appropriate text strings are
appended to the `param` argument for all other optional arguments
indicating the level of filtering used in the plot and data summary if
appropriate

## Examples

``` r
# no filters
utilMWRtitle(param = 'DO')
#> [1] "DO"

# filter by date only
utilMWRtitle(param = 'DO', dtrng = c('2021-05-01', '2021-07-31'))
#> [1] "DO, data filtered by dates (1 May, 2021 to 31 July, 2021)"

# filter by all
utilMWRtitle(param = 'DO', site = 'test', dtrng = c('2021-05-01', '2021-07-31'), 
     resultatt = 'test', locgroup = 'test')
#> [1] "DO, data filtered by sites, dates (1 May, 2021 to 31 July, 2021), result attributes, location groups"
     
# title using summary 
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')
accdat <- readMWRacc(accpth, runchk = FALSE)
utilMWRtitle(param = 'DO', accdat = accdat, sumfun = 'auto', site = 'test', 
     dtrng = c('2021-05-01', '2021-07-31'), resultatt = 'test', locgroup = 'test')
#> [1] "DO (mean), data filtered by sites, dates (1 May, 2021 to 31 July, 2021), result attributes, location groups"
```
