# Query NHD data from an ArcGIS REST service

Query NHD data from an ArcGIS REST service

## Usage

``` r
utilMWRgetnhd(id, bbox, dLevel)
```

## Arguments

- id:

  numeic for the layer ID to query, one of 6 (flowlines), 9 (areas large
  scale), or 12 (waterbodies large scale)

- bbox:

  list for the bounding box defined with elements xmin, ymin, xmax, ymax
  in EPSG:4326 coordinates

- dLevel:

  character string for the desired visibiliyt leevel, one of "high",
  "medium", or "low", see details

## Value

An sf object containing the queried NHD features.

## Details

Function returns NHD spatial features from the ArcGIS REST service at
<https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer>. The
function allows querying specific layers (flowlines, areas, waterbodies)
within a defined bounding box and SQL filtering.

The visibilityFilter attribute is used to determine the detail level of
the features returned. If dLevel is "low", features with
visibilityFilter \>= 1,000,000 are returned; if "medium", features with
visibilityFilter \>= 500,000; and if "high", features \>= 100,000 are
returned. The filter only applies to flowlines (layer ID 6).

## Examples

``` r
# Define bounding box (EPSG:4326)
bbox <- list(
  xmin = -71.65734,
  ymin = 42.26945,
  xmax = -71.39113,
  ymax = 42.46594
)

if (FALSE) { # \dontrun{
flowlines <- utilMWRgetnhd(
  id = 6,
  bbox = bbox,
  dLevel = 'low'
)

area <- utilMWRgetnhd(
  id = 9,
  bbox = bbox,
  dLevel = 'low'
)

waterbody <- utilMWRgetnhd(
  id = 12,
  bbox = bbox,
  dLevel = 'low'
)
} # }
```
