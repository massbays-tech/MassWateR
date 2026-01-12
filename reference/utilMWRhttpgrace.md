# Load external file from remote source, fail gracefully

Load external file from remote source, fail gracefully

## Usage

``` r
utilMWRhttpgrace(remote_file)
```

## Arguments

- remote_file:

  URL of the external file

## Value

The external file as an RData object

## Examples

``` r
# fails gracefully
utilMWRhttpgrace('http://httpbin.org/status/404')
#> Not Found (HTTP 404).
# \donttest{
# imports data or fails gracefully
fl <- 'https://github.com/massbays-tech/MassWateRdata/raw/main/data/streamsMWR.RData'
utilMWRhttpgrace(fl)
#> Simple feature collection with 43158 features and 1 field
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: -46664.23 ymin: 771007.9 xmax: 329961.2 ymax: 1225276
#> Projected CRS: NAD83 / Massachusetts Mainland
#> First 10 features:
#>    dLevel                       geometry
#> 1    high LINESTRING (207092.3 835312...
#> 2    high LINESTRING (207092.3 835312...
#> 3  medium LINESTRING (202241.7 812175...
#> 4  medium LINESTRING (196109.6 847747...
#> 5  medium LINESTRING (200811 840077.9...
#> 6    high LINESTRING (266067.4 997916...
#> 7  medium LINESTRING (239232.9 103612...
#> 8    high LINESTRING (255632.1 100918...
#> 9    high LINESTRING (259221.8 990196...
#> 10   high LINESTRING (231579.5 865498...
# }
```
