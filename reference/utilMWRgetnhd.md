# Query NHD data from an ArcGIS REST service

Query NHD data from an ArcGIS REST service

## Usage

``` r
utilMWRgetnhd(id, bbox, dLevel, quiet = TRUE)
```

## Arguments

- id:

  numeric for the layer ID to query, one of 6 (flowlines), 9 (areas
  large scale), or 12 (waterbodies large scale)

- bbox:

  list for the bounding box defined with elements xmin, ymin, xmax, ymax
  in EPSG:4326 coordinates

- dLevel:

  character string for the desired visibiliyt leevel, one of "high",
  "medium", or "low", see details

- quiet:

  logical, if FALSE progress messages are printed to the console

## Value

An sf object containing the queried NHD features.

## Details

Function returns NHD spatial features from the ArcGIS REST service at
<https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer>. The
function allows querying specific layers (flowlines, areas, waterbodies)
within a defined bounding box and SQL filtering.

The `dLevel` argument defines the level of detail in the retrieved data.
For `id = 6`, the visibilityFilter attribute is used to determine the
detail level. If dLevel is "low", features with visibilityFilter \>=
1,000,000 are returned; if "medium", features with visibilityFilter \>=
500,000; and if "high", features \>= 100,000 are returned. For
`id = 12`, the SHAPE_Area attribute is used. If dLevel is "low",
features with SHAPE_Area \>= 300,000 are returned; if "medium", features
with SHAPE_Area \>= 85,000; and if "high", features with SHAPE_Area \>=
10,000 are returned. No additional filtering based on detail level is
applied if `id = 9`.

## Examples

``` r
# Define bounding box (EPSG:4326)
bbox <- data.frame(
   x = c(-71.65734, -71.39113),
   y = c(42.26945, 42.46594)
 )
bbox <- sf::st_as_sf(bbox, coords = c("x", "y"), crs = 4326)
bbox <- sf::st_bbox(bbox)

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
