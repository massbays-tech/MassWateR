
# Helper function to create mock bbox
create_mock_bbox <- function() {
  bbox <- structure(
    c(xmin = -71.65734, ymin = 42.26945, xmax = -71.39113, ymax = 42.46594),
    class = "bbox",
    crs = structure(list(input = "EPSG:4326"), class = "crs")
  )
  return(bbox)
}

# Helper function to create mock sf object
create_mock_sf <- function(n_features = 10) {
  sf::st_sf(
    visibilityFilter = rep(1000000, n_features),
    geometry = sf::st_sfc(lapply(1:n_features, function(i) {
      sf::st_point(c(-71 + i*0.01, 42 + i*0.01))
    }), crs = 4326)
  )
}

test_that("Layer 6 with low dLevel and pagination works", {
  bbox <- create_mock_bbox()
  
  # Mock first page (1000 features), second page (500 features)
  mock_sf_page1 <- create_mock_sf(1000)
  mock_sf_page2 <- create_mock_sf(500)
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 200)
  mockery::stub(utilMWRgetnhd, 'httr::content', "mock_geojson")
  mockery::stub(utilMWRgetnhd, 'sf::st_read', mock(mock_sf_page1, mock_sf_page2, cycle = FALSE))
  mockery::stub(utilMWRgetnhd, 'sf::st_make_valid', function(x) x)
  mockery::stub(utilMWRgetnhd, 'Sys.sleep', NULL)
  
  result <- utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low")
  
  expect_s3_class(result, "sf")
})

test_that("Layer 6 with medium dLevel works", {
  bbox <- create_mock_bbox()
  mock_sf <- create_mock_sf(10)
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 200)
  mockery::stub(utilMWRgetnhd, 'httr::content', "mock_geojson")
  mockery::stub(utilMWRgetnhd, 'sf::st_read', mock_sf)
  mockery::stub(utilMWRgetnhd, 'sf::st_make_valid', mock_sf)
  mockery::stub(utilMWRgetnhd, 'Sys.sleep', NULL)
  
  result <- utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "medium")
  
  expect_s3_class(result, "sf")
})

test_that("Layer 6 with high dLevel works", {
  bbox <- create_mock_bbox()
  mock_sf <- create_mock_sf(10)
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 200)
  mockery::stub(utilMWRgetnhd, 'httr::content', "mock_geojson")
  mockery::stub(utilMWRgetnhd, 'sf::st_read', mock_sf)
  mockery::stub(utilMWRgetnhd, 'sf::st_make_valid', mock_sf)
  mockery::stub(utilMWRgetnhd, 'Sys.sleep', NULL)
  
  result <- utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "high")
  
  expect_s3_class(result, "sf")
})

test_that("Layer 9 works", {
  bbox <- create_mock_bbox()
  mock_sf <- create_mock_sf(10)
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 200)
  mockery::stub(utilMWRgetnhd, 'httr::content', "mock_geojson")
  mockery::stub(utilMWRgetnhd, 'sf::st_read', mock_sf)
  mockery::stub(utilMWRgetnhd, 'sf::st_make_valid', mock_sf)
  mockery::stub(utilMWRgetnhd, 'Sys.sleep', NULL)
  
  result <- utilMWRgetnhd(id = 9, bbox = bbox, dLevel = "low")
  
  expect_s3_class(result, "sf")
})

test_that("Layer 12 works", {
  bbox <- create_mock_bbox()
  mock_sf <- create_mock_sf(10)
  mock_sf$SHAPE_Area <- runif(10, 1000, 10000)
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 200)
  mockery::stub(utilMWRgetnhd, 'httr::content', "mock_geojson")
  mockery::stub(utilMWRgetnhd, 'sf::st_read', mock_sf)
  mockery::stub(utilMWRgetnhd, 'sf::st_make_valid', mock_sf)
  mockery::stub(utilMWRgetnhd, 'Sys.sleep', NULL)
  
  result <- utilMWRgetnhd(id = 12, bbox = bbox, dLevel = "low")
  
  expect_s3_class(result, "sf")
})

test_that("API error throws error", {
  bbox <- create_mock_bbox()
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 500)
  
  expect_error(
    utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low"),
    "Request failed with status: 500"
  )
})

test_that("Empty results return empty sf object", {
  bbox <- create_mock_bbox()
  empty_sf <- sf::st_sf(geometry = sf::st_sfc(crs = 4326))
  
  mockery::stub(utilMWRgetnhd, 'sf::st_transform', bbox)
  mockery::stub(utilMWRgetnhd, 'httr::GET', list())
  mockery::stub(utilMWRgetnhd, 'httr::status_code', 200)
  mockery::stub(utilMWRgetnhd, 'httr::content', "mock_geojson")
  mockery::stub(utilMWRgetnhd, 'sf::st_read', empty_sf)
  mockery::stub(utilMWRgetnhd, 'Sys.sleep', NULL)
  
  result <- utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low")
  
  expect_s3_class(result, "sf")
  expect_equal(nrow(result), 0)
})