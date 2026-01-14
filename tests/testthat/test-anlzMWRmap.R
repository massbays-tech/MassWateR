test_that("Checking output format", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, latlon = FALSE, addwater = "low")
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, one site", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, site = 'ABT-026', addwater = NULL, maptype = 'CartoDB.Positron', zoom = 5)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking warning output", {
  skip_on_cran()
  tst$sitdatchk <- tst$sitdat[!tst$sitdat$`Monitoring Location ID` == 'ABT-077', ]
  expect_warning(anlzMWRmap(res = tst$resdat, param = 'E.coli', acc = tst$accdat, sit = tst$sitdatchk, warn = TRUE, addwater = NULL))
})

test_that("Checking error output no sites to map", {
  expect_error(anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, site = 'HBS-057P'))
})

test_that("Checking output format, no scale bar or north arrow", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, northloc = NULL, scaleloc = NULL, addwater = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking output format, no label repel", {
  skip_on_cran()
  result <- anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, repel = FALSE, addwater = NULL)
  expect_s3_class(result, 'ggplot')
})

test_that("Checking error for addwater input", { 
  expect_error(anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdat, warn = FALSE, addwater = 'xyz'))
})

test_that("Checking missing spatial data", {
  tst$sitdatchk <- tst$sitdat[!tst$sitdat$`Monitoring Location ID` == 'ABT-144', ]
  expect_error(anlzMWRmap(res = tst$resdat, param = 'DO', acc = tst$accdat, sit = tst$sitdatchk, site = 'ABT-144'))
})

test_that("Checking useapi = FALSE with mocked data", {
  skip_on_cran()
  
  # Create mock water feature data
  mock_streams <- sf::st_sf(
    dLevel = "low",
    geometry = sf::st_sfc(sf::st_linestring(matrix(c(-71.5, 42.3, -71.4, 42.4), ncol = 2, byrow = TRUE)), crs = 26986)
  )
  
  mock_rivers <- sf::st_sf(
    dLevel = "low",
    geometry = sf::st_sfc(sf::st_linestring(matrix(c(-71.52, 42.32, -71.42, 42.42), ncol = 2, byrow = TRUE)), crs = 26986)
  )
  
  mock_ponds <- sf::st_sf(
    dLevel = "low",
    geometry = sf::st_sfc(sf::st_polygon(list(matrix(c(-71.5, 42.3, -71.49, 42.3, -71.49, 42.31, -71.5, 42.31, -71.5, 42.3), ncol = 2, byrow = TRUE))), crs = 26986)
  )
  
  mockery::stub(anlzMWRmap, "utilMWRhttpgrace", function(url) {
    if(grepl("streamsMWR", url)) return(mock_streams)
    if(grepl("riversMWR", url)) return(mock_rivers)
    if(grepl("pondsMWR", url)) return(mock_ponds)
  })
  
  result <- anlzMWRmap(
    res = tst$resdat, 
    param = 'DO', 
    acc = tst$accdat, 
    sit = tst$sitdat, 
    warn = FALSE, 
    addwater = "low",
    useapi = FALSE,
    maptype = NULL
  )
  
  expect_s3_class(result, 'ggplot')
})

test_that("Checking useapi = TRUE with mocked API calls", {
  skip_on_cran()
  
  # Mock streams response
  mock_streams <- sf::st_sf(
    visibilityFilter = 1000000,
    geometry = sf::st_sfc(sf::st_linestring(matrix(c(-71.5, 42.3, -71.4, 42.4), ncol = 2, byrow = TRUE)), crs = 4326)
  )
  
  # Mock rivers response
  mock_rivers <- sf::st_sf(
    visibilityFilter = 1000000,
    SHAPE_Area = 100000,
    geometry = sf::st_sfc(sf::st_polygon(list(matrix(c(-71.5, 42.3, -71.49, 42.3, -71.49, 42.31, -71.5, 42.31, -71.5, 42.3), ncol = 2, byrow = TRUE))), crs = 4326)
  )
  
  # Mock ponds response
  mock_ponds <- sf::st_sf(
    visibilityFilter = 1000000,
    SHAPE_Area = 50000,
    geometry = sf::st_sfc(sf::st_polygon(list(matrix(c(-71.52, 42.32, -71.51, 42.32, -71.51, 42.33, -71.52, 42.33, -71.52, 42.32), ncol = 2, byrow = TRUE))), crs = 4326)
  )
  
  mockery::stub(anlzMWRmap, "utilMWRgetnhd", function(id, bbox, dLevel) {
    if(id == 6) return(mock_streams)
    if(id == 9) return(mock_rivers)
    if(id == 12) return(mock_ponds)
  })
  
  result <- anlzMWRmap(
    res = tst$resdat, 
    param = 'DO', 
    acc = tst$accdat, 
    sit = tst$sitdat, 
    warn = FALSE, 
    addwater = "medium",
    useapi = TRUE,
    maptype = NULL
  )
  
  expect_s3_class(result, 'ggplot')
})

test_that("Checking useapi = TRUE with NULL returns from API", {
  skip_on_cran()
  
  # Mock all API calls to return NULL (no features found)
  mockery::stub(anlzMWRmap, "utilMWRgetnhd", NULL)
  
  result <- anlzMWRmap(
    res = tst$resdat, 
    param = 'DO', 
    acc = tst$accdat, 
    sit = tst$sitdat, 
    warn = FALSE, 
    addwater = "high",
    useapi = TRUE,
    maptype = NULL
  )
  
  expect_s3_class(result, 'ggplot')
})

