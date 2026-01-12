# Analyze results with maps

Analyze results with maps

## Usage

``` r
anlzMWRmap(
  res = NULL,
  param,
  acc = NULL,
  sit = NULL,
  fset = NULL,
  site = NULL,
  resultatt = NULL,
  locgroup = NULL,
  dtrng = NULL,
  ptsize = 4,
  repel = TRUE,
  labsize = 3,
  palcol = "Greens",
  palcolrev = FALSE,
  sumfun = "auto",
  crs = 4326,
  zoom = 11,
  addwater = "medium",
  watercol = "lightblue",
  maptype = NULL,
  buffdist = 2,
  scaledist = "km",
  northloc = "tl",
  scaleloc = "br",
  latlon = TRUE,
  useapi = FALSE,
  ttlsize = 1.2,
  bssize = 11,
  runchk = TRUE,
  warn = TRUE
)
```

## Arguments

- res:

  character string of path to the results file or `data.frame` for
  results returned by
  [`readMWRresults`](https://massbays-tech.github.io/MassWateR/reference/readMWRresults.md)

- param:

  character string of the parameter to plot, must conform to entries in
  the `"Simple Parameter"` column of
  [`paramsMWR`](https://massbays-tech.github.io/MassWateR/reference/paramsMWR.md)

- acc:

  character string of path to the data quality objectives file for
  accuracy or `data.frame` returned by
  [`readMWRacc`](https://massbays-tech.github.io/MassWateR/reference/readMWRacc.md)

- sit:

  character string of path to the site metadata file or `data.frame` of
  site metadata returned by
  [`readMWRsites`](https://massbays-tech.github.io/MassWateR/reference/readMWRsites.md)

- fset:

  optional list of inputs with elements named `res`, `acc`, `frecom`,
  `sit`, or `wqx` overrides the other arguments

- site:

  character string of sites to include, default all

- resultatt:

  character string of result attributes to plot, default all

- locgroup:

  character string of location groups to plot from the
  `"Location Group"` column in the site metadata file, default all

- dtrng:

  character string of length two for the date ranges as YYYY-MM-DD,
  default all

- ptsize:

  numeric for size of the points, use a negative value to omit the
  points

- repel:

  logical indicating if overlapping site labels are offset

- labsize:

  numeric for size of the site labels

- palcol:

  character string indicating the color palette to be used from
  [RColorBrewer](https://r-graph-gallery.com/38-rcolorbrewers-palettes.html),
  see details

- palcolrev:

  logical indicating if color palette in `palcol` is reversed

- sumfun:

  character indicating one of `"auto"` (default), `"mean"`, `"geomean"`,
  `"median"`, `"min"`, or `"max"`, see details

- crs:

  numeric as a four-digit EPSG number for the coordinate reference
  system, see details

- zoom:

  numeric indicating resolution of the base map, see details

- addwater:

  character string as `"low"`, `"medium"` (default), `"high"`, or `NULL`
  (to suppress) to include water features with varying detail from the
  National Hydrography dataset, see details

- watercol:

  character string of color for water objects if `addwater` is not
  `NULL`

- maptype:

  character string indicating the basemap type, see details

- buffdist:

  numeric for buffer around the bounding box for the selected sites in
  kilometers, see details

- scaledist:

  character string indicating distance unit for the scale bar, `"km"` or
  `"mi"`

- northloc:

  character string indicating location of the north arrow, see details

- scaleloc:

  character string indicating location of the scale bar, see details

- latlon:

  logical to include latitude and longitude labels on the plot, default
  `TRUE`

- useapi:

  logical to use API to retrieve water features if `addwater` is not
  `NULL`

- ttlsize:

  numeric value indicating font size of the title relative to other text
  in the plot

- bssize:

  numeric for overall plot text scaling, passed to
  [`theme_gray`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

- runchk:

  logical to run data checks with
  [`checkMWRresults`](https://massbays-tech.github.io/MassWateR/reference/checkMWRresults.md),
  [`checkMWRacc`](https://massbays-tech.github.io/MassWateR/reference/checkMWRacc.md),
  or
  [`checkMWRsites`](https://massbays-tech.github.io/MassWateR/reference/checkMWRsites.md),
  applies only if `res`, `acc`, or `sit` are file paths

- warn:

  logical to return warnings to the console (default)

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object
that can be further modified.

## Details

This function creates a map of summarized results for a selected
parameter at each monitoring site. By default, all dates for the
parameter are averaged. Options to filter by site, date range, and
result attribute are provided. Only sites with spatial information in
the site metadata file are plotted and a warning is returned for those
that do not have this information. The site labels are also plotted next
to each point. The labels can be suppressed by setting `labsize = NULL`.

Any acceptable color palette from
[RColorBrewer](https://r-graph-gallery.com/38-rcolorbrewers-palettes.html)
can be used for `palcol`, which is passed to the `palette` argument in
[`scale_fill_distiller`](https://ggplot2.tidyverse.org/reference/scale_brewer.html).
These could include any of the sequential color palettes, e.g.,
`"Greens"`, `"Blues"`, etc. The diverging and qualitative palettes will
also work, but may return uninterpretable color scales. The palette can
be reversed by setting `palcolrev = TRUE`.

The default value for `crs` is EPSG 4326 for the WGS 84 projection in
decimal degrees. The `crs` argument is passed to
[`st_as_sf`](https://r-spatial.github.io/sf/reference/st_as_sf.html) and
any acceptable CRS appropriate for the data can be used.

The results shown on the map represent the parameter summary for each
site within the date range provided by `dtrng`. If `sumfun = "auto"`
(default), the mean is used where the distribution is determined
automatically from the data quality objective file for accuracy, i.e.,
parameters with "log" in any of the columns are summarized with the
geometric mean, otherwise arithmetic. Any other valid summary function
will be applied if passed to `sumfun` (`"mean"`, `"geomean"`,
`"median"`, `"min"`, `"max"`), regardless of the information in the data
quality objective file for accuracy.

Using `addwater = "medium"` (default) will include lines and polygons of
natural water bodies defined using the National Hydrography Dataset
(NHD). The level of detail can be changed to low or high using
`addwater = "low"` or `addwater = "high"`, respectively. Use
`addwater = NULL` to not show any water features.

A base map can be plotted using the `maptype` argument. The `zoom` value
specifies the resolution of the map. Use higher values to download map
tiles with greater resolution, although this increases the download
time. The `maptype` argument describes the type of base map to download.
Acceptable options include `"OpenStreetMap"`, `"OpenStreetMap.DE"`,
`"OpenStreetMap.France"`, `"OpenStreetMap.HOT"`, `"OpenTopoMap"`,
`"Esri.WorldStreetMap"`, `"Esri.DeLorme"`, `"Esri.WorldTopoMap"`,
`"Esri.WorldImagery"`, `"Esri.WorldTerrain"`,
`"Esri.WorldShadedRelief"`, `"Esri.OceanBasemap"`,
`"Esri.NatGeoWorldMap"`, `"Esri.WorldGrayCanvas"`, `"CartoDB.Positron"`,
`"CartoDB.PositronNoLabels"`, `"CartoDB.PositronOnlyLabels"`,
`"CartoDB.DarkMatter"`, `"CartoDB.DarkMatterNoLabels"`,
`"CartoDB.DarkMatterOnlyLabels"`, `"CartoDB.Voyager"`,
`"CartoDB.VoyagerNoLabels"`, or `"CartoDB.VoyagerOnlyLabels"`. Use
`maptype = NULL` to suppress the base map.

The area around the summarized points can be increased or decreased
using the `buffdist` argument. This creates a buffered area around the
bounding box for the points, where the units are kilometers.

A north arrow and scale bar are also placed on the map as defined by the
`northloc` and `scaleloc` arguments. The placement for both can be
chosen as `"tl"`, `"tr"`, `"bl"`, or `"br"` for top-left, top-right,
bottom-left, or bottom-right respectively. Setting either of the
arguments to `NULL` will suppress the placement on the map.

## Examples

``` r
# results data path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# results data
resdat <- readMWRresults(respth)
#> Running checks on results data...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking valid Activity Types... OK
#>  Checking Activity Start Date formats... OK
#>  Checking depth data present... OK
#>  Checking for non-numeric values in Activity Depth/Height Measure... OK
#>  Checking Activity Depth/Height Unit... OK
#>  Checking Activity Relative Depth Name formats... OK
#>  Checking values in Activity Depth/Height Measure > 1 m / 3.3 ft... OK
#>  Checking Characteristic Name formats... OK
#>  Checking Result Values... OK
#>  Checking for non-numeric values in Quantitation Limit... OK
#>  Checking QC Reference Values... OK
#>  Checking for missing entries for Result Unit... OK
#>  Checking if more than one unit per Characteristic Name... OK
#>  Checking acceptable units for each entry in Characteristic Name... OK
#> 
#> All checks passed!

# accuracy path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', package = 'MassWateR')

# accuracy data
accdat <- readMWRacc(accpth)
#> Running checks on data quality objectives for accuracy...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking column types... OK
#>  Checking no "na" in Value Range... OK
#>  Checking for text other than <=, ≤, <, >=, ≥, >, ±, %, AQL, BQL, log, or all... OK
#>  Checking overlaps in Value Range... OK
#>  Checking gaps in Value Range... OK
#>  Checking Parameter formats... OK
#>  Checking for missing entries for unit (uom)... OK
#>  Checking if more than one unit (uom) per Parameter... OK
#>  Checking acceptable units (uom) for each entry in Parameter... OK
#>  Checking empty columns... OK
#> 
#> All checks passed!

# site data path
sitpth <- system.file('extdata/ExampleSites.xlsx', package = 'MassWateR')

# site data
sitdat <- readMWRsites(sitpth)
#> Running checks on site metadata...
#>  Checking column names... OK
#>  Checking all required columns are present... OK
#>  Checking for missing latitude or longitude values... OK
#>  Checking for non-numeric values in latitude... OK
#>  Checking for non-numeric values in longitude... OK
#>  Checking for positive values in longitude... OK
#>  Checking for missing entries for Monitoring Location ID... OK
#> 
#> All checks passed!

# \donttest{
# map with NHD water bodies
anlzMWRmap(res = resdat, param = 'DO', acc = accdat, sit = sitdat, addwater = 'medium')

# }
```
