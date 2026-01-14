test_that("utilMWRgetnhd returns flowlines correctly", {
  
  # Mock response data
  mock_response_content <- jsonlite::toJSON(list(
    geometryType = "esriGeometryPolyline",
    features = list(
      list(
        attributes = list(visibilityfilter = 1000000),
        geometry = list(
          paths = list(
            list(
              list(-71.5, 42.3),
              list(-71.4, 42.4)
            )
          )
        )
      )
    )
  ), auto_unbox = TRUE)
  
  mock_response <- list(status_code = 200)
  class(mock_response) <- "response"
  
  mockery::stub(utilMWRgetnhd, "httr::GET", mock_response)
  mockery::stub(utilMWRgetnhd, "httr::status_code", 200)
  mockery::stub(utilMWRgetnhd, "httr::content", mock_response_content)
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  result <- utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low")
  
  expect_s3_class(result, "sf")
  expect_equal(as.character(sf::st_geometry_type(result, by_geometry = FALSE)), "LINESTRING")
  expect_equal(nrow(result), 1)
  expect_true("visibilityfilter" %in% names(result))
})

test_that("utilMWRgetnhd returns waterbodies correctly", {
  
  mock_response_content <- jsonlite::toJSON(list(
    geometryType = "esriGeometryPolygon",
    features = list(
      list(
        attributes = list(visibilityfilter = 1000000, SHAPE_Area = 50000),
        geometry = list(
          rings = list(
            list(
              list(-71.5, 42.3),
              list(-71.4, 42.3),
              list(-71.4, 42.4),
              list(-71.5, 42.4),
              list(-71.5, 42.3)
            )
          )
        )
      )
    )
  ), auto_unbox = TRUE)
  
  mock_response <- list(status_code = 200)
  class(mock_response) <- "response"
  
  mockery::stub(utilMWRgetnhd, "httr::GET", mock_response)
  mockery::stub(utilMWRgetnhd, "httr::status_code", 200)
  mockery::stub(utilMWRgetnhd, "httr::content", mock_response_content)
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  result <- utilMWRgetnhd(id = 12, bbox = bbox, dLevel = "medium")
  
  expect_s3_class(result, "sf")
  expect_equal(as.character(sf::st_geometry_type(result, by_geometry = FALSE)), "POLYGON")
  expect_equal(nrow(result), 1)
  expect_true(all(c("visibilityfilter", "SHAPE_Area") %in% names(result)))
})

test_that("utilMWRgetnhd returns areas correctly", {
  
  mock_response_content <- jsonlite::toJSON(list(
    geometryType = "esriGeometryPolygon",
    features = list(
      list(
        attributes = list(visibilityfilter = 5000000, SHAPE_Area = 100000),
        geometry = list(
          rings = list(
            list(
              list(-71.5, 42.3),
              list(-71.4, 42.3),
              list(-71.4, 42.4),
              list(-71.5, 42.4),
              list(-71.5, 42.3)
            )
          )
        )
      )
    )
  ), auto_unbox = TRUE)
  
  mock_response <- list(status_code = 200)
  class(mock_response) <- "response"
  
  mockery::stub(utilMWRgetnhd, "httr::GET", mock_response)
  mockery::stub(utilMWRgetnhd, "httr::status_code", 200)
  mockery::stub(utilMWRgetnhd, "httr::content", mock_response_content)
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  result <- utilMWRgetnhd(id = 9, bbox = bbox, dLevel = "low")
  
  expect_s3_class(result, "sf")
  expect_equal(as.character(sf::st_geometry_type(result, by_geometry = FALSE)), "POLYGON")
  expect_true("SHAPE_Area" %in% names(result))
})

test_that("utilMWRgetnhd returns NULL when no features found", {
  
  mock_response_content <- jsonlite::toJSON(list(
    geometryType = "esriGeometryPolyline",
    features = list()
  ), auto_unbox = TRUE)
  
  mock_response <- list(status_code = 200)
  class(mock_response) <- "response"
  
  mockery::stub(utilMWRgetnhd, "httr::GET", mock_response)
  mockery::stub(utilMWRgetnhd, "httr::status_code", 200)
  mockery::stub(utilMWRgetnhd, "httr::content", mock_response_content)
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  result <- utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low")
  
  expect_null(result)
})

test_that("utilMWRgetnhd throws error on failed request", {
  
  mock_response <- list(status_code = 500)
  class(mock_response) <- "response"
  
  mockery::stub(utilMWRgetnhd, "httr::GET", mock_response)
  mockery::stub(utilMWRgetnhd, "httr::status_code", 500)
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  expect_error(
    utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low"),
    "Request failed with status: 500"
  )
})

test_that("utilMWRgetnhd validates id parameter", {
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  expect_error(
    utilMWRgetnhd(id = 11, bbox = bbox, dLevel = "low"),
    "'arg' should be one of"
  )
})

test_that("utilMWRgetnhd applies correct visibility filters", {
  
  mock_response <- list(status_code = 200)
  class(mock_response) <- "response"
  
  mock_get <- mockery::mock(mock_response, mock_response, mock_response)
  
  mockery::stub(utilMWRgetnhd, "httr::GET", mock_get)
  mockery::stub(utilMWRgetnhd, "httr::status_code", 200)
  mockery::stub(utilMWRgetnhd, "httr::content", jsonlite::toJSON(list(
    geometryType = "esriGeometryPolyline",
    features = list()
  ), auto_unbox = TRUE))
  
  bbox <- list(xmin = -71.6, ymin = 42.2, xmax = -71.3, ymax = 42.5)
  
  utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "low")
  utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "medium")
  utilMWRgetnhd(id = 6, bbox = bbox, dLevel = "high")
  
  calls <- mockery::mock_args(mock_get)
  
  expect_match(calls[[1]][[2]]$where, "fcode = 46006 AND visibilityFilter >= 1e\\+06")
  expect_match(calls[[2]][[2]]$where, "fcode = 46006 AND visibilityFilter >= 5e\\+05")
  expect_match(calls[[3]][[2]]$where, "fcode = 46006 AND visibilityFilter >= 1e\\+05")
})
